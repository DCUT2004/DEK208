class ShockTrapShockProjMiniboltExplosion extends Emitter;

#exec OBJ LOAD FILE=AW-2004Particles.utx

var(Sound)      Sound           ExplosionSound;
var(Sound)      float           ExplosionSoundVolume;
var(Sound)      float           ExplosionSoundRadius;
var(Sound)      Range           ExplosionSoundPitch;

/** Sound: Play explosion sound at the impact site. */
event PostNetBeginPlay()
{
    local float myExplosionSoundPitch;

    super.PostNetBeginPlay();

    myExplosionSoundPitch = ExplosionSoundPitch.Min + FRand() * (ExplosionSoundPitch.Max - ExplosionSoundPitch.Min);
    PlaySound(ExplosionSound, SLOT_Misc, ExplosionSoundVolume,, ExplosionSoundRadius,, false);
}

defaultproperties
{
     ExplosionSound=Sound'WeaponSounds.BaseImpactAndExplosions.BExplosion4'
     ExplosionSoundVolume=0.700000
     ExplosionSoundRadius=100.000000
     ExplosionSoundPitch=(Min=0.100000,Max=10.000000)
     Begin Object Class=SpriteEmitter Name=SE0
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=150,R=150))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=150,R=150))
         Opacity=0.500000
         FadeOutStartTime=0.600000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-20.000000,Max=20.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=40.000000,Max=60.000000),Y=(Min=40.000000,Max=60.000000),Z=(Min=40.000000,Max=60.000000))
         InitialParticlesPerSecond=10.000000
         Texture=Texture'AW-2004Explosions.Fire.Part_explode2s'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.400000,Max=0.600000)
         StartVelocityRange=(X=(Max=100.000000),Y=(Max=100.000000),Z=(Max=100.000000))
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG208.ShockTrapShockProjMiniboltExplosion.SE0'

     Begin Object Class=SpriteEmitter Name=SE1
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(X=1.000000,Z=0.000000)
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=200,R=200))
         MaxParticles=2
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Min=20.000000,Max=40.000000),Y=(Min=20.000000,Max=40.000000),Z=(Min=20.000000,Max=40.000000))
         InitialParticlesPerSecond=10.000000
         Texture=Texture'EpicParticles.Smoke.SparkCloud_01aw'
         LifetimeRange=(Min=0.300000,Max=0.500000)
     End Object
     Emitters(1)=SpriteEmitter'DEKRPG208.ShockTrapShockProjMiniboltExplosion.SE1'

     AutoDestroy=True
     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
     bDirectional=True
}
