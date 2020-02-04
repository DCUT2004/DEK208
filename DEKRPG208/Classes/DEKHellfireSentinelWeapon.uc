class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG208.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG208.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
