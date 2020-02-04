class NecroGhostShamanTrail extends Emitter;

#exec OBJ LOAD FILE=..\Textures\AWGlobal.utx	

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
}

simulated event PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	SetTimer(0.5, true);
}

simulated function Timer()
{
	local Projectile P;
    
    P = Projectile(Owner);
    if(P == None)
    {
		Destroy();
		Kill();
		SetTimer(0, false);
    }
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         MaxParticles=3
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=1.000000,Max=4.000000)
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Min=0.550000,Max=0.450000))
         SizeScale(0)=(RelativeSize=4.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=3.000000,Max=5.000000))
         ParticlesPerSecond=8.000000
         InitialParticlesPerSecond=10.000000
         Texture=Texture'AWGlobal.Liquids.Bloodflow2'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.300000,Max=1.400000)
     End Object
     Emitters(0)=SpriteEmitter'DEKMonsters208.NecroGhostShamanTrail.SpriteEmitter0'

     AutoDestroy=True
     bNoDelete=False
     Physics=PHYS_Trailer
     RemoteRole=ROLE_DumbProxy
     Style=STY_Additive
     bHardAttach=True
     bDirectional=True
}
