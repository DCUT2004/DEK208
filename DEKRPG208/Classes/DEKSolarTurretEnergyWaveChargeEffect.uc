class DEKSolarTurretEnergyWaveChargeEffect extends Emitter;


#exec obj load file=..\StaticMeshes\ParticleMeshes.usx


var Material BlueSkin;
var rangevector BlueColorMultiplier;


simulated function PostNetBeginPlay()
{
	local int i;

	if (Instigator != None && Instigator.GetTeamnum() == 1) {
		Skins[0] = BlueSkin;
		for (i = 0; i < Emitters.Length; i++)
			Emitters[i].ColorMultiplierRange = BlueColorMultiplier;
	}
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     BlueColorMultiplier=(X=(Min=0.100000,Max=0.200000),Y=(Min=0.400000,Max=0.800000),Z=(Min=1.000000,Max=1.000000))
     Begin Object Class=BeamEmitter Name=BeamEmitter0
         BeamEndPoints(0)=(offset=(X=(Min=30.000000,Max=35.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000)))
         DetermineEndPointBy=PTEP_Offset
         RotatingSheets=3
         FadeOut=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Y=(Min=0.400000,Max=0.800000),Z=(Min=0.100000,Max=0.100000))
         Opacity=0.200000
         CoordinateSystem=PTCS_Relative
         StartLocationRange=(X=(Min=50.000000,Max=55.000000))
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=5.000000)
         StartSizeRange=(X=(Min=20.000000,Max=20.000000))
         InitialParticlesPerSecond=15.000000
         Texture=Texture'AW-2004Particles.Energy.BeamBolt1a'
         LifetimeRange=(Min=0.750000,Max=0.750000)
     End Object
     Emitters(0)=BeamEmitter'DEKRPG208.DEKSolarTurretEnergyWaveChargeEffect.BeamEmitter0'

     Begin Object Class=BeamEmitter Name=BeamEmitter1
         BeamEndPoints(0)=(offset=(X=(Min=50.000000,Max=55.000000),Y=(Min=20.000000,Max=24.000000),Z=(Min=30.000000,Max=34.000000)))
         DetermineEndPointBy=PTEP_Offset
         RotatingSheets=3
         FadeOut=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Y=(Min=0.400000,Max=0.800000),Z=(Min=0.100000,Max=0.100000))
         Opacity=0.200000
         CoordinateSystem=PTCS_Relative
         StartLocationRange=(X=(Min=30.000000,Max=30.000000),Y=(Min=-24.000000,Max=-20.000000),Z=(Min=-34.000000,Max=-30.000000))
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=5.000000)
         StartSizeRange=(X=(Min=20.000000,Max=20.000000))
         InitialParticlesPerSecond=15.000000
         Texture=Texture'AW-2004Particles.Energy.BeamBolt1a'
         LifetimeRange=(Min=0.750000,Max=0.750000)
     End Object
     Emitters(1)=BeamEmitter'DEKRPG208.DEKSolarTurretEnergyWaveChargeEffect.BeamEmitter1'

     Begin Object Class=BeamEmitter Name=BeamEmitter2
         BeamEndPoints(0)=(offset=(X=(Min=50.000000,Max=55.000000),Y=(Min=-24.000000,Max=-20.000000),Z=(Min=30.000000,Max=34.000000)))
         DetermineEndPointBy=PTEP_Offset
         RotatingSheets=3
         FadeOut=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Y=(Min=0.400000,Max=0.800000),Z=(Min=0.100000,Max=0.100000))
         Opacity=0.200000
         CoordinateSystem=PTCS_Relative
         StartLocationRange=(X=(Min=30.000000,Max=30.000000),Y=(Min=20.000000,Max=24.000000),Z=(Min=-34.000000,Max=-30.000000))
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=5.000000)
         StartSizeRange=(X=(Min=20.000000,Max=20.000000))
         InitialParticlesPerSecond=15.000000
         Texture=Texture'AW-2004Particles.Energy.BeamBolt1a'
         LifetimeRange=(Min=0.750000,Max=0.750000)
     End Object
     Emitters(2)=BeamEmitter'DEKRPG208.DEKSolarTurretEnergyWaveChargeEffect.BeamEmitter2'

     Begin Object Class=BeamEmitter Name=BeamEmitter3
         BeamEndPoints(0)=(offset=(X=(Min=50.000000,Max=55.000000),Y=(Min=20.000000,Max=24.000000),Z=(Min=-34.000000,Max=-30.000000)))
         DetermineEndPointBy=PTEP_Offset
         RotatingSheets=3
         FadeOut=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Y=(Min=0.400000,Max=0.800000),Z=(Min=0.100000,Max=0.100000))
         Opacity=0.200000
         CoordinateSystem=PTCS_Relative
         StartLocationRange=(X=(Min=30.000000,Max=30.000000),Y=(Min=-24.000000,Max=-20.000000),Z=(Min=30.000000,Max=34.000000))
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=5.000000)
         StartSizeRange=(X=(Min=20.000000,Max=20.000000))
         InitialParticlesPerSecond=15.000000
         Texture=Texture'AW-2004Particles.Energy.BeamBolt1a'
         LifetimeRange=(Min=0.750000,Max=0.750000)
     End Object
     Emitters(3)=BeamEmitter'DEKRPG208.DEKSolarTurretEnergyWaveChargeEffect.BeamEmitter3'

     Begin Object Class=BeamEmitter Name=BeamEmitter4
         BeamEndPoints(0)=(offset=(X=(Min=50.000000,Max=55.000000),Y=(Min=-24.000000,Max=-20.000000),Z=(Min=-34.000000,Max=-30.000000)))
         DetermineEndPointBy=PTEP_Offset
         RotatingSheets=3
         FadeOut=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Y=(Min=0.400000,Max=0.800000),Z=(Min=0.100000,Max=0.100000))
         Opacity=0.200000
         CoordinateSystem=PTCS_Relative
         StartLocationRange=(X=(Min=30.000000,Max=30.000000),Y=(Min=20.000000,Max=24.000000),Z=(Min=30.000000,Max=34.000000))
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=5.000000)
         StartSizeRange=(X=(Min=20.000000,Max=20.000000))
         InitialParticlesPerSecond=15.000000
         Texture=Texture'AW-2004Particles.Energy.BeamBolt1a'
         LifetimeRange=(Min=0.750000,Max=0.750000)
     End Object
     Emitters(4)=BeamEmitter'DEKRPG208.DEKSolarTurretEnergyWaveChargeEffect.BeamEmitter4'

     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'ParticleMeshes.Simple.ParticleSphere2'
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Y=(Min=0.400000,Max=0.800000),Z=(Min=0.100000,Max=0.100000))
         FadeInEndTime=0.300000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=70.000000,Max=70.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.200000)
         StartSizeRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.400000,Max=0.400000),Z=(Min=0.250000,Max=0.250000))
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(5)=MeshEmitter'DEKRPG208.DEKSolarTurretEnergyWaveChargeEffect.MeshEmitter0'

     bNoDelete=False
     bReplicateInstigator=True
     NetPriority=3.000000
     LifeSpan=2.000000
     AmbientGlow=254
     bNotOnDedServer=False
}
