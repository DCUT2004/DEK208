//-----------------------------------------------------------
// CycloneXMPGutBlowFX.uc
// (c) 2004 jasonyu
// 17 February 2005
//
//-----------------------------------------------------------
class MTGutBlowFX extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         InitialParticlesPerSecond=25.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XGameShadersB.Blood.BloodJetc'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.500000,Max=1.500000)
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-200.000000,Max=200.000000))
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG208.MTGutblowFX.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         RespawnDeadParticles=False
         UniformSize=True
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.000000
         MaxParticles=1
         Sounds(0)=(Sound=Sound'CicadaSnds.BellyLaser.BellyLaserFire',Radius=(Min=250.000000,Max=250.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=25.000000,Max=25.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_LinearGlobal
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(1)=SpriteEmitter'DEKRPG208.MTGutblowFX.SpriteEmitter2'

     AutoDestroy=True
     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
     bDirectional=True
}
