class DEKCeilingHellfireSentinel extends ASVehicle_Sentinel_Ceiling;

simulated function PostBeginPlay()
{
	DefaultWeaponClassName=string(class'DEKHellfireSentinelWeapon');

	super.PostBeginPlay();
}

defaultproperties
{
     DefaultWeaponClassName="DEKWBHellfireSentinelWeapon"
     VehicleProjSpawnOffset=(X=150.000000)
     VehicleNameString="Hellfire Sentinel"
     bNoTeamBeacon=False
}
