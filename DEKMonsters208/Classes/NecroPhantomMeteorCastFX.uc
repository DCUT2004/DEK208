class NecroPhantomMeteorCastFX extends Emitter;

defaultproperties
{
     Begin Object Class=BeamEmitter Name=BeamEmitter0
         BeamDistanceRange=(Min=400.000000,Max=400.000000)
         DetermineEndPointBy=PTEP_Distance
         RotatingSheets=1
         HighFrequencyNoiseRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
         HighFrequencyPoints=4
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=90,G=3,R=72,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=97,G=9,R=130,A=255))
         FadeOutStartTime=0.205000
         FadeInEndTime=0.205000
         MaxParticles=8
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'XEffects.Skins.pcl_ball'
         LifetimeRange=(Min=0.750000,Max=0.750000)
         InitialDelayRange=(Max=3.000000)
         StartVelocityRange=(Z=(Min=20.000000,Max=20.000000))
         RelativeWarmupTime=2.000000
     End Object
     Emitters(1)=BeamEmitter'DEKMonsters208.NecroPhantomMeteorCastFX.BeamEmitter0'

     AutoDestroy=True
     bNoDelete=False
     bTrailerSameRotation=True
     bReplicateMovement=False
     Physics=PHYS_Trailer
     RemoteRole=ROLE_SimulatedProxy
     CollisionRadius=25.000000
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
}
