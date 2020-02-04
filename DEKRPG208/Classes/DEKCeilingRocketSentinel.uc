class DEKCeilingRocketSentinel extends ASVehicle_Sentinel_Ceiling;

simulated function PostBeginPlay()
{
	DefaultWeaponClassName=string(class'DEKRocketSentinelWeapon');

	super.PostBeginPlay();
}

defaultproperties
{
     TurretSwivelClass=Class'DEKRPG208.DEKMercurySentinelCeilingSwivel'
     DefaultWeaponClassName="DEKRocketSentinelWeapon"
     VehicleProjSpawnOffset=(X=150.000000)
     VehicleNameString="Ceiling Rocket Sentinel"
     bNoTeamBeacon=False
     Skins(0)=Combiner'DEKRPGTexturesMaster207P.Skins.MercCeilingTurret'
     Skins(1)=Combiner'DEKRPGTexturesMaster207P.Skins.MercCeilingTurret'
     Skins(2)=Combiner'DEKRPGTexturesMaster207P.Skins.MercCeilingTurret'
}
