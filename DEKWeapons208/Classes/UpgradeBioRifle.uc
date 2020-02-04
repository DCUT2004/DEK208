class UpgradeBioRifle extends BioRifle
    config(DEKWeapons);
	
simulated function bool CanThrow()
{
	return false;
	Super.CanThrow();
}

defaultproperties
{
     FireModeClass(0)=Class'DEKWeapons208.UpgradeBioFire'
     FireModeClass(1)=Class'DEKWeapons208.UpgradeBioChargedFire'
     PickupClass=Class'DEKWeapons208.UpgradeBioRiflePickup'
}
