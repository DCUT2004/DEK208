class WildfireFlameFX extends Emitter;

simulated function PostNetBeginPlay()
{

	SetTimer(2.0, false);
}
simulated function Timer()
{
	Kill();
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseCollision=True
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseSubdivisionScale=True
         UseRandomSubdivision=True
         ColorScale(0)=(Color=(B=80,G=250,R=10))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=60,G=255,R=40,A=255))
         MaxParticles=100
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=1.000000,Max=150.000000)
         SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=2.000000))
         SizeScale(0)=(RelativeSize=3.750000)
         SizeScale(1)=(RelativeTime=0.750000,RelativeSize=3.750000)
         StartSizeRange=(X=(Min=2.000000,Max=6.000000))
         Texture=Texture'EmitterTextures.MultiFrame.LargeFlames'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.800000,Max=2.000000)
         StartVelocityRange=(X=(Min=5.000000,Max=-5.000000),Y=(Min=5.000000,Max=-5.000000),Z=(Min=-5.000000,Max=5.000000))
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG208.WildfireFlameFX.SpriteEmitter1'

     AutoDestroy=True
     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
}
