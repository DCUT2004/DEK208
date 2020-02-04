class AbilityWeaponUpgradeLinkGun extends CostRPGAbility
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
	
	if (LinkAltFire(FireMode[0]) != None && RPGLinkGun(W) != None)
	{
		LinkAltFire(FireMode[0]).AmmoPerFire=1;
	}
	if (RPGLinkFire(FireMode[1]) != None && RPGLinkGun(W) != None)
	{
		RPGLinkFire(FireMode[1]).LinkBreakDelay=7.000;
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=30
     AbilityName="Upgrade: Link Gun"
     Description="Upgrades your Link Gun.||Aammo consumption is reduced to one on the primary fire.||You must be level 30 before purchasing this ability.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=1
}
