class UpgradeMinigun extends Minigun
    config(DEKWeapons);

simulated function bool StartFire(int mode)
{
    local bool bStart;

	if ( !UpgradeMinigunFire(FireMode[0]).IsIdle() || !UpgradeMinigunFire(FireMode[1]).IsIdle() )
		return false;

    bStart = Super.StartFire(mode);
    if (bStart)
        FireMode[mode].StartFiring();

    return bStart;
}

defaultproperties
{
	 //bCanThrow=False
     FireModeClass(0)=Class'DEKWeapons208.UpgradeMinigunFire'
     FireModeClass(1)=Class'DEKWeapons208.UpgradeMinigunAltFire'
     //PickupClass=Class'DEKWeapons208.UpgradeMinigunPickup'
}
