class DruidIonCannon extends ASTurret_IonCannon;

var float LastHealTime;
var array<Controller> Healers;
var array<float> HealersLastLinkTime;
var int NumHealers;
var MutUT2004RPG RPGMut;
var bool IsLockedForSelf;
var Controller PlayerSpawner;
var Material LockOverlay;

replication
{
	reliable if (Role == ROLE_Authority)
		NumHealers;
}

simulated event PostBeginPlay()
{
	local Mutator m;
	
	NumHealers = 0;
	DefaultWeaponClassName=string(class'WeaponDruidIonCannon');

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
	SetOverlayMaterial(LockOverlay, 50000.0, false);
}

function EngineerUnlock()
{
    IsLockedForSelf = False;
	SetOverlayMaterial(LockOverlay, 0.0, false);
}

function bool IsEngineerLocked()
{
    return IsLockedForSelf;
}

function KDriverEnter(Pawn P)
{
	Super.KDriverEnter(P);

    if (Weapon != None && Driver != None && xPawn(Driver) != None && Driver.HasUDamage())
		Weapon.SetOverlayMaterial(xPawn(Driver).UDamageWeaponMaterial, xPawn(Driver).UDamageTime - Level.TimeSeconds, false);

}

function bool KDriverLeave( bool bForceLeave )
{
	if (Weapon != None && Controller != None && xPawn(Controller.Pawn) != None && Controller.Pawn.HasUDamage())
		Weapon.SetOverlayMaterial(xPawn(Controller.Pawn).UDamageWeaponMaterial, 0, false);

	return Super.KDriverLeave(bForceLeave);
}

function DriverDied()
{
	if (Weapon != None && xPawn(Driver) != None && Driver.HasUDamage())
		Weapon.SetOverlayMaterial(xPawn(Driver).UDamageWeaponMaterial, 0, false);

	Super.DriverDied();
}

function bool HasUDamage()
{
	return (Driver != None && Driver.HasUDamage());
}

defaultproperties
{
     LockOverlay=Shader'DEKRPGTexturesMaster207P.fX.PulseRedShader'
     TurretBaseClass=Class'DEKRPG208.DruidIonCannon_Base'
     TurretSwivelClass=Class'DEKRPG208.DruidIonCannon_Swivel'
     RotPitchConstraint=(Min=12084.000000)
     CamRelLocation=(Z=100.000000)
     CamDistance=(X=-200.000000)
     DefaultWeaponClassName="WeaponDruidIonCannon"
     VehicleProjSpawnOffset=(X=110.000000,Z=30.000000)
     ExitPositions(0)=(X=0.000000,Y=100.000000,Z=100.000000)
     ExitPositions(1)=(X=0.000000,Y=-100.000000,Z=100.000000)
     EntryPosition=(X=0.000000,Y=0.000000,Z=0.000000)
     FPCamPos=(X=100.000000,Z=100.000000)
     HealthMax=900.000000
     Health=900
     DrawScale=0.150000
     CollisionRadius=52.000000
     CollisionHeight=80.000000
}