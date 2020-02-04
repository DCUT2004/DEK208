class NecroPhantomMiniMeteorGroundFX extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter77
         UseDirectionAs=PTDU_Normal
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(1)=(RelativeTime=0.330000,Color=(B=255,G=192,R=160))
         ColorScale(2)=(RelativeTime=0.670000,Color=(B=255,G=192,R=160))
         ColorScale(3)=(RelativeTime=1.000000)
         Opacity=0.670000
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartLocationOffset=(Z=-32.000000)
         StartLocationRange=(Z=(Min=-16.000000,Max=16.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Min=75.000000))
         InitialParticlesPerSecond=4.000000
         Texture=Texture'AW-2004Particles.Energy.AirBlast'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.670000,Max=0.670000)
     End Object
     Emitters(0)=SpriteEmitter'OnslaughtFull.FX_IonPlasmaTank_ShockWave.SpriteEmitter77'

     AutoDestroy=True
     bNoDelete=False
     RemoteRole=ROLE_DumbProxy
     bDirectional=True
}
