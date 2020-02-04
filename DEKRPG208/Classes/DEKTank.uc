//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DEKTank extends ONSHoverTank;

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

defaultproperties
{
     LockOverlay=FinalBlend'D-E-K-HoloGramFX.FullFB.HoloMaterial_2'
     MaxPitchSpeed=750.000000
     DriverWeapons(0)=(WeaponClass=Class'DEKRPG208.DEKTankCannon')
     PassengerWeapons(0)=(WeaponPawnClass=Class'DEKRPG208.DEKTankSecondaryTurretPawn')
     VehicleMass=20.000000
     VehiclePositionString="in a DEK Tank"
     VehicleNameString="DEK Tank"
     Skins(0)=Texture'VMVehicles-TX.HoverTankGroup.TankNoColor'
}
