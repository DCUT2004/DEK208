class NecroSorcererReviveFX extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         RespawnDeadParticles=False
         UniformSize=True
         Acceleration=(Z=-100.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.500000
         FadeOutFactor=(Y=0.700000,Z=0.500000)
         FadeOutStartTime=2.080000
         MaxParticles=5
         InitialParticlesPerSecond=100.000000
         Texture=Texture'XEffects.Skins.LBBT'
         LifetimeRange=(Min=3.300000,Max=3.300000)
         StartVelocityRange=(X=(Min=-30.000000,Max=30.000000),Y=(Min=-30.000000,Max=30.000000),Z=(Min=150.000000,Max=150.000000))
     End Object
     Emitters(0)=SpriteEmitter'DEKMonsters208.NecroSorcererReviveFX.SpriteEmitter0'

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
