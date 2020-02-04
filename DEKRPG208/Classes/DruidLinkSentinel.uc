class DruidLinkSentinel extends ASTurret;
#exec OBJ LOAD FILE=..\Animations\AS_Vehicles_M.ukx

simulated event PostNetBeginPlay()
{
	// Static (non rotating) base
	if ( TurretBaseClass != None )
	{
	    // now check if on ceiling or floor. Passed in rotation yaw. 0=ceiling.
	    if (OriginalRotation.Yaw == 0)
			TurretBase = Spawn(TurretBaseClass, Self,, Location+vect(0,0,37), OriginalRotation);
	    else
			TurretBase = Spawn(TurretBaseClass, Self,, Location-vect(0,0,37), OriginalRotation);
	}

	// Swivel, rotates left/right (Yaw)
	if ( TurretSwivelClass != None )
	{
		TurretSwivel = Spawn(TurretSwivelClass, Self,, Location, OriginalRotation);
	}

	super(ASVehicle).PostNetBeginPlay();
}

function AddDefaultInventory()
{
	// do nothing. Do not want default weapon adding
}

simulated function Explode( vector HitLocation, vector HitNormal )
{
	local DruidLinkSentinelController C;
	
	C = DruidLinkSentinelController(self.Controller);
	
	if (C != None && C.PlayerSpawner != None && PlayerController(C.PlayerSpawner) != None)
		PlayerController(C.PlayerSpawner).ClientPlaySound(Sound'AnnouncerAssault.Generic.MS_sentinel_destroyed');
		
	super(ASTurret).Explode( HitLocation, Vect(0,0,1) ); // Overriding Explosion direction
}

defaultproperties
{
     TurretBaseClass=Class'DEKRPG208.DruidLinkSentinelBase'
     TurretSwivelClass=Class'DEKRPG208.DruidLinkSentinelSwivel'
     VehicleNameString="Link Sentinel"
     bCanBeBaseForPawns=False
     Mesh=SkeletalMesh'AS_Vehicles_M.FloorTurretGun'
     DrawScale=0.250000
     Skins(0)=TexEnvMap'VMVehicles-TX.Environments.ReflectionEnv'
     Skins(1)=TexEnvMap'VMVehicles-TX.Environments.ReflectionEnv'
     AmbientGlow=250
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
