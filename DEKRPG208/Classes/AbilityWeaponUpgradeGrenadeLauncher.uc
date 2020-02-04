class AbilityWeaponUpgradeGrenadeLauncher extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local WeaponFire FireMode[2];
		
	FireMode[0] = Weapon.GetFireMode(0);
	FireMode[1] = Weapon.GetFireMode(1);
		
	if (ONSGrenadeFire(FireMode[0]) != None)
	{
		ONSGrenadeFire(FireMode[0]).ProjectileClass=class'DEKWeapons208.UpgradeGrenadeProjectile';
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=50
     AbilityName="Upgrade: Grenade Launcher"
     Description="Upgrades your Grenade Launcher.||The grenades explode into flak chunks.||You must be level 50 before purchasing this ability.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=1
}
