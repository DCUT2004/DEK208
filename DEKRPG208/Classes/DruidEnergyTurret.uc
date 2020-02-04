class DruidEnergyTurret extends ONSManualGunPawn;

var float LastHealTime;
var array<Controller> Healers;
var array<float> HealersLastLinkTime;
var int NumHealers;
var MutUT2004RPG RPGMut;
var bool IsLockedForSelf;
var Controller PlayerSpawner;
var Material LockOverlay;
var		bool 		bZooming;
var()	float		DesiredPlayerFOV, MinPlayerFOV, OldFOV, ZoomSpeed, ZoomWeaponOffsetAdjust;

replication
{
	reliable if (Role == ROLE_Authority)
		NumHealers;
}

simulated event PostBeginPlay()
{
	local Mutator m;

	super.PostBeginPlay();

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
	
	if (Role == ROLE_Authority)		
		SetTimer(1, true);	// for calculating number of healers
}

function SetPlayerSpawner(Controller PlayerC)
{
	PlayerSpawner = PlayerC;
}

simulated function RawInput(float DeltaTime,
							float aBaseX, float aBaseY, float aBaseZ, float aMouseX, float aMouseY,
							float aForward, float aTurn, float aStrafe, float aUp, float aLookUp)
{
	local playerController	PC;
    local float				NewFOV;

	if ( PlayerController(Controller) != None )
    {
		PC = PlayerController(Controller);
	    if ( aForward!=0 )
	    {
        	bZooming = true;

	        if ( aForward>0 )
            {
            	if ( PC.FOVAngle > MinPlayerFOV )
                	NewFOV = PC.FOVAngle - ((PC.DefaultFOV - MinPlayerFOV)*DeltaTime*ZoomSpeed);
				else
                	NewFOV = MinPlayerFOV;
            }
            else
            {
            	if ( PC.FOVAngle < PC.DefaultFOV )
                	NewFOV = PC.FOVAngle + ((PC.DefaultFOV - MinPlayerFOV)*DeltaTime*ZoomSpeed);
                else
                	NewFOV = PC.DefaultFOV;
            }
	    }
        else
        	bZooming = false;

        if ( bZooming )
            PC.SetFOV( FClamp(NewFOV, MinPlayerFOV, PC.DefaultFOV)  );

		if ( OldFOV == 0 )
			OldFOV = PC.FOVAngle;

		if ( OldFOV != PC.FOVAngle )
			PlaySound(Sound'WeaponSounds.LightningGun.LightningZoomIn', SLOT_Misc,,,,,false);

		OldFOV = PC.FOVAngle;
    }

    super.RawInput(DeltaTime, aBaseX, aBaseY, aBaseZ, aMouseX, aMouseY, aForward, aTurn, aStrafe, aUp, aLookUp);
}

function Timer()
{
	// check how many healers we have
	local int i;
	local int validHealers;
	
	if (Role < ROLE_Authority)	
		return;	

	validHealers = 0;
	for(i = 0; i < Healers.length; i++)
	{
		if (HealersLastLinkTime[i] > Level.TimeSeconds-0.5)
		{	// this healer has healed in the last half a second, so keep.
			if (i > validHealers)
			{	// shuffle down to next valid slot
				HealersLastLinkTime[validHealers] = HealersLastLinkTime[i];
				Healers[validHealers] = Healers[i];
			}
			validHealers++;
		}
	}
	Healers.Length = validHealers;		// and get rid of the non-valid healers.
	HealersLastLinkTime.length = validHealers;
	
	// now update the replicated value
	if (NumHealers != validHealers)
		NumHealers = validHealers;

}

function bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
	local int i;
	local bool gotit;
	local bool healret;
	local Mutator m;

	// quick check to make sure we got the RPGMut set
	if (RPGMut == None && Level.Game != None)
	{
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
	}

	// keep a list of who is healing
	gotit = false;
	if (Healer != None && TeamLink(Healer.GetTeamNum()))
	{	
		// check the healer is an engineer
		if (Healer.Pawn != None && ((Healer.Pawn.Weapon != None && RW_EngineerLink(Healer.Pawn.Weapon) != None) || DruidLinkSentinel(Healer.Pawn) != None || DruidAddLinkSentinel(Healer.Pawn) != None))
		{

			// now add to list
			for(i = 0; i < Healers.length; i++)
			{
				if (Healers[i] == Healer)
				{
					gotit = true;
					HealersLastLinkTime[i] = Level.TimeSeconds;
					i = Healers.length;
				}
			}
			if (!gotit)
			{
				// add new healer
				Healers[Healers.length] = Healer;
				HealersLastLinkTime[HealersLastLinkTime.length] = Level.TimeSeconds;
			}
		}
	}

	healret = Super.HealDamage(Amount, Healer, DamageType);
	if (healret)
	{
		// healed turret of health, so no damage/xp bonus this second
		LastHealTime = Level.TimeSeconds;
	}
	return healret;
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local PlayerController PC;
	local Controller C;

	if ( bDeleteMe || Level.bLevelChange )
		return; // already destroyed, or level is being cleaned up

	if ( Level.Game.PreventDeath(self, Killer, damageType, HitLocation) )
	{
		Health = max(Health, 1); //mutator should set this higher
		return;
	}
	Health = Min(0, Health);

	if ( Controller != None )
	{
		C = Controller;
		C.WasKilledBy(Killer);
		Level.Game.Killed(Killer, C, self, damageType);
		if( C.bIsPlayer )
		{
			PC = PlayerController(C);
			if ( PC != None )
				ClientKDriverLeave(PC); // Just to reset HUD etc.
			else
                		ClientClearController();
			if ( bRemoteControlled && (Driver != None) && (Driver.Health > 0) )
			{
				C.Unpossess();
				C.Possess(Driver);
				Driver = None;
			}
			else
				C.PawnDied(self);
		}
		else
			C.Destroy();

		if ( Driver != None )
    		{
	            if (!bRemoteControlled)
        	    {
				if (!bDrawDriverInTP && PlaceExitingDriver())
				{
					Driver.StopDriving(self);
					Driver.DrivenVehicle = self;
				}
				Driver.TearOffMomentum = Velocity * 0.25;
				Driver.Died(Controller, class'DamRanOver', Driver.Location);
        	    }
	            else
				KDriverLeave(false);
		}
	}
	else
		Level.Game.Killed(Killer, Controller(Owner), self, damageType);

	if ( Killer != None )
		TriggerEvent(Event, self, Killer.Pawn);
	else
		TriggerEvent(Event, self, None);

	if ( IsHumanControlled() )
		PlayerController(Controller).ForceDeathUpdate();

	Explode(HitLocation);
}

simulated function Explode( vector HitLocation )
{
	if ( Level.NetMode != NM_DedicatedServer )
		Spawn(class'FX_SpaceFighter_Explosion', Self,, HitLocation, Rotation);
	Destroy();
}

function bool TryToDrive(Pawn P)
{
	if ( (P.Controller == None) || !P.Controller.bIsPlayer || Health <= 0 )
		return false;

	// Check for Locking by engineer....
	if ( IsEngineerLocked() && P.Controller != PlayerSpawner )
	{
		if (PlayerController(P.Controller) != None)
		{
		    if (PlayerSpawner != None)
				PlayerController(P.Controller).ReceiveLocalizedMessage(class'VehicleEngLockedMessage', 0, PlayerSpawner.PlayerReplicationInfo);
			else
				PlayerController(P.Controller).ReceiveLocalizedMessage(class'VehicleEngLockedMessage', 0);
		}
		return false;
	}
	else
	{
		return super.TryToDrive(P);
	}
}

function EngineerLock()
{
    IsLockedForSelf = True;
	SetOverlayMaterial(LockOverlay, 50000.0, True);
	if (Gun != None)
		Gun.SetOverlayMaterial(LockOverlay, 50000.0, True);


}

function EngineerUnlock()
{
    IsLockedForSelf = False;
	SetOverlayMaterial(LockOverlay, 0.0, false);
	if (Gun != None)
		Gun.SetOverlayMaterial(LockOverlay,0.0, false);
}

function bool IsEngineerLocked()
{
    return IsLockedForSelf;
}

simulated event TeamChanged()
{
    Super(ONSWeaponPawn).TeamChanged();
}

defaultproperties
{
     LockOverlay=FinalBlend'D-E-K-HoloGramFX.FullFB.HoloMaterial_2'
     bZooming=True
     MinPlayerFOV=20.000000
     ZoomSpeed=1.500000
     bPowered=True
     RespawnTime=5.000000
     GunClass=Class'DEKRPG208.DruidEnergyWeapon'
     AutoTurretControllerClass=None
}
