class AbilityWeaponUpgradeMinigun extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local WeaponFire FireMode[2];
	local Weapon W;
	
	if (Weapon == None || Weapon.Owner == None || Pawn(Weapon.Owner) == None || Pawn(Weapon.Owner).PlayerReplicationInfo == None || PlayerController(Pawn(Weapon.Owner).Controller) == None)
		return;
	if (Weapon.Role != ROLE_Authority)
		return;
		
	if (RPGWeapon(Weapon) != None)
		W = RPGWeapon(Weapon).ModifiedWeapon;
	else
		W = Weapon;
		
	FireMode[0] = Weapon.GetFireMode(0);
	FireMode[1] = Weapon.GetFireMode(1);
		
	if (MinigunFire(FireMode[0]) != None && Minigun(W) != None)
	{
		MinigunFire(FireMode[0]).WindupTime=0.010000;
		MinigunFire(FireMode[0]).PrefireTime=0.010000;
		MinigunFire(FireMode[0]).ShakeRotTime=0.000000;
		MinigunFire(FireMode[0]).ShakeOffsetTime=0.000000;
		MinigunFire(FireMode[0]).Spread=0.010000;
	}
	if (MinigunAltFire(FireMode[1]) != None && Minigun(W) != None)
	{
		MinigunAltFire(FireMode[1]).WindupTime=0.0100000;
		MinigunAltFire(FireMode[1]).PrefireTime=0.010000;
		MinigunAltFire(FireMode[1]).Spread=0.009000;
		MinigunAltFire(FireMode[0]).ShakeRotTime=0.000000;
		MinigunAltFire(FireMode[0]).ShakeOffsetTime=0.000000;
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=60
     AbilityName="Upgrade: Minigun"
     Description="Upgrades your Minigun.||Recoil and wind up time are eliminated. Additionally, the spread is reduced for the alt-fire.||You must be level 60 before purchasing this ability.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=1
}
