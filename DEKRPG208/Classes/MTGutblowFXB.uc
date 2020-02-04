// ====================================================================
//  class:  MTGutblowFXB
//
//  new extra chunky gutblow effect
//
//  Written by Alex Dobie
//  (c) 2004, Free Monkey Interactive.  All Rights Reserved
// ====================================================================
class MTGutblowFXB extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter10
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-250.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.800000
         CoordinateSystem=PTCS_Relative
         MaxParticles=4
         StartLocationRange=(X=(Min=-75.000000,Max=-75.000000),Y=(Min=-110.000000,Max=-110.000000),Z=(Min=-50.000000,Max=-50.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=0.250000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=15.000000,Max=40.000000),Y=(Min=15.000000,Max=40.000000),Z=(Min=15.000000,Max=40.000000))
         InitialParticlesPerSecond=60.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XGameShadersB.Blood.BloodJetc'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-300.000000,Max=-300.000000),Y=(Min=-150.000000,Max=-150.000000),Z=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG208.MTGutblowFXB.SpriteEmitter10'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter12
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-250.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
         Opacity=0.170000
         CoordinateSystem=PTCS_Relative
         MaxParticles=4
         StartLocationRange=(X=(Min=-75.000000,Max=-75.000000),Y=(Min=-110.000000,Max=-110.000000),Z=(Min=-50.000000,Max=-50.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=0.250000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=15.000000,Max=40.000000),Y=(Min=15.000000,Max=40.000000),Z=(Min=15.000000,Max=40.000000))
         InitialParticlesPerSecond=60.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XEffects.GibOrganicRed'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-300.000000,Max=-300.000000),Y=(Min=-150.000000,Max=-150.000000),Z=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(1)=SpriteEmitter'DEKRPG208.MTGutblowFXB.SpriteEmitter12'

     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'XEffects.GibOrganicCalf'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-250.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.840000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=-75.000000,Max=-75.000000),Y=(Min=-110.000000,Max=-110.000000),Z=(Min=-70.000000,Max=-30.000000))
         SpinsPerSecondRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Max=0.250000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         LifetimeRange=(Min=1.000000,Max=3.000000)
         InitialDelayRange=(Max=1.500000)
         StartVelocityRange=(X=(Min=-300.000000,Max=-300.000000),Y=(Min=-150.000000,Max=-150.000000),Z=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(2)=MeshEmitter'DEKRPG208.MTGutblowFXB.MeshEmitter0'

     Begin Object Class=MeshEmitter Name=MeshEmitter1
         StaticMesh=StaticMesh'XEffects.GibOrganicForearm'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-250.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.840000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=-75.000000,Max=-75.000000),Y=(Min=-110.000000,Max=-110.000000),Z=(Min=-70.000000,Max=-30.000000))
         SpinsPerSecondRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Max=0.250000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         LifetimeRange=(Min=1.000000,Max=3.000000)
         InitialDelayRange=(Max=1.500000)
         StartVelocityRange=(X=(Min=-300.000000,Max=-300.000000),Y=(Min=-150.000000,Max=-150.000000),Z=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(3)=MeshEmitter'DEKRPG208.MTGutblowFXB.MeshEmitter1'

     Begin Object Class=MeshEmitter Name=MeshEmitter2
         StaticMesh=StaticMesh'XEffects.GibOrganicHand'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-250.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.840000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=-75.000000,Max=-75.000000),Y=(Min=-110.000000,Max=-110.000000),Z=(Min=-70.000000,Max=-30.000000))
         SpinsPerSecondRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Max=0.250000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         LifetimeRange=(Min=1.000000,Max=3.000000)
         InitialDelayRange=(Max=1.500000)
         StartVelocityRange=(X=(Min=-300.000000,Max=-300.000000),Y=(Min=-150.000000,Max=-150.000000),Z=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(4)=MeshEmitter'DEKRPG208.MTGutblowFXB.MeshEmitter2'

     Begin Object Class=MeshEmitter Name=MeshEmitter3
         StaticMesh=StaticMesh'XEffects.GibOrganicHead'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-250.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.840000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=-75.000000,Max=-75.000000),Y=(Min=-110.000000,Max=-110.000000),Z=(Min=-70.000000,Max=-30.000000))
         SpinsPerSecondRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Max=0.250000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         LifetimeRange=(Min=1.000000,Max=3.000000)
         InitialDelayRange=(Max=1.500000)
         StartVelocityRange=(X=(Min=-300.000000,Max=-300.000000),Y=(Min=-150.000000,Max=-150.000000),Z=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(5)=MeshEmitter'DEKRPG208.MTGutblowFXB.MeshEmitter3'

     Begin Object Class=MeshEmitter Name=MeshEmitter4
         StaticMesh=StaticMesh'XEffects.GibOrganicUpperarm'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-250.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.840000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=-75.000000,Max=-75.000000),Y=(Min=-110.000000,Max=-110.000000),Z=(Min=-70.000000,Max=-30.000000))
         SpinsPerSecondRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Max=0.250000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         LifetimeRange=(Min=1.000000,Max=3.000000)
         InitialDelayRange=(Max=1.500000)
         StartVelocityRange=(X=(Min=-300.000000,Max=-300.000000),Y=(Min=-150.000000,Max=-150.000000),Z=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(6)=MeshEmitter'DEKRPG208.MTGutblowFXB.MeshEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-250.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.800000
         CoordinateSystem=PTCS_Relative
         MaxParticles=4
         StartLocationRange=(X=(Min=-75.000000,Max=-75.000000),Y=(Min=110.000000,Max=110.000000),Z=(Min=-50.000000,Max=-50.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=0.250000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=15.000000,Max=40.000000),Y=(Min=15.000000,Max=40.000000),Z=(Min=15.000000,Max=40.000000))
         InitialParticlesPerSecond=60.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XGameShadersB.Blood.BloodJetc'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-300.000000,Max=-300.000000),Y=(Min=150.000000,Max=150.000000),Z=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(7)=SpriteEmitter'DEKRPG208.MTGutblowFXB.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-250.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
         Opacity=0.170000
         CoordinateSystem=PTCS_Relative
         MaxParticles=4
         StartLocationRange=(X=(Min=-75.000000,Max=-75.000000),Y=(Min=110.000000,Max=110.000000),Z=(Min=-50.000000,Max=-50.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=0.250000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=15.000000,Max=40.000000),Y=(Min=15.000000,Max=40.000000),Z=(Min=15.000000,Max=40.000000))
         InitialParticlesPerSecond=60.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XEffects.GibOrganicRed'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-300.000000,Max=-300.000000),Y=(Min=150.000000,Max=150.000000),Z=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(8)=SpriteEmitter'DEKRPG208.MTGutblowFXB.SpriteEmitter1'

     Begin Object Class=MeshEmitter Name=MeshEmitter5
         StaticMesh=StaticMesh'XEffects.GibOrganicCalf'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-250.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.840000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=-75.000000,Max=-75.000000),Y=(Min=110.000000,Max=110.000000),Z=(Min=-70.000000,Max=-30.000000))
         SpinsPerSecondRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Max=0.250000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         LifetimeRange=(Min=1.000000,Max=3.000000)
         InitialDelayRange=(Max=1.500000)
         StartVelocityRange=(X=(Min=-300.000000,Max=-300.000000),Y=(Min=150.000000,Max=150.000000),Z=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(9)=MeshEmitter'DEKRPG208.MTGutblowFXB.MeshEmitter5'

     Begin Object Class=MeshEmitter Name=MeshEmitter6
         StaticMesh=StaticMesh'XEffects.GibOrganicTorso'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-250.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.840000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=-75.000000,Max=-75.000000),Y=(Min=110.000000,Max=110.000000),Z=(Min=-70.000000,Max=-30.000000))
         SpinsPerSecondRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Max=0.250000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         LifetimeRange=(Min=1.000000,Max=3.000000)
         InitialDelayRange=(Max=1.500000)
         StartVelocityRange=(X=(Min=-300.000000,Max=-300.000000),Y=(Min=150.000000,Max=150.000000),Z=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(10)=MeshEmitter'DEKRPG208.MTGutblowFXB.MeshEmitter6'

     Begin Object Class=MeshEmitter Name=MeshEmitter7
         StaticMesh=StaticMesh'XEffects.GibOrganicTorso'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-250.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.840000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=-75.000000,Max=-75.000000),Y=(Min=110.000000,Max=110.000000),Z=(Min=-70.000000,Max=-30.000000))
         SpinsPerSecondRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Max=0.250000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         LifetimeRange=(Min=1.000000,Max=3.000000)
         InitialDelayRange=(Max=1.500000)
         StartVelocityRange=(X=(Min=-300.000000,Max=-300.000000),Y=(Min=150.000000,Max=150.000000),Z=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(11)=MeshEmitter'DEKRPG208.MTGutblowFXB.MeshEmitter7'

     Begin Object Class=MeshEmitter Name=MeshEmitter8
         StaticMesh=StaticMesh'XEffects.GibOrganicUpperarm'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-250.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.840000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=-75.000000,Max=-75.000000),Y=(Min=110.000000,Max=110.000000),Z=(Min=-70.000000,Max=-30.000000))
         SpinsPerSecondRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Max=0.250000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         LifetimeRange=(Min=1.000000,Max=3.000000)
         InitialDelayRange=(Max=1.500000)
         StartVelocityRange=(X=(Min=-300.000000,Max=-300.000000),Y=(Min=150.000000,Max=150.000000),Z=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(12)=MeshEmitter'DEKRPG208.MTGutblowFXB.MeshEmitter8'

     Begin Object Class=MeshEmitter Name=MeshEmitter9
         StaticMesh=StaticMesh'XEffects.GibOrganicForearm'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-250.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.840000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=-75.000000,Max=-75.000000),Y=(Min=110.000000,Max=110.000000),Z=(Min=-70.000000,Max=-30.000000))
         SpinsPerSecondRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Max=0.250000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         LifetimeRange=(Min=1.000000,Max=3.000000)
         InitialDelayRange=(Max=1.500000)
         StartVelocityRange=(X=(Min=-300.000000,Max=-300.000000),Y=(Min=150.000000,Max=150.000000),Z=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(13)=MeshEmitter'DEKRPG208.MTGutblowFXB.MeshEmitter9'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         RespawnDeadParticles=False
         UniformSize=True
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.000000
         MaxParticles=1
         Sounds(0)=(Sound=Sound'MTII.crysalis_goo_2',Radius=(Min=250.000000,Max=250.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=50.000000,Max=50.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_LinearGlobal
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(14)=SpriteEmitter'DEKRPG208.MTGutblowFXB.SpriteEmitter2'

     AutoDestroy=True
     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
     bDirectional=True
}
