class UpgradeFlakCannon extends FlakCannon
    config(DEKWeapons);
	
simulated function bool CanThrow()
{
	return false;
	Super.CanThrow();
}

defaultproperties
{
     FireModeClass(0)=Class'DEKWeapons208.UpgradeFlakFire'
     FireModeClass(1)=Class'DEKWeapons208.UpgradeFlakAltFire'
     PickupClass=Class'DEKWeapons208.UpgradeFlakCannonPickup'
}
