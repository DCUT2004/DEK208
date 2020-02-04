class DEKCeilingSniperSentinel extends ASVehicle_Sentinel_Ceiling;

simulated function PostBeginPlay()
{
	DefaultWeaponClassName=string(class'DEKSniperWeaponSentinel');

	super.PostBeginPlay();
}

defaultproperties
{
     TurretSwivelClass=Class'DEKRPG208.DEKCeilingMachineGunSentinelSwivel'
     DefaultWeaponClassName="DEKSniperWeaponSentinel"
     VehicleProjSpawnOffset=(X=65.000000)
     VehicleNameString="Sniper Sentinel"
     bNoTeamBeacon=False
     DrawScale=0.150000
}
