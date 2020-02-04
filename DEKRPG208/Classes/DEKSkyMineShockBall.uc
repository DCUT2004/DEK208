class DEKSkyMineShockBall extends Emitter;

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
         StartSizeRange=(X=(Min=45.000000,Max=45.000000),Y=(Min=65.000000,Max=65.000000),Z=(Min=65.000000,Max=65.000000))
         Texture=Texture'XEffects.PainterDecalMark'
         LifetimeRange=(Min=0.350000,Max=0.350000)
         WarmupTicksPerSecond=20.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG208.DEKSkyMineShockBall.SpriteEmitter0'

}
