class AerialTrapBeacon extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseColorScale=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=81,G=110,R=255))
         ColorScale(1)=(RelativeTime=1.000000)
         FadeInEndTime=0.250000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=7.000000,Max=7.000000))
         InitialParticlesPerSecond=4.000000
         Texture=Texture'AW-2004Particles.Energy.AirBlast'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         InitialDelayRange=(Min=0.300000,Max=0.300000)
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG208.AerialTrapBeacon.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(1)=(RelativeTime=0.750000,Color=(B=81,G=110,R=255))
         ColorScale(2)=(RelativeTime=1.000000)
         Opacity=0.250000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=17.000000,Max=17.000000))
         InitialParticlesPerSecond=4.000000
         Texture=Texture'AW-2004Particles.Energy.EclipseCircle'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         InitialDelayRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(1)=SpriteEmitter'DEKRPG208.AerialTrapBeacon.SpriteEmitter5'

     TimeTillResetRange=(Min=5.000000,Max=5.000000)
     AutoReset=True
     CullDistance=5000.000000
     bNoDelete=False
}
