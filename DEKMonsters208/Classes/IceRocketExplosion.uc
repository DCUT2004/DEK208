class IceRocketExplosion extends NewExplosionA;

defaultproperties
{
     ExplosionTextures(0)=Texture'ExplosionTex.Framed.exp2_framesP'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         MaxParticles=3
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=24.000000,Max=24.000000)
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=50.000000,Max=70.000000),Y=(Min=50.000000,Max=70.000000),Z=(Min=50.000000,Max=70.000000))
         InitialParticlesPerSecond=10.000000
         Texture=Texture'ExplosionTex.Framed.exp2_framesP'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.400000,Max=0.600000)
     End Object
     Emitters(0)=SpriteEmitter'DEKMonsters208.IceRocketExplosion.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         UseVelocityScale=True
         Acceleration=(Z=20.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.125000,Color=(B=255,G=251,R=188))
         ColorScale(2)=(RelativeTime=0.330000,Color=(B=255,G=251,R=188,A=255))
         ColorScale(3)=(RelativeTime=0.750000,Color=(B=255,G=251,R=188,A=255))
         ColorScale(4)=(RelativeTime=1.000000,Color=(B=255,G=251,R=188))
         MaxParticles=15
         StartLocationShape=PTLS_Polar
         StartLocationPolarRange=(Y=(Min=-32768.000000,Max=32768.000000),Z=(Min=10.000000,Max=10.000000))
         UseRotationFrom=PTRS_Actor
         RotationOffset=(Yaw=-16384)
         SpinsPerSecondRange=(X=(Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
         InitialParticlesPerSecond=500.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'ExplosionTex.Framed.SmokeReOrdered'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRadialRange=(Min=200.000000,Max=200.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.300000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
         VelocityScale(2)=(RelativeTime=1.000000)
     End Object
     Emitters(1)=SpriteEmitter'DEKMonsters208.IceRocketExplosion.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         FadeOutStartTime=0.050000
         MaxParticles=1
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=2.000000,Max=2.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.700000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=110.000000,Max=120.000000),Y=(Min=110.000000,Max=120.000000),Z=(Min=80.000000,Max=90.000000))
         InitialParticlesPerSecond=10.000000
         Texture=Texture'XEffects.Skins.seexpt'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.300000,Max=0.300000)
     End Object
     Emitters(2)=SpriteEmitter'DEKMonsters208.IceRocketExplosion.SpriteEmitter2'

}
