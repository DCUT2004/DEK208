class ShockTrapShockProjTrail extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SE0
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UniformSize=True
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.800000,Max=0.900000),Y=(Min=0.800000,Max=0.900000))
         FadeOutStartTime=0.500000
         FadeInEndTime=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         Texture=Texture'AS_FX_TX.Flares.Laser_Flare'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=2.000000,Max=2.000000)
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG208.ShockTrapShockProjTrail.SE0'

     Begin Object Class=SpriteEmitter Name=SE1
         FadeOut=True
         UseRevolution=True
         UseRevolutionScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         UseVelocityScale=True
         ColorScale(0)=(Color=(B=255,G=196,R=196))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=196,R=196))
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.700000),Y=(Min=0.500000,Max=0.700000))
         Opacity=0.500000
         FadeOutStartTime=0.480000
         StartLocationShape=PTLS_Sphere
         RevolutionsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
         RevolutionScale(0)=(RelativeRevolution=(X=1.000000,Y=1.000000,Z=1.000000))
         RevolutionScale(1)=(RelativeTime=0.500000,RelativeRevolution=(X=1.000000,Y=1.000000,Z=1.000000))
         RevolutionScale(2)=(RelativeTime=1.000000)
         SpinsPerSecondRange=(X=(Min=1.000000,Max=4.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.500000)
         SizeScale(2)=(RelativeTime=0.750000,RelativeSize=0.100000)
         SizeScale(3)=(RelativeTime=0.870000)
         StartSizeRange=(X=(Min=25.000000),Y=(Min=2.500000,Max=2.500000),Z=(Min=2.500000,Max=2.500000))
         Texture=Texture'AW-2004Particles.Energy.ElecPanels'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.000000,Max=3.000000)
         StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=-300.000000,Max=300.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=1.000000)
     End Object
     Emitters(1)=SpriteEmitter'DEKRPG208.ShockTrapShockProjTrail.SE1'

     Begin Object Class=BeamEmitter Name=BE2
         BeamDistanceRange=(Min=200.000000,Max=200.000000)
         DetermineEndPointBy=PTEP_Distance
         LowFrequencyPoints=2
         HighFrequencyPoints=2
         FadeOut=True
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.700000),Y=(Min=0.700000))
         FadeOutStartTime=0.100000
         StartSizeRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-200.000000,Max=200.000000))
         Texture=Texture'AW-2004Particles.Energy.PowerBolt'
         LifetimeRange=(Min=0.100000,Max=0.400000)
         StartVelocityRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
     End Object
     Emitters(2)=BeamEmitter'DEKRPG208.ShockTrapShockProjTrail.BE2'

     bNoDelete=False
     LifeSpan=30.000000
     bHardAttach=True
}
