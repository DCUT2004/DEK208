class WildfireExplodeFX extends Emitter;

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
         ColorScale(0)=(Color=(B=80,G=250,R=10))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=60,G=255,R=40,A=255))
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-200.000000,Max=200.000000)
         StartSpinRange=(X=(Min=1.055000,Max=2.355000))
         SizeScale(0)=(RelativeTime=3.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=75.000000,Max=75.000000))
         InitialParticlesPerSecond=550.000000
         Texture=Texture'VMParticleTextures.VehicleExplosions.VMExp2_framesANIM'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.750000,Max=0.750000)
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG208.WildfireExplodeFX.SpriteEmitter0'

     AutoDestroy=True
     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
}
