class DEKAutoMercuryWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208.DEKAutoMercuryFire'
     FireModeClass(1)=Class'DEKRPG208.DEKAutoMercuryFire'
     AttachmentClass=None
     ItemName="Auto Mercury"
}
