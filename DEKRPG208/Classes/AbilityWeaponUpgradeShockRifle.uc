class AbilityWeaponUpgradeShockRifle extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local WeaponFire FireMode[2];
		
	FireMode[0] = Weapon.GetFireMode(0);
	FireMode[1] = Weapon.GetFireMode(1);
		
	if (ShockProjFire(FireMode[1]) != None)
	{
		ShockProjFire(FireMode[1]).ProjectileClass=Class'DEKWeapons208.UpgradeShockProjectile';
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=90
     AbilityName="Upgrade: Shock Rifle"
     Description="Upgrades your Shock Rifle.||The shock combo produces a black hole for a small moment before exploding.||You must be level 90 before purchasing this ability.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=1
}
