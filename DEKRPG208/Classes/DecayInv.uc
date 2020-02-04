class DecayInv extends Inventory
	config(UT2004RPG);

var Pawn PawnOwner;
var Pawn ChainTarget;
var Pawn SecondTarget;

var int AbilityLevel;

var config float DrainInterval, DrainMultiplier, SingleDrainRange, HealthMultiplier;
var config int DrainAmount, DrainMin, DrainMax, DecayBonus, DrainMinDuringPhantom, DrainMaxDuringPhantom;

var int ChainCounter, AmmoCounter;
var config int ChainThreshold;
var bool Chained;
var config float ChainRadius, SecondChainRadius;
var DecayChain ChainOne, ChainTwo;
var DecayGlow GlowOne, GlowTwo;

var int BloodPoints;
var config int MaxBlood;
var config int AmmoRegenAmount, AmmoThreshold;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		Chained, ChainTarget, SecondTarget, BloodPoints;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{

	if(Other == None)
	{
		destroy();
		return;
	}

	Super.GiveTo(Other);
	PawnOwner = Other;

	SetTimer(DrainInterval, true);
	Chained = False;
	ChainCounter = 0;
	BloodPoints = 0;
	AmmoCounter = 0;
}

simulated function Timer()
{
	local Vector FaceDir;
	local Vector BeamEndLocation;
	local vector HitLocation;
	local vector HitNormal;
	local Actor AHit;
	local Pawn  HitPawn;
	local Vector StartTrace;
	local Controller C, SecondC;
	local int MostHealth;
	local Vehicle V;
	
	if (PawnOwner == None || PawnOwner.Health <= 0)
		Destroy();
	
	if (PawnOwner != None)
	{
		V = PawnOwner.DrivenVehicle;
		if (V != None)
			return;
		//See who we're looking at.
		
		FaceDir = Vector(PawnOwner.Controller.GetViewRotation());
		StartTrace = PawnOwner.Location + PawnOwner.EyePosition();
		BeamEndLocation = StartTrace + (FaceDir * SingleDrainRange);
		
		AHit = Trace(HitLocation, HitNormal, BeamEndLocation, StartTrace, true);
		
		if ((AHit == None) || (Pawn(AHit) == None) || (Pawn(AHit).Controller == None))
		{
			HitPawn = None;
			ChainCounter = 0;
		}

		HitPawn = Pawn(AHit);
		if ( HitPawn != None && HitPawn.Controller != None && HitPawn != PawnOwner && HitPawn.Health > 0 && !HitPawn.Controller.SameTeamAs(PawnOwner.Controller)
			 && VSize(HitPawn.Location - StartTrace) < SingleDrainRange && HitPawn.Controller.bGodMode == False && Vehicle(AHit) == None && !HitPawn.IsA('HealerNali') && !HitPawn.IsA('MissionCow') && !HitPawn.IsA('MissionPortalBall') && !HitPawn.IsA('GenomeProjectNode') && !ClassIsChildOf(HitPawn.Class, class'DruidBlock') && !ClassIsChildOf(HitPawn.Class, class'SMPNaliRabbit')
			 && !HitPawn.Controller.bGodMode)
		{
			if (ChainTarget == None || ChainTarget.Health <= 0)
			{
				//don't allow decaying of other targets while we are chained
				Drain(HitPawn);
			}
			
			//Chaining
			if (!Chained)
			{
				ChainCounter++;
				if (ChainCounter >= ChainThreshold)
				{
					Chained = True;
					ChainCounter = 0;
					ChainTarget = HitPawn;
					ChainFXOne(ChainTarget);
				}
			}
		}
		
		//Drain ChainTarget and SecondTarget, no matter if we're looking at them. Break if we move away from them
		if (ChainTarget != None && ChainTarget.Health > 0 && ChainTarget.Controller != None && !ChainTarget.Controller.SameTeamAs(PawnOwner.Controller))
		{
			if (VSize(ChainTarget.Location - PawnOwner.Location) <= ChainRadius && FastTrace(ChainTarget.Location, PawnOwner.Location))
			{
				Drain(ChainTarget);
				ChainFXOne(ChainTarget);
			}
			else
			{
				//Out of range of primary chain. Break it and reset chaining
				ChainTarget = None;
				Chained = False;
				ChainCounter = 0;
				BreakChainOne();
				//If we have a second target, break that chain.
				if (SecondTarget != None)
				{
					SecondTarget = None;
					BreakChainTwo();
				}
			}
		}
		if (SecondTarget != None && SecondTarget.Health > 0 && SecondTarget.Controller != None && !SecondTarget.Controller.SameTeamAs(PawnOwner.Controller))
		{
			if (VSize(SecondTarget.Location - ChainTarget.Location) <= ChainRadius && FastTrace(SecondTarget.Location, ChainTarget.Location))
			{
				Drain(SecondTarget);
				ChainFXTwo(SecondTarget);
			}
			else
			{
				//out of radius for second chain. Break it, but not necessarily the first chain
				SecondTarget = None;
				BreakChainTwo();
			}
		}
		if (Chained)
		{
			if (ChainTarget == None || ChainTarget.Health <= 0)
			{
				BreakChainOne();
				//If we kill primary chain, set the secondary chain as the new primary chain. No penalty for killing the target.
				if (SecondTarget != None)
				{
					ChainTarget = SecondTarget;
					SecondTarget = None;
					ChainFXOne(ChainTarget);
				}
				else
				{
					//We have no secondary chain to turn into the primary chain. Reset the chaining stuff
					ChainCounter = 0;
					Chained = False;
				}
			}
			else if (ChainTarget != None && ChainTarget.Health > 0)
			{
				ChainFXOne(ChainTarget);
				if (SecondTarget == None || SecondTarget.Health <= 0)
				{
					BreakChainTwo();
						
					MostHealth = 0;
					SecondC = None;
					
					for ( C = Level.ControllerList; C != None; C = C.NextController )
					{
						if ( C != None && C.Pawn != None && C.Pawn != PawnOwner && C.Pawn.Health > 0 && !C.SameTeamAs(PawnOwner.Controller) && VSize(C.Pawn.Location - ChainTarget.Location) <= SecondChainRadius && FastTrace(C.Pawn.Location, ChainTarget.Location) && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !C.Pawn.IsA('MissionPortalBall') && !C.Pawn.IsA('GenomeProjectNode') && !ClassIsChildOf(C.Pawn.Class, class'DruidBlock')
						&& !C.bGodMode)
						{
							if (C.Pawn.Health > MostHealth)
							{
								MostHealth = C.Pawn.Health;
								SecondC = C;
							}
						}
					}
					if (SecondC != None && SecondC.Pawn != None)
						SecondTarget = SecondC.Pawn;
					else
					{
						SecondTarget = None;
						BreakChainTwo();
					}
				}
				else
				{
					ChainFXTwo(SecondTarget);
				}
			}
		}
		else
		{
			//at this point, we're not chained and we're not aiming at anything.
			if (ChainOne != None || GlowOne != None)
				BreakChainOne();
			if (ChainTwo != None || GlowTwo != None)
				BreakChainTwo();
			if (ChainTarget != None)
				ChainTarget = None;
			if (SecondTarget != None)
				SecondTarget = None;
		}
	}
	else
	{
		if (ChainOne != None || GlowOne != None)
			BreakChainOne();
		if (ChainTwo != None || GlowTwo != None)
			BreakChainTwo();
		if (ChainTarget != None)
			ChainTarget = None;
		if (SecondTarget != None)
			SecondTarget = None;	
	}
}

simulated function Drain(Pawn P)
{
	local LifeDrainSoulParticle FX;
	local LifeDrainSoulParticle FX2;
	local vector FX2Radius;
	local MonsterPointsInv MPInv;
	local int x;
	local Inventory Inv;
	local Ammunition Ammo;
	local Weapon W;
	local PhantomDeathGhostInv PInv;
	local Vehicle V;
	
	if (PawnOwner != None)
	{
		V = PawnOwner.DrivenVehicle;
		if (V != None)
			return;
	}
	
	PInv = PhantomDeathGhostInv(PawnOwner.FindInventoryType(class'PhantomDeathGhostInv'));
	if (PInv != None && !PInv.Stopped)
	{
		DrainMin = DrainMinDuringPhantom;
		DrainMax = DrainMaxDuringPhantom;
	}
	else if (PInv == None || PInv.Stopped)
	{
		DrainMin = default.DrainMin;
		DrainMax = default.DrainMax;
	}
	
	// got it. Damage the target.
	DrainAmount = max(min(DrainMultiplier * P.HealthMax, DrainMax), DrainMin);
	if (DrainAmount < DrainMin)
		DrainAmount = DrainMin;
	if (DrainAmount > DrainMax)
		DrainAmount = DrainMax;
	P.TakeDamage(DrainAmount, PawnOwner, P.Location, vect(0,0,0), class'DamTypeLifeDrain');
	
	//Add health to Necromancer
	PawnOwner.GiveHealth(DrainAmount*(AbilityLevel*HealthMultiplier), PawnOwner.HealthMax + DecayBonus);
	//PawnOwner.PlayOwnedSound(Sound'PickupSounds.HealthPack', SLOT_None, PawnOwner.TransientSoundVolume*0.75);
	
	MPInv = MonsterPointsInv(PawnOwner.FindInventoryType(class'MonsterPointsInv'));
	if (MPInv != None)
	{
		if (MPInv.SummonedMonsters.Length > 0)
		for (x = 0; x < MPInv.SummonedMonsters.Length; x++)
		{
			MPInv.SummonedMonsters[x].GiveHealth(DrainAmount*(AbilityLevel*HealthMultiplier), PawnOwner.HealthMax + DecayBonus);
			//MPInv.SummonedMonsters[x].PlayOwnedSound(Sound'PickupSounds.HealthPack', SLOT_None, PawnOwner.TransientSoundVolume*0.75);
		}
	}
	
	//Do the effects.
	FX2Radius.X=P.Location.X+-5+FRand();
	FX2Radius.Y=P.Location.Y+-5+FRand();
	FX2Radius.Z=P.Location.Z+-5+FRand();
	FX = Spawn(class'LifeDrainSoulParticle',,,P.Location,Rotation);
	FX.Seeking = PawnOwner;
	FX2 = Spawn(class'LifeDrainSoulParticle',,,FX2Radius,Rotation);
	FX2.Seeking = PawnOwner;
	
	BloodPoints++;
	if (BloodPoints > MaxBlood)
		BloodPoints = MaxBlood;
	AmmoCounter++;
	if (AmmoCounter >= AmmoThreshold)
	{
		for (Inv = Instigator.Inventory; Inv != None; Inv = Inv.Inventory)
		{
			W = Weapon(Inv);
			if (W != None)
			{
				if (W.bNoAmmoInstances && W.AmmoClass[0] != None && !class'MutUT2004RPG'.static.IsSuperWeaponAmmo(W.AmmoClass[0]))
				{
					W.AddAmmo(AmmoRegenAmount * (1 + W.AmmoClass[0].default.MaxAmmo / 100), 0);
					if (W.AmmoClass[0] != W.AmmoClass[1] && W.AmmoClass[1] != None)
						W.AddAmmo(AmmoRegenAmount * (1 + W.AmmoClass[1].default.MaxAmmo / 100), 1);
				}
			}
			else
			{
				Ammo = Ammunition(Inv);
				if (Ammo != None && !class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Ammo.Class))
					Ammo.AddAmmo(AmmoRegenAmount * (1 + Ammo.default.MaxAmmo / 100));
			}
		}
		AmmoCounter = 0;
	}
}

simulated function ChainFXOne(Pawn P)
{
	if (ChainOne == None && P != None)
	{
		ChainOne = Spawn(class'DecayChain',PawnOwner,,PawnOwner.Location,rotator(P.Location - PawnOwner.Location));
		if (ChainOne != None)
		{
			ChainOne.mWaveAmplitude = (AbilityLevel + 1);
			ChainOne.mWaveShift = (AbilityLevel*20000);
			ChainOne.mBendStrength = (AbilityLevel + 1);
		}
	}		
	ChainOne.SetBase(PawnOwner);
	
	if (GlowOne == None && P != None)
	{
		GlowOne = Spawn(class'DecayGlow',PawnOwner,,P.Location,P.Rotation);
		GlowOne.SetBase(P);
	}		
}

simulated function ChainFXTwo(Pawn P)
{
	if (ChainTwo == None && P != None && ChainTarget != None)
	{
		ChainTwo = Spawn(class'DecayChain',PawnOwner,,ChainTarget.Location,rotator(P.Location - ChainTarget.Location));
		if (ChainTwo != None)
		{
			ChainTwo.mWaveAmplitude = (AbilityLevel + 1);
			ChainTwo.mWaveShift = (AbilityLevel*20000);
			ChainTwo.mBendStrength = (AbilityLevel + 1);
		}
	}		
	ChainTwo.SetBase(ChainTarget);
	if (GlowTwo == None && P != None)
	{
		GlowTwo = Spawn(class'DecayGlow',PawnOwner,,P.Location,P.Rotation);
		GlowTwo.SetBase(P);
	}		
}

simulated function BreakChainOne()
{
	if (ChainOne != None)
		ChainOne.Destroy();
	if (GlowOne != None)
		GlowOne.Destroy();
}

simulated function BreakChainTwo()
{
	if (ChainTwo != None)
		ChainTwo.Destroy();
	if (GlowTwo != None)
		GlowTwo.Destroy();
}

simulated function Tick(float dt)
{
	if(ChainOne != None && PawnOwner != None && ChainTarget != None)
	{
		ChainOne.mSpawnVecA = ChainTarget.Location;
		ChainOne.SetRotation(rotator(ChainTarget.Location - PawnOwner.Location));
	}
	
	if(ChainTwo != None && PawnOwner != None && SecondTarget != None && ChainTarget != None)
	{
		ChainTwo.mSpawnVecA = SecondTarget.Location;
		ChainTwo.SetRotation(rotator(SecondTarget.Location - ChainTarget.Location));
	}
}

simulated function Destroyed()
{
	if (ChainOne != None)
		ChainOne.Destroy();
	if (ChainTwo != None)
		ChainTwo.Destroy();
	if (GlowOne != None)
		GlowOne.Destroy();
	if (GlowTwo != None)
		GlowTwo.Destroy();
	Super.Destroyed();
}

defaultproperties
{
	 AmmoThreshold=4	//divide by 2 to get seconds for ammo regeneration
	 AmmoRegenAmount=1
	 MaxBlood=500
	 ChainThreshold=1
	 DecayBonus=50
     DrainInterval=0.500000
     DrainMultiplier=0.050000
	 HealthMultiplier=0.080000
     SingleDrainRange=1500.000000
	 ChainRadius=900.00000
	 SecondChainRadius=1100.00
     DrainMin=5
     DrainMax=15
	 DrainMinDuringPhantom=1
	 DrainMaxDuringPhantom=5
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
