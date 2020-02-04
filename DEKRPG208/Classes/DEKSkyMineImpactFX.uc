class DEKSkyMineImpactFX extends FX_PlasmaImpact;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter34
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(G=125,R=255))
         ColorScale(1)=(RelativeTime=0.500000,Color=(G=125,R=255))
         ColorScale(2)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=2.000000,Max=50.000000))
         InitialParticlesPerSecond=300.000000
         Texture=Texture'AS_FX_TX.Flares.Laser_Flare'
         LifetimeRange=(Min=0.400000,Max=0.600000)
         StartVelocityRange=(X=(Min=75.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=-300.000000,Max=300.000000))
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG208.DEKSkyMineImpactFX.SpriteEmitter34'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter35
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(G=125,R=255))
         ColorScale(1)=(RelativeTime=0.500000,Color=(G=125,R=255))
         ColorScale(2)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         SpinsPerSecondRange=(X=(Min=0.010000,Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=25.000000,Max=50.000000))
         InitialParticlesPerSecond=30.000000
         Texture=Texture'AS_FX_TX.Flares.Laser_Flare'
         LifetimeRange=(Min=0.670000,Max=0.670000)
     End Object
     Emitters(1)=SpriteEmitter'DEKRPG208.DEKSkyMineImpactFX.SpriteEmitter35'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter36
         UseColorScale=True
         RespawnDeadParticles=False
         Disabled=True
         Backup_Disabled=True
         SpinParticles=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=128,R=64))
         ColorScale(1)=(RelativeTime=0.500000,Color=(G=125,R=255))
         ColorScale(2)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=2.000000,Max=50.000000))
         InitialParticlesPerSecond=300.000000
         Texture=Texture'AS_FX_TX.Flares.Laser_Flare'
         LifetimeRange=(Min=0.400000,Max=0.600000)
         StartVelocityRange=(X=(Min=75.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=-300.000000,Max=300.000000))
     End Object
     Emitters(2)=SpriteEmitter'DEKRPG208.DEKSkyMineImpactFX.SpriteEmitter36'

}
