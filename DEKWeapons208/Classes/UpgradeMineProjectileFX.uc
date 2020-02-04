class UpgradeMineProjectileFX extends Emitter;

Simulated Function PostBeginPlay()
{
    local PlayerController PC;

    Super.PostBeginPlay();

    PC = Level.GetLocalPlayerController();

    if ( PC.ViewTarget != None )
        Emitters[2].Disabled = ( VSize(PC.ViewTarget.Location - Location) > 5000 );
    else
    {
        Emitters[2].Disabled = True;
        Emitters[0].Disabled = True;
    }
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         ColorMultiplierRange=(X=(Min=0.250000,Max=0.250000),Y=(Min=0.500000,Max=0.500000))
         Opacity=0.500000
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=24.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
         StartSizeRange=(X=(Min=25.000000,Max=30.000000))
         InitialParticlesPerSecond=3000.000000
         Texture=Texture'AW-2004Explosions.Fire.Part_explode2'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.400000,Max=0.400000)
     End Object
     Emitters(0)=SpriteEmitter'DEKWeapons208.UpgradeMineProjectileFX.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseCollision=True
         UseColorScale=True
         RespawnDeadParticles=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.700000,Color=(B=60,G=187,R=255))
         ColorScale(2)=(RelativeTime=1.000000)
         ColorMultiplierRange=(X=(Min=0.250000,Max=0.250000),Y=(Min=0.500000,Max=0.500000))
         MaxParticles=20
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-8.000000,Max=8.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=40.000000,Max=50.000000))
         InitialParticlesPerSecond=50000.000000
         Texture=Texture'EpicParticles.Flares.Sharpstreaks'
         LifetimeRange=(Min=0.250000,Max=0.250000)
         StartVelocityRadialRange=(Min=-1000.000000,Max=-750.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(1)=SpriteEmitter'DEKWeapons208.UpgradeMineProjectileFX.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(X=(Min=0.750000,Max=0.750000),Y=(Min=0.800000,Max=0.800000))
         Opacity=0.750000
         FadeOutStartTime=0.075000
         FadeInEndTime=0.050000
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=150.000000,Max=150.000000))
         InitialParticlesPerSecond=50.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(2)=SpriteEmitter'DEKWeapons208.UpgradeMineProjectileFX.SpriteEmitter3'

     AutoDestroy=True
     bNoDelete=False
     LifeSpan=1.000000
}
