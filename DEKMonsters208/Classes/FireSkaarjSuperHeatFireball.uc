class FireSkaarjSuperHeatFireball extends Emitter;

simulated function PostBeginPlay()
{
	local PlayerController PC;
	
	Super.PostBeginPlay();
		
	PC = Level.GetLocalPlayerController();
	if ( (PC.ViewTarget == None) || (VSize(PC.ViewTarget.Location - Location) > 4000) )
		Emitters[2].Disabled = true;
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         FadeIn=True
         ResetAfterChange=True
         AutoReset=True
         SpinParticles=True
         UniformSize=True
         FadeOutStartTime=0.320000
         FadeInEndTime=0.050000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSpinRange=(X=(Min=0.132000,Max=0.900000))
         StartSizeRange=(X=(Min=25.312500,Max=25.312500),Y=(Min=36.562500,Max=36.562500),Z=(Min=36.562500,Max=36.562500))
         Texture=Texture'XEffects.Skins.MuzFlashWhite_t'
         LifetimeRange=(Min=0.350000,Max=0.350000)
         WarmupTicksPerSecond=20.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(0)=SpriteEmitter'DEKMonsters208.FireSkaarjSuperHeatFireball.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         FadeIn=True
         ResetAfterChange=True
         AutoReset=True
         SpinParticles=True
         UniformSize=True
         FadeOutStartTime=0.200000
         FadeInEndTime=0.250000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.300000))
         StartSpinRange=(X=(Min=0.154000,Max=0.913000))
         StartSizeRange=(X=(Min=33.750000,Max=33.750000))
         InitialParticlesPerSecond=2.000000
         Texture=Texture'AW-2004Explosions.Fire.Fireball3'
         LifetimeRange=(Min=0.400000,Max=0.400000)
         WarmupTicksPerSecond=20.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(1)=SpriteEmitter'DEKMonsters208.FireSkaarjSuperHeatFireball.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         FadeIn=True
         ResetAfterChange=True
         AutoReset=True
         UniformSize=True
         FadeOutStartTime=0.300000
         FadeInEndTime=0.100000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         DetailMode=DM_High
         StartSizeRange=(X=(Min=2.531250,Max=2.531250))
         Texture=Texture'AW-2004Explosions.Fire.Fireball4'
         LifetimeRange=(Min=0.350000,Max=0.350000)
         StartVelocityRange=(X=(Min=-70.000000,Max=70.000000),Y=(Min=-70.000000,Max=70.000000),Z=(Min=-70.000000,Max=70.000000))
         VelocityScale(0)=(RelativeTime=1.000000,RelativeVelocity=(X=-1.000000,Y=-1.000000,Z=-1.000000))
         WarmupTicksPerSecond=50.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(2)=SpriteEmitter'DEKMonsters208.FireSkaarjSuperHeatFireball.SpriteEmitter2'

     bNoDelete=False
}
