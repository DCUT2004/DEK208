class DEKDamageSentinel extends ASTurret;
#exec OBJ LOAD FILE=..\Animations\AS_Vehicles_M.ukx

var int ResupplyLevel;
var config float ResupplyAmount;			// the amount of resupply the defense sentinel heals per level (% of max ammo)

function AddDefaultInventory()
{
	// do nothing. Do not want default weapon adding
}

simulated function Explode( vector HitLocation, vector HitNormal )
{
	local DEKDamageSentinelController C;
	
	C = DEKDamageSentinelController(self.Controller);
	
	if (C != None && C.PlayerSpawner != None && PlayerController(C.PlayerSpawner) != None)
		PlayerController(C.PlayerSpawner).ClientPlaySound(Sound'AnnouncerAssault.Generic.MS_sentinel_destroyed');
		
	super(ASTurret).Explode( HitLocation, Vect(0,0,1) ); // Overriding Explosion direction
}

defaultproperties
{
     ResupplyAmount=1.000000
     TurretBaseClass=Class'DEKRPG208.DEKDamageSentinelBase'
     VehicleNameString="Damage Sentinel"
     bCanBeBaseForPawns=False
     Mesh=SkeletalMesh'AS_Vehicles_M.FloorTurretGun'
     DrawScale=0.500000
     AmbientGlow=10
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
