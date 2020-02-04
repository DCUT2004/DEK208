class PhantomDeathGhostInv extends Inventory
	config(UT2004RPG);

var Pawn PawnOwner;
var bool stopped, bResurrected;
var MagicShieldInv Inv;
var array<Material> OldInstigatorSkins;
var Material OldInstigatorRepSkin;
var array<ColorModifier> GhostSkins;
var color GhostColor;
var config float EnergyStealRadius, NotificationRadius;
var config int PhantomPassDamage;
var PhantomGhostInv PInv;
var Material ModifierOverlay;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		stopped, bResurrected;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if(Other == None)
	{
		destroy();
		return;
	}

	stopped = false;
	PawnOwner = Other;
	
	OldInstigatorRepSkin = PawnOwner.RepSkin;
	PawnOwner.RepSkin = None;
	
	//Set the Timer
	SetTimer(0.5, true);
	
	//Set GodMode
	if (PawnOwner != None && PawnOwner.Controller != None)
	{
		PInv = PhantomGhostInv(PawnOwner.FindInventoryType(class'PhantomGhostInv'));
		if (PInv != None && !PInv.stopped)
		{
			//must've suicided while doing the first ghost.. let's just destroy ourselves and let the first ghost finish out
			Destroy();
			return;
		}
		else
			SwitchOnInvulnerability();
		BroadcastLocalizedMessage(class'PhantomOUTMessage', 1, PawnOwner.Controller.PlayerReplicationInfo);
	}
	
	//Give Magic Shield.
	Inv = MagicShieldInv(PawnOwner.FindInventoryType(class'MagicShieldInv'));
	if (Inv == None)
	{
		Inv = spawn(class'MagicShieldINv', PawnOwner,,, rot(0,0,0));
		Inv.GiveTo(PawnOwner);
	}
	
	if (Level.NetMode != NM_DedicatedServer)
	{
		CreateGhostSkins();
		PawnOwner.Skins = GhostSkins;
	}
	
	if (PawnOwner.PlayerReplicationInfo != None)
		PawnOwner.PlayerReplicationInfo.bOutOfLives = True;
	bResurrected = False;
	
	Super.GiveTo(Other);
}

simulated function CreateGhostSkins()
{
	local int x;

	OldInstigatorSkins = PawnOwner.Skins;
	for (x = 0; x < PawnOwner.Skins.length; x++)
	{
		GhostSkins[x] = ColorModifier(Level.ObjectPool.AllocateObject(class'ColorModifier'));
		GhostSkins[x].Material = PawnOwner.Skins[x];
		GhostSkins[x].AlphaBlend = true;
		GhostSkins[x].RenderTwoSided = true;
		GhostSkins[x].Color = GhostColor;
	}
}

simulated function SwitchOnInvulnerability()
{
	local NecromancerWeapon NW;
	
	PawnOwner.Controller.bGodMode = true;
	PawnOwner.SetCollision(false,false,false);
	PawnOwner.bCollideWorld = true;
	PawnOwner.Mass = 1000.000000;
	if (PlayerController(PawnOwner.Controller) != None)
		PawnOwner.Controller.GotoState('PlayerFlying');
	else
		PawnOwner.SetPhysics(PHYS_Flying);
	NW = NecromancerWeapon(PawnOwner.FindInventoryType(class'NecromancerWeapon'));
	if (NW == None)
	{
		NW = PawnOwner.Spawn(class'NecromancerWeapon');
		NW.GiveTo(PawnOwner);
	}
	PawnOwner.Controller.ClientSetWeapon(class'NecromancerWeapon');
	
	Inv = MagicShieldInv(PawnOwner.FindInventoryType(class'MagicShieldInv'));
	if (Inv == None)
	{
		Inv = spawn(class'MagicShieldINv', PawnOwner,,, rot(0,0,0));
		Inv.GiveTo(PawnOwner);
	}
}

simulated function SwitchOffInvulnerability()
{
	local NecromancerWeapon NW;
	local int x;
	
	if (PawnOwner != None)
	{
		PInv = PhantomGhostInv(PawnOwner.FindInventoryType(class'PhantomGhostInv'));
		if (PInv != None && !PInv.stopped)
			return;
		PawnOwner.Controller.bGodMode = false;
		PawnOwner.SetCollision(true,true,true);
		PawnOwner.bCollideWorld = true;
		PawnOwner.Mass = PawnOwner.Default.Mass;
		if (PawnOwner != None && PawnOwner.Controller != None && PawnOwner.DrivenVehicle == None)
		{
			PawnOwner.SetPhysics(PHYS_Falling);
			if (PlayerController(PawnOwner.Controller) != None)
				PawnOwner.Controller.GotoState(PawnOwner.LandMovementState);
		}
		NW = NecromancerWeapon(PawnOwner.FindInventoryType(class'NecromancerWeapon'));
		if (NW != None)
			NW.Destroy();
		PawnOwner.Controller.ClientSwitchToBestWeapon();
		
		
		if (GhostSkins.length != 0)
		{
			if (Role == ROLE_Authority)
				PawnOwner.RepSkin = OldInstigatorRepSkin;
			if (Level.NetMode != NM_DedicatedServer)
			{
				PawnOwner.Skins = OldInstigatorSkins;
				if (GhostSkins.length != 0)
				{
					for (x = 0; x < GhostSkins.length; x++)
						Level.ObjectPool.FreeObject(GhostSkins[x]);
					GhostSkins.length = 0;
				}
			}
		}
		PawnOwner.setOverlayMaterial(ModifierOverlay, 0.5, true);
	}
}

simulated function Resurrected()
{
	StopEffect();
	SwitchOffInvulnerability();
	if (PawnOwner != None && PawnOwner.PlayerReplicationInfo != None)
		PawnOwner.PlayerReplicationInfo.bOutOfLives = False;
}

simulated function Timer()
{
	local Controller C, EC, NextC;
	local int NumPlayers;
	Local NullEntropyInv NInv;
	Local KnockbackInv KInv;
	Local DamageInv DInv;
	Local InvulnerabilityInv IInv;
	Local Vehicle Vehicle;
	local EnergyStealInv EInv;
	local EnergyStealFX FX;
	local NecroInv NeInv;
	
	if (PawnOwner == None || PawnOwner.Controller == None)	//gone
	{
		Destroy();
		return;
	}
	
	Vehicle = PawnOwner.DrivenVehicle;
	NEInv = NecroInv(PawnOwner.FindInventoryType(class'NecroInv'));
	
	if (Invasion(Level.Game) != None && !Invasion(Level.Game).bWaveInProgress && Invasion(Level.Game).WaveCountDown > 11)	//wave has just ended. reset?
	{
		Destroy();
		return;
	}
	
	for ( C = Level.ControllerList; C != None; C = C.NextController )
	{

		if (C != None && C.SameTeamAs(PawnOwner.Controller) && MonsterController(C) == None && C.PlayerReplicationInfo != None && (C.PlayerReplicationInfo.bOutOfLives || !C.PlayerReplicationInfo.bOutOfLives && C.Pawn != None && NecroInv(C.Pawn.FindInventoryType(class'NecroInv')) != None || !C.PlayerReplicationInfo.bOutOfLives && C.Pawn != None && PhantomDeathGhostInv(C.Pawn.FindInventoryType(class'PhantomDeathGhostInv')) != None))
		{
			NumPlayers++;
		}	
	}
	if (Invasion(Level.Game) != None && NumPlayers >= Invasion(Level.Game).GetNumPlayers())
	{
		//Kill them. Don't destroy, because that will call the Ghost ability again
		if(Vehicle != None)
		{
			StopEffect();
			Vehicle.EjectDriver();
			PawnOwner.Died(PawnOwner.Controller, class'Suicided', PawnOwner.Location);
			return;
			
		}
		else
		{
			StopEffect();
			PawnOwner.Died(PawnOwner.Controller, class'Suicided', PawnOwner.Location);
			return;
		}		
	}
	else
		NumPlayers = 0;
		
	if (bResurrected == True && NeInv == None)	//Was resurrected, resurrection timer ran out, go back to ghost
	{
		bResurrected = False;
	}
	
	if(!stopped)
	{
		if (Owner == None || PawnOwner == None)
		{
			Destroy();
			return;
		}
		if (PawnOwner != None)
		{
			PInv = PhantomGhostInv(PawnOwner.FindInventoryType(class'PhantomGhostInv'));
			PawnOwner.setOverlayMaterial(ModifierOverlay, 10, true);
			if (PInv != None && !PInv.stopped)
			{
				//must've suicided while doing the first ghost.. let's just destroy ourselves and let the first ghost finish out
				Destroy();
				return;
			}
			PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'PhantomDeathGhostMessage', 0);
			if (ROLE < ROLE_Authority)
			{
				if (GhostSkins.length == 0)
					CreateGhostSkins();
				PawnOwner.Skins = GhostSkins;
			}
			if (PawnOwner.Controller != None)
				PawnOwner.Controller.Adrenaline = 0;
				
			if (PawnOwner.Physics != PHYS_Flying)
			{
				if (PlayerController(PawnOwner.Controller) != None)
					PawnOwner.Controller.GotoState('PlayerFlying');
				else
					PawnOwner.SetPhysics(PHYS_Flying);
			}

			EC = Level.ControllerList;
			while (EC != None)
			{
				// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
				NextC = EC.NextController;
				
				//Is this just some sort of weird unreal script bug? Sometimes C is None
				if(EC == None)
				{
					EC = NextC;
					break;
				}
				if (EC != None && EC.Pawn != None && EC.Pawn.Health > 0 && !EC.SameTeamAs(PawnOwner.Controller) && VSize(EC.Pawn.Location - PawnOwner.Location) <= NotificationRadius && FastTrace(EC.Pawn.Location, PawnOwner.Location))
				{			
					EInv = EnergyStealInv(EC.Pawn.FindInventoryType(class'EnergyStealInv'));
					if (EInv == None)	//give them the light
					{
						FX = PawnOwner.Spawn(class'EnergyStealFX', PawnOwner,, EC.Pawn.Location);
						if (FX != None)
							FX.SetBase(EC.Pawn);
					}
				}
				EC = NextC;
			}
		}
		if (Role == ROLE_Authority)
		{
			if (Invasion(Level.Game) != None && !Invasion(Level.Game).bWaveInProgress && Invasion(Level.Game).WaveCountDown > 11)
			{
				Destroy();
				return;
			}
			
			if (PawnOwner != None)
			{	
				KInv = KnockbackInv(PawnOwner.FindInventoryType(class'KnockbackInv'));
				if(KInv != None)
				{
					KInv.PawnOwner = None;
					KInv.Destroy();
				}
				NInv = NullEntropyInv(PawnOwner.FindInventoryType(class'NullEntropyInv'));
				if(NInv != None)
				{
					NInv.PawnOwner = None;
					NInv.Destroy();
				}	
				DInv = DamageInv(PawnOwner.FindInventoryType(class'DamageInv'));
				if(DInv != None)
				{
					DInv.SwitchOffDamage();
					DInv.Destroy();
				}	
				IInv = InvulnerabilityInv(PawnOwner.FindInventoryType(class'InvulnerabilityInv'));
				if(IInv != None)
				{
					IInv.SwitchOffInvulnerability();
					IInv.Destroy();
				}	
			}
		}
	}
}

simulated function Tick(float deltaTime)
{
	local Weapon W;
	local NecromancerWeapon N;
	local Vehicle V;
	local Controller C, NextC;
	local EnergyStealInv EInv;
	local EnergyStolenFX FX;
	
	if (!stopped)
	{
		if (PawnOwner != None && PawnOwner.Controller != None)
		{
			W = PawnOwner.Weapon;
			N = NecromancerWeapon(PawnOwner.FindInventoryType(class'NecromancerWeapon'));
			if (W != None && !W.IsA('NecromancerWeapon'))
			{
				W.StopFire(0);
				W.StopFire(1);
				W.ImmediateStopFire();
				W.ClientStopFire(0);
				W.ClientStopFire(1);
			}
			if ( PawnOwner.Weapon != N )
			{
				PawnOwner.PendingWeapon = N;
				PawnOwner.Controller.ClientSetWeapon(class'NecromancerWeapon');
				PawnOwner.ServerChangedWeapon(W, PawnOwner.PendingWeapon);
			}
			V = PawnOwner.DrivenVehicle;
			if (V != None)
			{
				if (!stopped)
				{
					V.EjectDriver();
				}
			}
			
			C = Level.ControllerList;
			while (C != None)
			{
				// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
				NextC = C.NextController;
				
				//Is this just some sort of weird unreal script bug? Sometimes C is None
				if(C == None)
				{
					C = NextC;
					break;
				}
				if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.SameTeamAs(PawnOwner.Controller) && VSize(C.Pawn.Location - PawnOwner.Location) <= EnergyStealRadius && FastTrace(C.Pawn.Location, PawnOwner.Location) && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow'))
				{
					EInv = EnergyStealInv(C.Pawn.FindInventoryType(class'EnergyStealInv'));
					if (EInv == None)
					{
						EInv = C.Pawn.Spawn(class'EnergyStealInv');
						EInv.GiveTo(C.Pawn);
						if (EInv != None)
						{
							C.Pawn.TakeDamage(PhantomPassDamage, PawnOwner, C.Pawn.Location, vect(0,0,0), class'DamTypePhantomPass');
							if (N != None && !N.AmmoMaxed(0))
								N.AddAmmo(1, 0);
							//PawnOwner.PlaySound(Sound'ONSBPSounds.ShockTank.ShieldOff',,900.00);
							PlayerController(PawnOwner.Controller).ClientPlaySound(Sound'ONSBPSounds.ShockTank.ShieldOff');
							FX = PawnOwner.Spawn(class'EnergyStolenFX', PawnOwner,, C.Pawn.Location, C.Pawn.Rotation);
						}
					}
				}
				C = NextC;
			}
		}
	}
}

simulated function stopEffect()
{	
	if(stopped)
		return;
	else
		stopped = true;
	if(PawnOwner != None && PawnOwner.Controller != None)
	{
		SetTimer(0, False);
		//Switch off GodMode
		SwitchOffInvulnerability();
		
		//Remove MagicShield
		if (Inv != None)
		{
			Inv.Destroy();
		}
	}
}

simulated function destroyed()
{
	stopEffect();
	super.destroyed();
}

defaultproperties
{
	 ModifierOverlay=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.InvshadeFB'
	 PhantomPassDamage=10
	 EnergyStealRadius=100.0000
	 NotificationRadius=1000.00
     GhostColor=(B=255,G=255,R=255,A=26)
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
