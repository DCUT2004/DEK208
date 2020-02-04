class ShockTrapShockProjMinibolt extends Emitter;

var(Beam)       class<Emitter>  Explosion;
var(Beam)       float           MaxViewDistance;

simulated function SpawnEffects(Actor HitActor, Vector HitLocation, Vector HitNormal)
{
	local Rotator HitRotation;
	local PlayerController PC;
	local Emitter myExplosion;

	PC = Level.GetLocalPlayerController();

	if(!PC.BeyondViewDistance(HitLocation, MaxViewDistance))
    {
    	HitRotation = Rotator(HitNormal);

        // Spark explosion.
    	myExplosion = Spawn(Explosion,,, HitLocation, HitRotation);
    	myExplosion.SetBase(HitActor);
    }
}

defaultproperties
{
     Explosion=Class'DEKRPG208.ShockTrapShockProjMiniboltExplosion'
     MaxViewDistance=10000.000000
     Begin Object Class=BeamEmitter Name=BE0
         BeamDistanceRange=(Min=1000.000000,Max=1000.000000)
         DetermineEndPointBy=PTEP_Distance
         BeamTextureUScale=0.400000
         LowFrequencyNoiseRange=(X=(Max=20.000000),Y=(Max=20.000000),Z=(Max=20.000000))
         LowFrequencyPoints=5
         HighFrequencyNoiseRange=(X=(Max=10.000000),Y=(Max=10.000000),Z=(Max=10.000000))
         HighFrequencyPoints=4
         FadeOut=True
         RespawnDeadParticles=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=128,R=128,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=196,R=196,A=255))
         ColorMultiplierRange=(X=(Min=0.800000,Max=0.900000),Y=(Min=0.800000,Max=0.900000))
         FadeOutStartTime=0.400000
         MaxParticles=1
         UseRotationFrom=PTRS_Actor
         StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AS_FX_TX.Beams.HotBolt_1'
         LifetimeRange=(Min=0.500000,Max=1.000000)
         StartVelocityRange=(X=(Min=1.000000,Max=1.000000))
     End Object
     Emitters(0)=BeamEmitter'DEKRPG208.ShockTrapShockProjMinibolt.BE0'

     AutoDestroy=True
     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
}
