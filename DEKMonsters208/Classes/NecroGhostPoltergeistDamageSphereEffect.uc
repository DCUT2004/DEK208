class NecroGhostPoltergeistDamageSphereEffect extends Emitter
	placeable;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'DEKStaticsMaster207P.fX.SphereDamage'
         RenderTwoSided=True
         UseParticleColor=True
         UseColorScale=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         MaxParticles=1
         SpinsPerSecondRange=(X=(Max=10.000000),Y=(Max=10.000000),Z=(Max=10.000000))
         SizeScale(0)=(RelativeSize=200.000000)
         StartSizeRange=(X=(Min=7.000000,Max=7.000000),Y=(Min=7.000000,Max=7.000000),Z=(Min=7.000000,Max=7.000000))
         InitialParticlesPerSecond=50000.000000
         DrawStyle=PTDS_AlphaBlend
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(0)=MeshEmitter'DEKMonsters208.NecroGhostPoltergeistDamageSphereEffect.MeshEmitter0'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_DumbProxy
     Skins(0)=FinalBlend'D-E-K-HoloGramFX.FullFB.HoloMaterial_0'
     Style=STY_Masked
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
     bDirectional=True
}
