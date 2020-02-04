class EngineerLinkGun extends RPGLinkGun
	HideDropDown
	CacheExempt;

var config float HealTimeDelay;		// when linking to turrets how long after healing before get damage boost

defaultproperties
{
     HealTimeDelay=0.500000
     FireModeClass(0)=Class'DEKRPG208.EngineerLinkProjFire'
     FireModeClass(1)=Class'DEKRPG208.EngineerLinkFire'
}
