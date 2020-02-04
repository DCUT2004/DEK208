class DruidLinkSentinelSwivel extends ASTurret_Minigun_Swivel;

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

	SetTimer( 0.15, false );
}

// not a real swivel class - just a place holder for a globe

//     Skins(1)=FinalBlend'XEffectMat.Link.LinkBeamYellowFB'

defaultproperties
{
     StaticMesh=StaticMesh'ParticleMeshes.Simple.ParticleSphere3'
     DrawScale=0.430000
     Skins(0)=TexEnvMap'VMVehicles-TX.Environments.ReflectionEnv'
     Skins(1)=TexEnvMap'VMVehicles-TX.Environments.ReflectionEnv'
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
