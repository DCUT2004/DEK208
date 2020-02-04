class IceWarlordRocketExplosion extends Emitter;

#exec OBJ LOAD FILE=ONSstructureTextures.utx

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-200.000000,Max=200.000000)
         StartSpinRange=(X=(Min=1.055000,Max=2.355000))
         SizeScale(0)=(RelativeTime=3.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=150.000000,Max=150.000000))
         InitialParticlesPerSecond=500.000000
         Texture=Texture'ONSstructureTextures.CoreBreachGroup.exp7_framesBLUE'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(0)=SpriteEmitter'DEKMonsters208.IceWarlordRocketExplosion.SpriteEmitter0'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_DumbProxy
}
