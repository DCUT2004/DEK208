class DEKRailGunChargeEffect extends Emitter;

simulated function PostNetBeginPlay()
{
	local xWeaponAttachment Attachment;
	local vector X,Y,Z;
	
    if ( (xPawn(Instigator) != None) && !Instigator.IsFirstPerson() )
    {	
        Attachment = xPawn(Instigator).WeaponAttachment;
        if ( (Attachment != None) && (Level.TimeSeconds - Attachment.LastRenderTime < 0.1) )
        {
			GetAxes(Attachment.Rotation,X,Y,Z);
            SetLocation(Attachment.Location -1*X -1*Z);
			SetRotation(Attachment.Rotation);
        }
    }
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter47
         UseDirectionAs=PTDU_Scale
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=64,G=32))
         ColorScale(1)=(Color=(B=255,G=96,R=96))
         ColorScale(2)=(RelativeTime=0.800000,Color=(B=255,G=96,R=96))
         ColorScale(3)=(RelativeTime=1.000000,Color=(B=64,G=32))
         ColorMultiplierRange=(X=(Min=0.750000,Max=0.750000),Y=(Min=0.750000,Max=0.750000),Z=(Min=0.750000,Max=0.750000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=35.000000,Max=35.000000))
         InitialParticlesPerSecond=8000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar2'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=2.000000
     End Object
     Emitters(0)=SpriteEmitter'DEKWeapons208.DEKRailGunChargeEffect.SpriteEmitter47'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter48
         UseColorScale=True
         SpinParticles=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=192,G=96,R=96))
         ColorScale(1)=(RelativeTime=0.700000,Color=(B=192,G=96,R=96))
         ColorScale(2)=(RelativeTime=0.800000)
         ColorScale(3)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=20
         SpinsPerSecondRange=(X=(Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.200000)
         StartSizeRange=(X=(Min=10.000000,Max=15.000000))
         Texture=Texture'AW-2004Particles.Weapons.PlasmaFlare'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.500000,Max=0.500000)
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=2.000000
     End Object
     Emitters(1)=SpriteEmitter'DEKWeapons208.DEKRailGunChargeEffect.SpriteEmitter48'

     bNoDelete=False
}
