class AbilityWeaponUpgradeINAVRiL extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local WeaponFire FireMode[2];
		
	FireMode[0] = Weapon.GetFireMode(0);
	FireMode[1] = Weapon.GetFireMode(1);
		
	if (INAVRiLFire(FireMode[0]) != None)
	{
		INAVRiLFire(FireMode[0]).ProjectileClass=class'DEKWeapons208.UpgradeINAVRiLRocket';
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=50
     AbilityName="Upgrade: AVRiL"
     Description="Upgrades your Invasion AVRiL.||The AVRiL has a larger damage radius.||You must be level 50 before purchasing this ability.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=1
}
