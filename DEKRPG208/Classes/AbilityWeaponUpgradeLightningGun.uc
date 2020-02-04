class AbilityWeaponUpgradeLightningGun extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local WeaponFire FireMode[2];
		
	FireMode[0] = Weapon.GetFireMode(0);
	FireMode[1] = Weapon.GetFireMode(1);
		
	if (SniperFire(FireMode[0]) != None)
	{
		SniperFire(FireMode[0]).NumArcs=8;
		SniperFire(FireMode[0]).SecDamageMult=0.800000;
		SniperFire(FireMode[0]).SecTraceDist=2000.000000;
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=20
     AbilityName="Upgrade: Lightning Gun"
     Description="Upgrades your Lightning Gun.||The lightning arcs branch out at a larger distance which can strike nearby targets.||You must be level 20 before purchasing this ability.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=1
}
