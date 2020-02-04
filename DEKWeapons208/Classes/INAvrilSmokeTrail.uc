//--------------------------------------------------------------
//
//--------------------------------------------------------------
class INAvrilSmokeTrail extends Emitter;

#exec OBJ LOAD FILE="..\Textures\AW-2004Particles.utx"

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter8
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=210,G=157,R=85))
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=130,G=226,R=255))
         ColorScale(2)=(RelativeTime=0.300000,Color=(G=135,R=225))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=6
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=7.000000,Max=12.000000))
         ParticlesPerSecond=20.000000
         InitialParticlesPerSecond=20.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaFlare'
         LifetimeRange=(Min=0.100000,Max=0.300000)
     End Object
     Emitters(0)=SpriteEmitter'DEKWeapons208.INAvrilSmokeTrail.SpriteEmitter8'

     AutoDestroy=True
     bNoDelete=False
     AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
     bHardAttach=True
     SoundVolume=200
     SoundRadius=100.000000
}
