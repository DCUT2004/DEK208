class DEKSniperSentinel extends ASVehicle_Sentinel_Floor;

var config float TargetRange;

simulated event PostBeginPlay()
{
	DefaultWeaponClassName=string(class'DEKSniperWeaponSentinel');

	super.PostBeginPlay();
}

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache( L );

	L.AddPrecacheMaterial( Material'AS_Weapons_TX.Sentinels.FloorTurret' );		// Skins

	L.AddPrecacheStaticMesh( StaticMesh'AS_Weapons_SM.FloorTurretSwivel' );
}

simulated function UpdatePrecacheStaticMeshes()
{
	Level.AddPrecacheStaticMesh( StaticMesh'AS_Weapons_SM.FloorTurretSwivel' );

	super.UpdatePrecacheStaticMeshes();
}

simulated function UpdatePrecacheMaterials()
{
	Level.AddPrecacheMaterial( Material'AS_Weapons_TX.Sentinels.FloorTurret' );		// Skins

	super.UpdatePrecacheMaterials();
}

simulated function PlayFiring(optional float Rate, optional name FiringMode )
{
	PlayAnim('Fire', 0.75);
}

simulated function Explode( vector HitLocation, vector HitNormal )
{
	local DEKSniperSentinelController C;
	
	C = DEKSniperSentinelController(self.Controller);
	
	if (C != None && C.PlayerSpawner != None && PlayerController(C.PlayerSpawner) != None)
		PlayerController(C.PlayerSpawner).ClientPlaySound(Sound'AnnouncerAssault.Generic.MS_sentinel_destroyed');
		
	super(ASTurret).Explode( HitLocation, Vect(0,0,1) ); // Overriding Explosion direction
}

defaultproperties
{
     TargetRange=2400.000000
     OpenCloseSound=None
     TurretBaseClass=Class'DEKRPG208.AutoGunBase'
     TurretSwivelClass=Class'DEKRPG208.AutoGunSwivel'
     DefaultWeaponClassName="DEKSniperWeaponSentinel"
     VehicleProjSpawnOffset=(X=45.000000)
     AutoTurretControllerClass=None
     VehicleNameString="Sniper Sentinel"
     bNoTeamBeacon=False
     HealthMax=400.000000
     Health=400
     DrawScale=0.250000
}
