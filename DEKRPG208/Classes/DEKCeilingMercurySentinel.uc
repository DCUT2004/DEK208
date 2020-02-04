class DEKCeilingMercurySentinel extends ASVehicle_Sentinel_Ceiling;

simulated function PostBeginPlay()
{
	DefaultWeaponClassName=string(class'DEKMercurySentinelWeapon');

	super.PostBeginPlay();
}

defaultproperties
{
     TurretSwivelClass=Class'DEKRPG208.DEKMercurySentinelCeilingSwivel'
     DefaultWeaponClassName="DEKMercurySentinelWeapon"
     VehicleProjSpawnOffset=(X=150.000000)
     bNoTeamBeacon=False
     Skins(0)=Combiner'DEKRPGTexturesMaster207P.Skins.MercCeilingTurret'
     Skins(1)=Combiner'DEKRPGTexturesMaster207P.Skins.MercCeilingTurret'
     Skins(2)=Combiner'DEKRPGTexturesMaster207P.Skins.MercCeilingTurret'
}
