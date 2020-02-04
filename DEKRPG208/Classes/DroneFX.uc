class DroneFX extends Emitter;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=DroneBody
         StaticMesh=StaticMesh'XGame_rc.BallMesh'
         UseParticleColor=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         MaxParticles=1
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=9999.000000,Max=9999.000000)
         StartVelocityRange=(X=(Min=3000.000000,Max=3000.000000))
     End Object
     Emitters(0)=MeshEmitter'DEKRPG208.DroneFX.DroneBody'

     AutoDestroy=True
     bNoDelete=False
     LifeSpan=9999.000000
     PrePivot=(X=220.000000)
     AmbientGlow=254
}
