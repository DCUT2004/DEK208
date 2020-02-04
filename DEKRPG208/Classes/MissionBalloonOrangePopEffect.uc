class MissionBalloonOrangePopEffect extends ONSPlasmaHitGreen;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter22
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(X=1.000000,Z=0.000000)
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         ColorScale(1)=(RelativeTime=0.250000,Color=(B=66,G=200,R=244))
         ColorScale(2)=(RelativeTime=0.500000,Color=(B=66,G=200,R=244))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=1
         StartLocationOffset=(X=-2.000000)
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=60.000000,Max=120.000000))
         InitialParticlesPerSecond=25.000000
         Texture=Texture'AW-2004Particles.Weapons.SmokePanels1'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG208.MissionBalloonOrangePopEffect.SpriteEmitter22'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter23
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(X=1.000000,Z=0.000000)
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=66,G=200,R=244))
         ColorScale(1)=(RelativeTime=0.800000,Color=(B=66,G=200,R=244))
         ColorScale(2)=(RelativeTime=1.000000)
         Opacity=0.800000
         MaxParticles=1
         StartLocationOffset=(X=-2.000000)
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=200.000000,Max=250.000000))
         InitialParticlesPerSecond=25.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(1)=SpriteEmitter'DEKRPG208.MissionBalloonOrangePopEffect.SpriteEmitter23'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter53
         UseDirectionAs=PTDU_Scale
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=66,G=200,R=244))
         ColorScale(1)=(RelativeTime=0.700000,Color=(B=66,G=200,R=244))
         ColorScale(2)=(RelativeTime=1.000000)
         MaxParticles=1
         StartLocationOffset=(X=-4.000000)
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=50.000000,Max=50.000000))
         InitialParticlesPerSecond=250.000000
         Texture=Texture'EpicParticles.Flares.FlashFlare1'
         LifetimeRange=(Min=0.300000,Max=0.300000)
     End Object
     Emitters(2)=SpriteEmitter'DEKRPG208.MissionBalloonOrangePopEffect.SpriteEmitter53'
}
