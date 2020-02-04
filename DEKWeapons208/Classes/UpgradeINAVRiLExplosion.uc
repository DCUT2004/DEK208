class UpgradeINAVRiLExplosion extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter11
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         Opacity=0.800000
         FadeOutStartTime=0.300000
         MaxParticles=2
         StartLocationRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=50.000000))
         StartLocationPolarRange=(X=(Max=65536.000000),Y=(Min=16384.000000,Max=16384.000000),Z=(Min=80.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=0.250000,RelativeSize=3.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=75.000000,Max=125.000000),Y=(Min=75.000000),Z=(Min=75.000000))
         Sounds(0)=(Sound=Sound'ONSVehicleSounds-S.Explosions.Explosion06',Radius=(Min=500.000000,Max=15000.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=2.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_LinearLocal
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=15.000000
         Texture=Texture'ExplosionTex.Framed.exp1_frames'
         TextureUSubdivisions=2
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.700000,Max=0.700000)
         VelocityScale(0)=(RelativeTime=1.000000,RelativeVelocity=(Z=2.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(Z=0.100000))
     End Object
     Emitters(0)=SpriteEmitter'DEKWeapons208.UpgradeINAVRiLExplosion.SpriteEmitter11'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_DumbProxy
     DrawScale=10.000000
}
