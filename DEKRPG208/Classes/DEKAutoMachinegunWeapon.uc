class DEKAutoMachinegunWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG208.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG208.DEKMachineGunAttachment'
     ItemName="Auto Assault Sentinel"
}
