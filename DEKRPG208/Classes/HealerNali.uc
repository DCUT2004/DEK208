class HealerNali extends SMPNali
	config(UT2004RPG);

var bool SummonedMonster;
var() config float HealthDamage, HealthDamageMax;
var config int SoundChance;
var Sound CallSound[3];
var config int CloseRareEventChance, FarRareEventChance;
var config int DropLetterChance;
var config float CloseRangeDistance;

function PostNetBeginPlay()
{
	Instigator = self;
	SummonedMonster = True;
	
	Super.PostNetBeginPlay();
}

function CheckController()
{
	if (Instigator.ControllerClass == class'DEKFriendlyMonsterController')
		SummonedMonster = true;
}

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'Monster');
}

function RangedAttack(Actor A)
{
	local float decision;
	local Pawn P;
	
	Super.RangedAttack(A);
	
	P = Pawn(A);

	decision = FRand();

	if ( bShotAnim )
		return;

	if ( Physics == PHYS_Swimming )
	{
		SetAnimAction('Tread');
		AddHealth(HealthDamage);
	}
	else if ( VSize(A.Location - Location) <= CloseRangeDistance + CollisionRadius + A.CollisionRadius )
	{
		SetAnimAction('spell');
		if (rand(99) <= CloseRareEventChance && P != None)
		{
			if (rand(99) <= DropLetterChance && Invasion(Level.Game) != None && Invasion(Level.Game).FinalWave <= 16)
			{
				if (rand(99) <= 20)
					DropPickups(Self.Controller, P.Controller, class'DEKRPG208.ArtifactLetterBPickup', None, 1);
				else if (rand(99) <= 40)
					DropPickups(Self.Controller, P.Controller, class'DEKRPG208.ArtifactLetterOPickup', None, 1);
				else if (rand(99) >= 60)
					DropPickups(Self.Controller, P.Controller, class'DEKRPG208.ArtifactLetterNPickup', None, 1);
				else if (rand(99) <= 80)
					DropPickups(Self.Controller, P.Controller, class'DEKRPG208.ArtifactLetterUPickup', None, 1);
				else if (rand(99) <= 100)
					DropPickups(Self.Controller, P.Controller, class'DEKRPG208.ArtifactLetterSPickup', None, 1);
			}
			else
				DropPickups(Self.Controller, P.Controller, class'DEKRPG208.GemExperiencePickupBlue', None, 1);
		}
		else
			AddHealth(HealthDamage);
	}
	else
	{
		SetAnimAction('spell');
		if (rand(99) <= FarRareEventChance && P != None)
		{
			if (rand(99) <= DropLetterChance && Invasion(Level.Game) != None && Invasion(Level.Game).FinalWave <= 16)
			{
				if (rand(99) <= 20)
					DropPickups(Self.Controller, P.Controller, class'DEKRPG208.ArtifactLetterBPickup', None, 1);
				else if (rand(99) <= 40)
					DropPickups(Self.Controller, P.Controller, class'DEKRPG208.ArtifactLetterOPickup', None, 1);
				else if (rand(99) >= 60)
					DropPickups(Self.Controller, P.Controller, class'DEKRPG208.ArtifactLetterNPickup', None, 1);
				else if (rand(99) <= 80)
					DropPickups(Self.Controller, P.Controller, class'DEKRPG208.ArtifactLetterUPickup', None, 1);
				else if (rand(99) <= 100)
					DropPickups(Self.Controller, P.Controller, class'DEKRPG208.ArtifactLetterSPickup', None, 1);
			}
			else
				DropPickups(Self.Controller, P.Controller, class'DEKRPG208.GemExperiencePickupBlue', None, 1);
		}
		else
			AddHealth(HealthDamage);
	}
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

function AddHealth(float HealthDamage)
{
	local Pawn P;
	local HealerNaliHealthFX HFX;
	local HealerNaliAdrenFX AFX;	
	local HealerNaliShieldFX SFX;	
	local float HealthAmount;
	local Vehicle V;
	local Monster M;
	local HealerNaliHealthCorona HealthCorona;
	local HealerNaliAdrenCorona AdrenCorona;
	local HealerNaliShieldCorona ShieldCorona;
	local int MaxShield;

	HealthAmount = (HealthDamage + Rand(HealthDamageMax - HealthDamage));
	
	P = Controller.Enemy;
	V = Vehicle(P);
	M = Monster(P);
	
	if (P == None || P.Health<=0)
		return;
	if (M != None && M.ControllerClass != class'DEKFriendlyMonsterController')
		return;
	if (V != None )
		return;
	MaxShield = P.GetShieldStrengthMax();

	if (P != None)
	{
		if (P.Health < (P.HealthMax + 100.00))
		{
			P.GiveHealth(HealthAmount, (P.HealthMax + 100.00));
			P.PlaySound(Sound'PickupSounds.HealthPack',, 2 * P.TransientSoundVolume,, 1.5 * P.TransientSoundRadius);
			HFX = Spawn(class'HealerNaliHealthFX',,,P.Location,Rotation);
			HealthCorona = Spawn(class'HealerNaliHealthCorona',Self);
		}
		else if (P.Controller.Adrenaline < P.Controller.AdrenalineMax)
		{
			P.Controller.Adrenaline += HealthAmount;
			P.PlaySound(Sound'PickupSounds.AdrenelinPickup',, 2 * P.TransientSoundVolume,, 1.5 * P.TransientSoundRadius);
			AFX = Spawn(class'HealerNaliAdrenFX',,,P.Location,Rotation);
			AdrenCorona = Spawn(class'HealerNaliAdrenCorona',Self);
		}
		else if (P != None && P.ShieldStrength < MaxShield)
		{
			P.AddShieldStrength(HealthAmount);
			P.PlaySound(Sound'PickupSounds.ShieldPack',, 2 * P.TransientSoundVolume,, 1.5 * P.TransientSoundRadius);
			SFX = Spawn(class'HealerNaliShieldFX',,,P.Location,Rotation);
			ShieldCorona = Spawn(class'HealerNaliShieldCorona',Self);
		}
	}
	
	if (SoundChance > Rand(99))
		Self.PlaySound(CallSound[Rand(3)]);
}

static function DropPickups(Controller Killed, Controller Killer, class<Pickup> PickupType, Inventory Inv, int Num)
{
    local Pickup pickupObj;
	local vector tossdir, X, Y, Z;
    local int i;

    for(i=0; i < Num; i++)
    {
        // This chain of events based on the way that weapon pickups are dropped when a pawn dies
	    // See Pawn.Died()

    	// Find out which direction the new pickup should be thrown

    	// Get a vector indicating direction the dying pawn was looking

        tossdir = Vector(Killed.Pawn.GetViewRotation());

    	// Adding coordinates to the directional vector

        tossdir = tossdir *	((Killed.Pawn.Velocity Dot tossdir) + 100) + Vect(0,0,200);

        // Change the velocity a bit for multiple drops

        tossdir.X += i*Rand(200);
        tossdir.Y += i*Rand(200);
        tossdir.Z += i*Rand(200);


    	Killed.Pawn.GetAxes(Killed.Pawn.Rotation, X,Y,Z);

	    // Set the pickup's location to a realistic position outside of the dying pawn's collision cylinder

        pickupObj = Killer.spawn(PickupType,,,(Killed.Pawn.Location + 0.8 * Killed.Pawn.CollisionRadius * X + -0.5 * Killed.Pawn.CollisionRadius * Y),);

        if(pickupObj == None)
        {
            Log("Pinata2k4 spawn failure");
            return;
        }

		// Now apply the throwing velocity to the position of the pickup
	    pickupObj.velocity = tossdir;

        pickupObj.InitDroppedPickupFor(Inv);
    }
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local Monster M;
	local FriendlyMonsterInv Inv;
	
	M = Monster(InstigatedBy);
	
	if (M == None)
		return;
	
	if (DamageType == class'DamTypeLightningRod' || DamageType == class'DamTypeEnhLightningRod' || DamageType == class'DamTypeLightningBolt' || DamageType == class'DamTypeLightningSent' || DamageType == class'DamTypeMachinegunSentinel' || DamageType == class'DamTypeSniperSentinel' || DamageType == class'DamTypeBeamSentinel' || DamageType == class'DamTypeBlasterLaser' || DamageType == class'DamTypeEnergyWall' || DamageType == class'DamTypeHellfireSentinel' || DamageType == class'DamTypeLightningTurretMinibolt' || DamageType == class'DamTypeLightningTurretProj' || DamageType == class'DamTypeMassDrain' || DamageType == class'DamTypeMercurySENTAirHeadHit' || DamageType == class'DamTypeMercurySENTAirHit' || DamageType == class'DamTypeMercurySENTAirPunchThrough' || DamageType == class'DamTypeMercurySENTAirPunchThroughHead' || DamageType == class'DamTypeMercurySENTDirectHit' || DamageType == class'DamTypeMercurySENTHeadHit' || DamageType == class'DamTypeMercurySENTPunchThrough' || DamageType == class'DamTypeMercurySENTPunchThroughHead' || DamageType == class'DamTypeMercurySENTSplashDamage' || DamageType == class'DamTypeRocketSentinelProj' || DamageType == class'DamTypeAerialTrap' || DamageType == class'DamTypeBombTrap' || DamageType == class'DamTypeFrostTrap' || DamageType == class'DamTypeLaserGrenadeLaser' || DamageType == class'DamTypeShockTrap' || DamageType == class'DamTypeShockTrapShock' || DamageType == class'DamTypeWildfireTrap' || DamageType == class'DamTypeDronePlasma')
	{
		return; //These things are out of our control.
	}
	
	if (InstigatedBy != None)
	{
		Inv = FriendlyMonsterInv(InstigatedBy.FindInventoryType(class'FriendlyMonsterInv'));
		if (Inv != None)
			return;
		if (InstigatedBy.IsA('HealerNali'))
			return;
		if (M != None)
		{
			if (M.ControllerClass != None && M.ControllerClass == class'DEKFriendlyMonsterController')
				return;
		}
	}
	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damagetype);
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local Actor A;
	
	A = spawn(class'NewTransEffectBlue', Self,, Self.Location, Self.Rotation);
	if (A != None)
		A.RemoteRole = ROLE_SimulatedProxy;
	Self.PlaySound(Sound'satoreMonsterPackv120.fear1n');
	
	if (SummonedMonster)
	{
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	}
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     HealthDamage=5.000000
     HealthDamageMax=10.000000
     SoundChance=33
     CallSound(0)=Sound'satoreMonsterPackv120.Nali.backup2n'
     CallSound(1)=Sound'satoreMonsterPackv120.Nali.contct3n'
     CallSound(2)=Sound'satoreMonsterPackv120.Nali.contct1n'
     CloseRareEventChance=10
     FarRareEventChance=5
     DropLetterChance=5
     CloseRangeDistance=200.000000
     ScoringValue=0
     Health=30
	 ControllerClass=Class'DEKRPG208.HealerNaliController'
}
