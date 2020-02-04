class LingeringSpiritFX extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         ColorScale(0)=(Color=(B=0,G=0,R=142))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=0,G=0,R=142))
         ColorScale(2)=(RelativeTime=1.000000)
         ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=37.500000,Max=56.250000))
         InitialParticlesPerSecond=500.000000
         Texture=Texture'AW-2004Particles.Energy.ElecPanels'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG208.LingeringSpiritFX.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         Opacity=0.200000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=67.500000))
         InitialParticlesPerSecond=20.000000
         Texture=Texture'XEffects.Skins.PainterDecalMark'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(1)=SpriteEmitter'DEKRPG208.LingeringSpiritFX.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         ProjectionNormal=(X=1.000000,Z=0.000000)
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=0,G=0,R=142))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=0,G=0,R=142))
         ColorScale(2)=(RelativeTime=1.000000)
         Opacity=0.900000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationOffset=(X=-2.000000)
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=150.000000,Max=187.500000))
         InitialParticlesPerSecond=500.000000
         Texture=Texture'XEffects.Shark.RedMarker_t'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(3)=SpriteEmitter'DEKRPG208.LingeringSpiritFX.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         UseColorScale=True
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=0,G=0,R=142))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=0,G=0,R=142))
         ColorScale(2)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=35
         DetailMode=DM_High
         StartLocationShape=PTLS_Polar
         StartLocationPolarRange=(Y=(Max=65536.000000),Z=(Min=8.000000,Max=64.000000))
         UseRotationFrom=PTRS_Actor
         RotationOffset=(Yaw=16384)
         SpinsPerSecondRange=(X=(Max=0.050000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=7.500000,Max=22.500000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'EmitterTextures.Flares.EFlareR'
         LifetimeRange=(Min=0.250000,Max=0.750000)
         StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Min=-150.000000,Max=150.000000))
         StartVelocityRadialRange=(Min=-100.000000,Max=-150.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(4)=SpriteEmitter'DEKRPG208.LingeringSpiritFX.SpriteEmitter5'

     bNoDelete=False
     bHardAttach=True
}
