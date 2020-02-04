class AbilityWeaponUpgradeRocketLauncher extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local Weapon W;
	if (Weapon == None || Weapon.Owner == None || Pawn(Weapon.Owner) == None || Pawn(Weapon.Owner).PlayerReplicationInfo == None || PlayerController(Pawn(Weapon.Owner).Controller) == None)
		return;
	if (Weapon.Role != ROLE_Authority)
		return;
		
	if (RPGWeapon(Weapon) != None)
		W = RPGWeapon(Weapon).ModifiedWeapon;
	else
		W = Weapon;
		
	if (RocketLauncher(W) != None)
	{
		RocketLauncher(W).SeekRange = 13000.0000;
		RocketLauncher(W).LockRequiredTime = 0.10000;
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=80
     AbilityName="Upgrade: Rocket Launcher"
     Description="Grants and upgrades your Rocket Launcher.||The lock-on time is decreased for seeking rockets.||You must be level 80 before purchasing this ability.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=1
}
