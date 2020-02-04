class DEKSolarTurretEnergyWaveTrailer extends Emitter notplaceable;

#exec obj load file=..\Textures\AW-2004Particles.utx

var Material BlueSkin;
var rangevector BlueColorMultiplier;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Emitters[1].StartSpinRange.X.Min = Rotation.Yaw   / 65536.0;
	Emitters[1].StartSpinRange.Y.Min = Rotation.Pitch / 65536.0;
	Emitters[1].StartSpinRange.Z.Min = Rotation.Roll  / 65536.0;
	Emitters[1].StartSpinRange.X.Max = Emitters[1].StartSpinRange.X.Min;
	Emitters[1].StartSpinRange.Y.Max = Emitters[1].StartSpinRange.Y.Min;
	Emitters[1].StartSpinRange.Z.Max = Emitters[1].StartSpinRange.Z.Min;
}


simulated function SetBlueEffects()
{
	Emitters[0].ColorMultiplierRange = BlueColorMultiplier;
	Skins[0] = BlueSkin;
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     BlueColorMultiplier=(X=(Min=0.100000,Max=0.200000),Y=(Min=0.400000,Max=0.800000),Z=(Min=1.000000,Max=1.000000))
     Begin Object Class=TrailEmitter Name=ShockwaveTrail
         TrailShadeType=PTTST_Linear
         MaxPointsPerTrail=10
         DistanceThreshold=80.000000
         UseCrossedSheets=True
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Y=(Min=0.400000,Max=0.800000),Z=(Min=0.100000,Max=0.100000))
         DetailMode=DM_High
         StartLocationRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=-5.000000,Max=5.000000))
         StartLocationShape=PTLS_All
         StartLocationPolarRange=(X=(Min=16384.000000,Max=16384.000000),Y=(Min=65536.000000),Z=(Min=3.000000,Max=3.000000))
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=150.000000,Max=200.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Energy.AngryBeam'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRadialRange=(Min=-3000.000000,Max=-3000.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(0)=TrailEmitter'DEKRPG208.DEKSolarTurretEnergyWaveTrailer.ShockwaveTrail'

     Begin Object Class=MeshEmitter Name=ShockwaveFront
         StaticMesh=StaticMesh'DEKStaticsMaster207P.fX.SolarWave'
         UseParticleColor=True
         FadeOut=True
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
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRange=(X=(Min=3000.000000,Max=3000.000000))
     End Object
     Emitters(1)=MeshEmitter'DEKRPG208.DEKSolarTurretEnergyWaveTrailer.ShockwaveFront'

     AutoDestroy=True
     bNoDelete=False
     LifeSpan=1.000000
     PrePivot=(X=220.000000)
     AmbientGlow=254
}
