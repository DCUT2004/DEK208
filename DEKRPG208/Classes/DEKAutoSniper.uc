class DEKAutoSniper extends ASTurret;

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

simulated event PostBeginPlay()
{
	DefaultWeaponClassName=string(class'DEKAutoSniperWeapon');

	super.PostBeginPlay();
}

simulated function PlayFiring(optional float Rate, optional name FiringMode )
{
	PlayAnim('Fire', 0.50);
}

simulated function Explode( vector HitLocation, vector HitNormal )
{
	local DEKAutoSniperController C;
	
	C = DEKAutoSniperController(self.Controller);
	
	if (C != None && C.PlayerSpawner != None && PlayerController(C.PlayerSpawner) != None)
		PlayerController(C.PlayerSpawner).ClientPlaySound(Sound'AnnouncerAssault.Generic.MS_sentinel_destroyed');
		
	super(ASTurret).Explode( HitLocation, Vect(0,0,1) ); // Overriding Explosion direction
}

defaultproperties
{
     TurretBaseClass=Class'DEKRPG208.AutoGunBase'
     TurretSwivelClass=Class'DEKRPG208.AutoGunSwivel'
     DefaultWeaponClassName="DEKAutoSniperWeapon"
     VehicleProjSpawnOffset=(X=45.000000,Y=0.000000,Z=0.000000)
     bNonHumanControl=True
     AutoTurretControllerClass=None
     VehicleNameString="AutoSniper"
     bCanBeBaseForPawns=False
     HealthMax=1000.000000
     Health=1000
     Mesh=SkeletalMesh'AS_Vehicles_M.FloorTurretGun'
     DrawScale=0.250000
     AmbientGlow=48
     TransientSoundVolume=0.750000
     TransientSoundRadius=512.000000
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bNetNotify=True
}
