class DruidAddLinkSentinel extends DruidLinkSentinel;

#exec OBJ LOAD FILE=..\Animations\AS_Vehicles_M.ukx
#exec OBJ LOAD FILE=..\Sounds\GeneralAmbience.uax

var Sound SwivelSound;

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
	    if (OriginalRotation.Yaw == 0)
			TurretSwivel = Spawn(TurretSwivelClass, Self,, Location+vect(0,-2,-70), OriginalRotation);
	    else
			TurretSwivel = Spawn(TurretSwivelClass, Self,, Location-vect(0,2,-59), OriginalRotation);
		TurretSwivel.AmbientSound = SwivelSound;
	}

	super(ASVehicle).PostNetBeginPlay();
}

simulated function Explode( vector HitLocation, vector HitNormal )
{
	local DruidLinkSentinelController C;
	
	C = DruidLinkSentinelController(self.Controller);
	
	if (C != None && C.PlayerSpawner != None && PlayerController(C.PlayerSpawner) != None)
		PlayerController(C.PlayerSpawner).ClientPlaySound(Sound'AnnouncerAssault.Generic.MS_sentinel_destroyed');
		
	super(ASTurret).Explode( HitLocation, Vect(0,0,1) ); // Overriding Explosion direction
}

function AddDefaultInventory()
{
	// do nothing. Do not want default weapon adding
}

defaultproperties
{
	 AmbientSoundScaling=3.0000
	 SoundRadius=300.00
     SwivelSound=Sound'GeneralAmbience.texture7'
     TurretBaseClass=Class'DEKRPG208.DruidAddLinkSentinelBase'
     TurretSwivelClass=Class'DEKRPG208.DruidAddLinkSentinelSwivel'
     DrawScale=0.350000
     Skins(0)=Shader'DEKRPGTexturesMaster207P.Skins.LinkSentHiding'
     Skins(1)=Shader'DEKRPGTexturesMaster207P.Skins.LinkSentHiding'
     AmbientGlow=1
}
