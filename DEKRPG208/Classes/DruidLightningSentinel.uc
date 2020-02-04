class DruidLightningSentinel extends ASTurret;
#exec OBJ LOAD FILE=..\Animations\AS_Vehicles_M.ukx

function AddDefaultInventory()
{
	// do nothing. Do not want default weapon adding
}

simulated function Explode( vector HitLocation, vector HitNormal )
{
	local DruidLightningSentinelController C;
	
	C = DruidLightningSentinelController(self.Controller);
	
	if (C != None && C.PlayerSpawner != None && PlayerController(C.PlayerSpawner) != None)
		PlayerController(C.PlayerSpawner).ClientPlaySound(Sound'AnnouncerAssault.Generic.MS_sentinel_destroyed');
		
	super(ASTurret).Explode( HitLocation, Vect(0,0,1) ); // Overriding Explosion direction
}

defaultproperties
{
     TurretBaseClass=Class'DEKRPG208.DruidLightningSentinelBase'
     VehicleNameString="Lightning Sentinel"
     bCanBeBaseForPawns=False
     Mesh=SkeletalMesh'AS_Vehicles_M.FloorTurretGun'
     DrawScale=0.500000
     AmbientGlow=120
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
