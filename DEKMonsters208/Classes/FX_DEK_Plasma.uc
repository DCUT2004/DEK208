//=============================================================================
// FX_LinkTurret_GreenPlasma
//=============================================================================
// Created by Laurent Delayen
// © 2003, Epic Games, Inc.  All Rights Reserved
//=============================================================================

class FX_DEK_Plasma extends Emitter
	notplaceable;

simulated function PostBeginPlay()
{
	SetGreenColor();

	super.PostBeginPlay();
}

simulated function SetGreenColor()
{
	Emitters[0].ColorScale[0].Color = class'Canvas'.static.MakeColor( 200, 10, 200);
	Emitters[0].ColorScale[1].Color = class'Canvas'.static.MakeColor( 200, 10, 200);

	Emitters[1].ColorScale[0].Color = class'Canvas'.static.MakeColor(168, 10, 166);
	Emitters[1].ColorScale[1].Color = class'Canvas'.static.MakeColor( 154, 10, 148);

	Emitters[2].ColorScale[0].Color = class'Canvas'.static.MakeColor( 164, 10, 148);
	Emitters[2].ColorScale[1].Color = class'Canvas'.static.MakeColor( 164, 10, 148);
}

simulated function SetYellowColor()
{
	Emitters[0].ColorScale[0].Color = class'Canvas'.static.MakeColor( 190, 12, 164);
	Emitters[0].ColorScale[1].Color = class'Canvas'.static.MakeColor( 190, 12, 164);

	Emitters[1].ColorScale[0].Color = class'Canvas'.static.MakeColor( 190, 12, 194);
	Emitters[1].ColorScale[1].Color = class'Canvas'.static.MakeColor( 196, 28, 192);

	Emitters[2].ColorScale[0].Color = class'Canvas'.static.MakeColor( 196, 14, 198);
	Emitters[2].ColorScale[1].Color = class'Canvas'.static.MakeColor( 196, 14, 188);
}

simulated function SetSize( float Scale )
{
	Emitters[0].StartSizeRange.X.Min = 80 * Scale;
	Emitters[0].StartSizeRange.X.Max = 96 * Scale;

	Emitters[1].LifetimeRange.Min = 1.7 * Scale;
	Emitters[1].LifetimeRange.Max = Emitters[1].LifetimeRange.Min;
	Emitters[1].StartSizeRange.X.Min = 12 * Scale;
	Emitters[1].StartSizeRange.X.Max = 28 * Scale;

	Emitters[2].StartSizeRange.X.Min = 1.5 * Scale;
	Emitters[2].StartSizeRange.X.Max = Emitters[2].StartSizeRange.X.Min;
	Emitters[2].StartSizeRange.Y.Min = 3.0 * Scale;
	Emitters[2].StartSizeRange.Y.Max = Emitters[2].StartSizeRange.Y.Min;
	Emitters[2].StartSizeRange.Z.Min = Emitters[2].StartSizeRange.Y.Min;
	Emitters[2].StartSizeRange.Z.Max = Emitters[2].StartSizeRange.Y.Min;
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         SpinParticles=True
         UniformSize=True
         ColorScale(0)=(Color=(B=255,G=28,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=28,A=255))
         Opacity=0.660000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartLocationOffset=(X=240.000000)
         SpinCCWorCW=(Y=0.000000,Z=0.000000)
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=80.000000,Max=96.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'EpicParticles.Flares.SoftFlare'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.080000,Max=0.160000)
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=5.000000
     End Object
     Emitters(0)=SpriteEmitter'DEKMonsters208.FX_DEK_Plasma.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseColorScale=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=96,G=12,R=96))
         ColorScale(1)=(RelativeTime=0.660000,Color=(B=96,G=14,R=96))
         ColorScale(2)=(RelativeTime=1.000000)
         Opacity=0.660000
         FadeOutStartTime=2.000000
         FadeInEndTime=0.080000
         CoordinateSystem=PTCS_Relative
         DetailMode=DM_High
         StartLocationOffset=(X=250.000000)
         SpinsPerSecondRange=(X=(Min=0.250000,Max=0.330000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=0.100000,RelativeSize=1.200000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.330000)
         StartSizeRange=(X=(Min=12.000000,Max=28.000000))
         DrawStyle=PTDS_Brighten
         Texture=Texture'EpicParticles.Smoke.StellarFog1aw'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.700000,Max=1.700000)
         StartVelocityRange=(X=(Min=-200.000000,Max=-200.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=5.000000
     End Object
     Emitters(1)=SpriteEmitter'DEKMonsters208.FX_DEK_Plasma.SpriteEmitter3'

     Begin Object Class=MeshEmitter Name=MeshEmitter1
         StaticMesh=StaticMesh'AS_Weapons_SM.Projectiles.Skaarj_Energy'
         UseMeshBlendMode=False
         RenderTwoSided=True
         UseColorScale=True
         SpinParticles=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=64,G=14,R=64))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=64,G=14,R=64))
         Opacity=0.660000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationOffset=(X=257.000000,Y=-10.000000)
         StartLocationRange=(Y=(Min=10.000000,Max=10.000000))
         SpinCCWorCW=(X=1.000000,Y=1.000000,Z=1.000000)
         SpinsPerSecondRange=(Z=(Min=1.100000,Max=1.100000))
         StartSizeRange=(X=(Min=1.500000,Max=1.500000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
         InitialParticlesPerSecond=1.000000
         SecondsBeforeInactive=0.000000
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(2)=MeshEmitter'DEKMonsters208.FX_DEK_Plasma.MeshEmitter1'

     bNoDelete=False
     bHardAttach=True
     bDirectional=True
}
