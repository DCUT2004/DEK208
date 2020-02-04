class UpgradeAssaultRifle extends AssaultRifle
    config(DEKWeapons);
	
simulated function bool CanThrow()
{
	return false;
	Super.CanThrow();
}

defaultproperties
{
     FireModeClass(0)=Class'DEKWeapons208.UpgradeAssaultFire'
     FireModeClass(1)=Class'DEKWeapons208.UpgradeAssaultGrenade'
     PickupClass=Class'DEKWeapons208.UpgradeAssaultRiflePickup'
}
