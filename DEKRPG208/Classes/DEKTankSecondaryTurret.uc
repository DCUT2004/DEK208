class DEKTankSecondaryTurret extends ONSWeapon;


//     PitchUpLimit=12500      PitchDownLimit=59500      WeaponFireOffset=85.000000

defaultproperties
{
     YawBone="Object01"
     PitchBone="Object02"
     PitchUpLimit=19000
     PitchDownLimit=62500
     WeaponFireAttachmentBone="Object02"
     WeaponFireOffset=85.000000
     DualFireOffset=5.000000
     RotationsPerSecond=0.180000
     RedSkin=Shader'VMVehicles-TX.HoverTankGroup.HoverTankChassisFinalRED'
     BlueSkin=Shader'VMVehicles-TX.HoverTankGroup.HoverTankChassisFinalBLUE'
     FireInterval=3.000000
     EffectEmitterClass=Class'OnslaughtBP.ONSShockTankMuzzleFlash'
     FireSoundClass=Sound'ONSBPSounds.ShockTank.ShockBallFire'
     DamageType=Class'DEKRPG208.DamTypeDEKTankAltFire'
     DamageMin=150
     DamageMax=150
     ProjectileClass=Class'OnslaughtBP.ONSShockTankProjectile'
     AltFireProjectileClass=Class'OnslaughtBP.ONSShockTankProjectile'
     AIInfo(0)=(bTrySplash=True,bLeadTarget=True,WarnTargetPct=0.750000,RefireRate=0.800000)
     AIInfo(1)=(bTrySplash=True,bLeadTarget=True,WarnTargetPct=0.750000,RefireRate=0.800000)
     CullDistance=8000.000000
     Mesh=SkeletalMesh'ONSWeapons-A.TankMachineGun'
}
