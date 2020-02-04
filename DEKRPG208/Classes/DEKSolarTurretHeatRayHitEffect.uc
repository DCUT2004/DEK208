class DEKSolarTurretHeatRayHitEffect extends Emitter;


#exec obj load file=..\StaticMeshes\EffectMeshes.usx
#exec obj load file=..\Textures\EmitterTextures.utx
#exec obj load file=..\Textures\EpicParticles.utx
#exec obj load file=..\Textures\AW-2004Particles.utx


simulated function PostBeginPlay()
{
	Instigator = None;
	if (!EffectIsRelevant(Location, False))
		Emitters[1].Disabled = True;
}

simulated function SetNonWorldHit()
{
	Emitters[0].Disabled = True;
	Emitters[2].Disabled = True;
	Emitters[3].Disabled = True;
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MoltenSpot
         StaticMesh=StaticMesh'EffectMeshes.Particles.DirtChunk_01aw'
         RespawnDeadParticles=False
         AlphaTest=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Y=(Min=0.700000),Z=(Min=0.300000,Max=0.400000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(Y=(Min=0.250000,Max=0.250000))
         RotationNormal=(X=1.000000)
         SizeScale(1)=(RelativeTime=0.100000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=2.500000,Max=3.000000),Y=(Min=2.500000,Max=3.000000),Z=(Min=0.300000,Max=0.400000))
         InitialParticlesPerSecond=20.000000
         DrawStyle=PTDS_Brighten
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(0)=MeshEmitter'DEKRPG208.DEKSolarTurretHeatRayHitEffect.MoltenSpot'

     Begin Object Class=TrailEmitter Name=Sparks
         MaxPointsPerTrail=10
         UseCrossedSheets=True
         FadeOut=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         Acceleration=(Z=-900.000000)
         ColorMultiplierRange=(Y=(Min=0.500000),Z=(Min=0.000000,Max=0.500000))
         DetailMode=DM_High
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=20.000000)
         UseRotationFrom=PTRS_Actor
         StartSizeRange=(X=(Min=3.000000,Max=5.000000))
         InitialParticlesPerSecond=30.000000
         Texture=Texture'EpicParticles.Beams.WhiteStreak01aw'
         LifetimeRange=(Min=0.800000,Max=1.000000)
         StartVelocityRange=(X=(Min=-500.000000,Max=-200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-200.000000,Max=200.000000))
     End Object
     Emitters(1)=TrailEmitter'DEKRPG208.DEKSolarTurretHeatRayHitEffect.Sparks'

     Begin Object Class=SpriteEmitter Name=HotspotSprite
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(X=1.000000,Z=0.000000)
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         FadeOutStartTime=0.500000
         FadeInEndTime=0.100000
         MaxParticles=2
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=25.000000,Max=35.000000))
         InitialParticlesPerSecond=10.000000
         Texture=Texture'AW-2004Particles.Fire.NapalmSpot'
         LifetimeRange=(Min=1.500000,Max=1.700000)
     End Object
     Emitters(2)=SpriteEmitter'DEKRPG208.DEKSolarTurretHeatRayHitEffect.HotspotSprite'

     Begin Object Class=SpriteEmitter Name=Fumes
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         Acceleration=(Z=250.000000)
         ColorMultiplierRange=(Y=(Min=0.700000),Z=(Min=0.100000,Max=0.300000))
         MaxParticles=3
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Max=0.600000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=15.000000,Max=20.000000))
         InitialParticlesPerSecond=15.000000
         Texture=Texture'EmitterTextures.MultiFrame.LargeFlames-grey'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.300000,Max=0.500000)
         StartVelocityRange=(X=(Min=-100.000000,Max=-70.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-20.000000,Max=20.000000))
     End Object
     Emitters(3)=SpriteEmitter'DEKRPG208.DEKSolarTurretHeatRayHitEffect.Fumes'

     Begin Object Class=SpriteEmitter Name=FlashSprite
         FadeOut=True
         RespawnDeadParticles=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Z=(Min=0.500000,Max=0.500000))
         MaxParticles=1
         StartSizeRange=(X=(Min=50.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'EpicParticles.Flares.FlashFlare1'
         LifetimeRange=(Min=0.250000,Max=0.250000)
     End Object
     Emitters(4)=SpriteEmitter'DEKRPG208.DEKSolarTurretHeatRayHitEffect.FlashSprite'

     AutoDestroy=True
     bNoDelete=False
     LifeSpan=2.000000
     AmbientGlow=254
}
