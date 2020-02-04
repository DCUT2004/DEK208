class PossessEffect extends Emitter;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	//force default rotation
	SetRotation(default.Rotation);
}

simulated function PostNetReceive()
{
	if (Base != None)
	{
		Initialize();
	}
}

simulated function Initialize()
{
	local float Modifier, Height;

	Modifier = Base.CollisionRadius / CollisionRadius;
	Height = -Base.CollisionHeight * 1.25;
	Emitters[0].StartLocationOffset.Y = Height;
	Emitters[0].StartLocationPolarRange.Z.Max = default.Emitters[1].StartLocationPolarRange.Z.Max * Modifier;
	Emitters[0].StartLocationPolarRange.Z.Min = default.Emitters[1].StartLocationPolarRange.Z.Min * Modifier;
	Emitters[0].Disabled = false;
	Emitters[0].ColorScale[0].Color.R = 255;
}

function Reset();

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         Disabled=True
         Backup_Disabled=True
         UniformMeshScale=False
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=64,G=64,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(A=255))
         FadeOutStartTime=1.005000
         CoordinateSystem=PTCS_Relative
         MaxParticles=25
         StartLocationRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000))
         StartLocationShape=PTLS_Polar
         StartLocationPolarRange=(Y=(Max=65536.000000),Z=(Min=12.000000,Max=12.000000))
         RevolutionsPerSecondRange=(Z=(Min=0.200000,Max=0.200000))
         UseRotationFrom=PTRS_Offset
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=200.000000
         Texture=Texture'EpicParticles.Flares.Sharpstreaks2'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.500000,Max=1.750000)
         StartVelocityRange=(Y=(Min=25.000000,Max=25.000000))
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG208.PossessEffect.SpriteEmitter1'

     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
     Rotation=(Roll=16384)
     bHardAttach=True
     CollisionRadius=25.000000
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
     bNetNotify=True
}
