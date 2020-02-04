class IceMercenaryPlasmaHitEffect extends Emitter;

simulated function PostNetBeginPlay()
{
	local PlayerController PC;
	local float MaxDist;
	
	Super.PostNetBeginPlay();
		
	PC = Level.GetLocalPlayerController();
	if ( (Instigator == None) || (PC != None && PC.Pawn != None && PC.Pawn != Instigator) )
		MaxDist = 2000;
	else
		MaxDist = 3000;
	if ( (PC != None && PC.ViewTarget == None) || (PC != None && VSize(PC.ViewTarget.Location - Location) > MaxDist) )
		Emitters[2].Disabled = true;
}	

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(X=1.000000,Z=0.000000)
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         ColorScale(1)=(RelativeTime=0.250000,Color=(B=255,G=255,R=186))
         ColorScale(2)=(RelativeTime=0.750000,Color=(B=255,G=255,R=186))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=1
         StartLocationOffset=(X=-2.000000)
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=30.000000,Max=60.000000))
         InitialParticlesPerSecond=250.000000
         Texture=Texture'AW-2004Particles.Weapons.SmokePanels1'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(0)=SpriteEmitter'DEKMonsters208.IceMercenaryPlasmaHitEffect.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(X=1.000000,Z=0.000000)
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=128))
         ColorScale(1)=(RelativeTime=0.800000,Color=(B=255,G=255,R=186))
         ColorScale(2)=(RelativeTime=1.000000)
         Opacity=0.800000
         MaxParticles=1
         StartLocationOffset=(X=-2.000000)
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=100.000000,Max=125.000000))
         InitialParticlesPerSecond=250.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(1)=SpriteEmitter'DEKMonsters208.IceMercenaryPlasmaHitEffect.SpriteEmitter5'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter7
         UseDirectionAs=PTDU_Scale
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=186))
         ColorScale(1)=(RelativeTime=0.700000,Color=(B=255,G=255,R=186))
         ColorScale(2)=(RelativeTime=1.000000)
         MaxParticles=1
         StartLocationOffset=(X=-4.000000)
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=25.000000,Max=25.000000))
         InitialParticlesPerSecond=2500.000000
         Texture=Texture'EpicParticles.Flares.FlashFlare1'
         LifetimeRange=(Min=0.300000,Max=0.300000)
     End Object
     Emitters(2)=SpriteEmitter'DEKMonsters208.IceMercenaryPlasmaHitEffect.SpriteEmitter7'
	 
     AutoDestroy=True
	 bNoDelete=False
}