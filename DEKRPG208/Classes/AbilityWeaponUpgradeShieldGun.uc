class AbilityWeaponUpgradeShieldGun extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local WeaponFire FireMode[2];
		
	FireMode[0] = Weapon.GetFireMode(0);
	FireMode[1] = Weapon.GetFireMode(1);
		
	if (ShieldFire(FireMode[0]) != None)
	{
		ShieldFire(FireMode[0]).SelfDamageScale=0.00;
		ShieldFire(FireMode[0]).SelfForceScale=3.000000;
		ShieldFire(FireMode[0]).MaxDamage=500.000000;
	}
	if (ShieldAltFire(FireMode[1]) != None)
	{
		ShieldAltFire(FireMode[0]).AmmoPerFire=5;
		ShieldAltFire(FireMode[0]).AmmoRegenTime=0.100000;
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=20
     AbilityName="Upgrade: Shield Gun"
     Description="Upgrades your Shield Gun(which should be purchased as a separate starting weapon).||Shield recharges at a faster rate, and the melee distance is increased. You can also boost yourself up in the air.||You must be level 20 before purchasing this ability.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=1
}
