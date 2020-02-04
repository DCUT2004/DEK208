class NecroAdrenWraithBlackHoleEffect extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=GlowingCorona
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         Opacity=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=0.500000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=75.000000,Max=75.000000))
         InitialParticlesPerSecond=10.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'AW-2k4XP.Weapons.ShockTankEffectCore2a'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(0)=SpriteEmitter'DEKMonsters208.NecroAdrenWraithBlackHoleEffect.GlowingCorona'

     Begin Object Class=SpriteEmitter Name=BlackHole
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=1.000000,Max=2.000000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=30.000000,Max=30.000000))
         InitialParticlesPerSecond=10.000000
         DrawStyle=PTDS_Darken
         Texture=Texture'AW-2004Particles.Weapons.PlasmaFlare'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(1)=SpriteEmitter'DEKMonsters208.NecroAdrenWraithBlackHoleEffect.BlackHole'

     Begin Object Class=SpriteEmitter Name=Flashes
         FadeOut=True
         SpinParticles=True
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.000000),Y=(Min=0.500000),Z=(Min=0.800000))
         Opacity=0.500000
         CoordinateSystem=PTCS_Relative
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=60.000000,Max=75.000000))
         Texture=Texture'AW-2004Particles.Energy.ElecPanels'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.200000,Max=0.300000)
     End Object
     Emitters(2)=SpriteEmitter'DEKMonsters208.NecroAdrenWraithBlackHoleEffect.Flashes'

     Begin Object Class=SpriteEmitter Name=SuckingStreaks
         UseDirectionAs=PTDU_RightAndNormal
         FadeOut=True
         FadeIn=True
         UniformSize=True
         Opacity=0.250000
         FadeOutStartTime=0.200000
         FadeInEndTime=0.200000
         CoordinateSystem=PTCS_Relative
         MaxParticles=20
         DetailMode=DM_High
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=110.000000,Max=120.000000)
         StartSizeRange=(X=(Min=24.000000,Max=30.000000))
         Texture=Texture'EpicParticles.Beams.WhiteStreak01aw'
         LifetimeRange=(Min=0.400000,Max=0.400000)
         StartVelocityRadialRange=(Min=-300.000000,Max=-300.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(3)=SpriteEmitter'DEKMonsters208.NecroAdrenWraithBlackHoleEffect.SuckingStreaks'

     bNoDelete=False
}
