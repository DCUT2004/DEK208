class DruidGoliath extends ONSHoverTank;

var bool IsLockedForSelf;
var Controller PlayerSpawner;
var Material LockOverlay;

function SetPlayerSpawner(Controller PlayerC)
{
	PlayerSpawner = PlayerC;
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

//    DriverWeapons(0)=(WeaponClass=Class'Onslaught.ONSHoverTankCannon',WeaponBone="TankCannonWeapon")
//    PassengerWeapons(0)=(WeaponPawnClass=Class'Onslaught.ONSTankSecondaryTurretPawn',WeaponBone="MachineGunTurret")

defaultproperties
{
     LockOverlay=Shader'DEKRPGTexturesMaster207P.fX.PulseRedShader'
     DriverWeapons(0)=(WeaponClass=Class'DEKRPG208.DruidGoliathCannon')
     Skins(0)=Texture'VMVehicles-TX.HoverTankGroup.TankNoColor'
}
