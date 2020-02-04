class UpgradeRocketLauncher extends RocketLauncher
    config(DEKWeapons);
	
simulated function bool CanThrow()
{
	return false;
	Super.CanThrow();
}

defaultproperties
{
	 bCanThrow=False
     SeekRange=13000.000000
     LockRequiredTime=0.300000
     FireModeClass(1)=Class'DEKWeapons208.UpgradeRocketMultiFire'
     PickupClass=Class'DEKWeapons208.UpgradeRocketLauncherPickup'
}
