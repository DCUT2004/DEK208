class RedBioDecal extends xScorch;

simulated function BeginPlay()
{
	if ( !Level.bDropDetail && (FRand() < 0.5) )
		ProjTexture = texture'XEffects.BloodSplat2';
	Super.BeginPlay();
}

defaultproperties
{
     ProjTexture=Texture'XEffects.BloodSplat1'
     bClipStaticMesh=True
     CullDistance=7000.000000
     LifeSpan=6.000000
     DrawScale=0.650000
}
