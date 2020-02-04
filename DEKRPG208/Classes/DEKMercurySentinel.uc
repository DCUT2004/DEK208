class DEKMercurySentinel extends ASVehicle_Sentinel_Floor;

var config float TargetRange;

simulated event PostBeginPlay()
{
	DefaultWeaponClassName=string(class'DEKMercurySentinelWeapon');

	super.PostBeginPlay();
}

simulated function Explode( vector HitLocation, vector HitNormal )
{
	local DEKMercuryController C;
	
	C = DEKMercuryController(self.Controller);
	
	if (C != None && C.PlayerSpawner != None && PlayerController(C.PlayerSpawner) != None)
		PlayerController(C.PlayerSpawner).ClientPlaySound(Sound'AnnouncerAssault.Generic.MS_sentinel_destroyed');
		
	super(ASTurret).Explode( HitLocation, Vect(0,0,1) ); // Overriding Explosion direction
}

defaultproperties
{
     TargetRange=1800.000000
     TurretBaseClass=Class'DEKRPG208.DEKMercurySentinelFloorBase'
     TurretSwivelClass=Class'DEKRPG208.DEKMercurySentinelFloorSwivel'
     DefaultWeaponClassName="DEKMercurySentinelWeapon"
     VehicleProjSpawnOffset=(X=122.500000)
     bNoTeamBeacon=False
     Skins(0)=Combiner'DEKRPGTexturesMaster207P.Skins.MercFloorTurret'
     Skins(1)=Combiner'DEKRPGTexturesMaster207P.Skins.MercFloorTurret'
     Skins(2)=Combiner'DEKRPGTexturesMaster207P.Skins.MercFloorTurret'
}
