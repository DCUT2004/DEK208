class WildfireFlame extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=GlowEm0
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UniformSize=True
         UseRandomSubdivision=True
         Acceleration=(Y=10.000000,Z=270.000000)
         ColorScale(0)=(RelativeTime=2.000000,Color=(G=255,A=255))
         ColorMultiplierRange=(Z=(Min=0.000000))
         FadeOutStartTime=0.800000
         FadeInEndTime=0.200000
         CoordinateSystem=PTCS_Relative
         MaxParticles=8
         StartLocationRange=(X=(Max=-5.000000),Y=(Min=5.000000,Max=-5.000000),Z=(Max=10.000000))
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=25.000000)
         SpinsPerSecondRange=(X=(Min=-0.300000,Max=0.300000))
         StartSizeRange=(X=(Min=15.000000,Max=40.000000))
         UseSkeletalLocationAs=PTSU_Location
         SkeletalScale=(X=0.400000,Y=0.400000,Z=0.100000)
         Texture=Texture'EmitterTextures.MultiFrame.LargeFlames-grey'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=3.000000,Max=3.000000)
         StartVelocityRange=(X=(Min=5.000000,Max=-5.000000),Y=(Min=5.000000,Max=-5.000000),Z=(Min=-40.000000,Max=20.000000))
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG208.WildfireFlame.GlowEm0'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_SimulatedProxy
     bHardAttach=True
}
