class AbilityWeaponUpgradeBioRifle extends CostRPGAbility
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
		
	if (BioFire(FireMode[0]) != None && BioRifle(W) != None)
	{
		BioFire(FireMode[0]).ProjectileClass=class'DEKWeapons208.UpgradeBioGlob';
	}
	if (BioChargedFire(FireMode[1]) != None && BioRifle(W) != None)
	{
		BioChargedFire(FireMode[1]).MaxGoopLoad=15;
		BioChargedFire(FireMode[1]).ProjectileClass=class'DEKWeapons208.UpgradeBioGlob';
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=30
     AbilityName="Upgrade: Bio Rifle"
     Description="Upgrades your Bio Rifle.||Bio globs remain active longer, and globlings can group together in bigger loads.||You must be level 30 before purchasing this ability.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=1
}
