class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG208.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG208.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
