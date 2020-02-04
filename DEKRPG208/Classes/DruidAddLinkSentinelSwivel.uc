class DruidAddLinkSentinelSwivel extends ASTurret_Minigun_Swivel;

#exec OBJ LOAD FILE=..\StaticMeshes\UCMP-PCRGun.usx

simulated event Timer()
{
	local rotator Rot;

	if ( bMovable )
	{
	    Rot = Rotation;
	    Rot.Yaw += 2000;
	    if (Rot.Yaw > 65536)
	        Rot.Yaw -= 65536;
		SetRotation( Rot );
	}

	SetTimer( 0.02, false );
}

defaultproperties
{
     StaticMesh=StaticMesh'UCMP-PCRGun.Weapon.DLgun-AmmoPickup-final'
     DrawScale=4.000000
     AmbientGlow=10
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
