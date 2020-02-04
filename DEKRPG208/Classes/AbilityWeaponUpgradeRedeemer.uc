class AbilityWeaponUpgradeRedeemer extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local WeaponFire FireMode[2];
		
	FireMode[0] = Weapon.GetFireMode(0);
	FireMode[1] = Weapon.GetFireMode(1);
		
	if (RedeemerFire(FireMode[0]) != None)
	{
		RedeemerFire(FireMode[0]).ProjectileClass=class'DEKWeapons208.UpgradeRedeemerProj';
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=60
     AbilityName="Upgrade: Redeemer"
     Description="Upgrades your Redeemer.||Redeemer missiles can not be shot down.||You must be level 60 before purchasing this ability.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=1
}
