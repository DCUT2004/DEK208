class DEKSkyMineBeam extends ONSBellyTurretFire;

simulated function PostNetBeginPlay()
{
}

defaultproperties
{
     Begin Object Class=BeamEmitter Name=BeamEmitter0
         BeamDistanceRange=(Min=1.000000,Max=1.000000)
         DetermineEndPointBy=PTEP_Distance
         RotatingSheets=3
         LowFrequencyPoints=2
         HighFrequencyPoints=2
         BranchProbability=(Max=1.000000)
         BranchSpawnAmountRange=(Max=2.000000)
         UseColorScale=True
         RespawnDeadParticles=False
         AlphaTest=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=89,G=180,R=210))
         ColorScale(1)=(RelativeTime=1.000000,Color=(G=25,R=40))
         MaxParticles=1
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.250000)
         StartSizeRange=(X=(Min=-12.000000,Max=-12.000000),Y=(Min=15.000000,Max=15.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'AW-2k4XP.Cicada.LongSpark'
         LifetimeRange=(Min=0.300000,Max=0.300000)
         StartVelocityRange=(X=(Min=500.000000,Max=500.000000))
     End Object
     Emitters(0)=BeamEmitter'DEKRPG208.DEKSkyMineBeam.BeamEmitter0'

     Begin Object Class=BeamEmitter Name=BeamEmitter1
         BeamDistanceRange=(Min=1.000000,Max=1.000000)
         DetermineEndPointBy=PTEP_Distance
         RotatingSheets=3
         LowFrequencyPoints=2
         HighFrequencyPoints=2
         BranchProbability=(Max=1.000000)
         BranchSpawnAmountRange=(Max=2.000000)
         UseColorScale=True
         RespawnDeadParticles=False
         AlphaTest=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(G=128,R=255))
         ColorScale(1)=(RelativeTime=0.800000,Color=(G=128,R=255))
         ColorScale(2)=(RelativeTime=1.000000)
         Opacity=0.500000
         MaxParticles=1
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=15.000000,Max=15.000000),Y=(Min=15.000000,Max=15.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'AW-2k4XP.Cicada.LongSpark'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRange=(X=(Min=500.000000,Max=500.000000))
     End Object
     Emitters(1)=BeamEmitter'DEKRPG208.DEKSkyMineBeam.BeamEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(X=1.000000,Z=0.000000)
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=32,G=128,R=192))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=16,G=64,R=96))
         MaxParticles=1
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=75.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar2'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(2)=SpriteEmitter'DEKRPG208.DEKSkyMineBeam.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter11
         UseColorScale=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         ColorScale(0)=(Color=(G=128,R=235))
         ColorScale(1)=(RelativeTime=0.800000,Color=(G=128,R=235))
         ColorScale(2)=(RelativeTime=1.000000)
         Opacity=0.400000
         MaxParticles=1
         StartLocationOffset=(X=10.000000)
         StartLocationRange=(X=(Max=20.000000))
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=30.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaFlare'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(3)=SpriteEmitter'DEKRPG208.DEKSkyMineBeam.SpriteEmitter11'

}
