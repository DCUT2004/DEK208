class AbilityWeaponUpgradeFlakCannon extends CostRPGAbility
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
		
	if (FlakFire(FireMode[0]) != None && FlakCannon(W) != None)
	{
		FlakFire(FireMode[0]).ProjPerFire=7;
		FlakFire(FireMode[0]).ProjectileClass=class'DEKWeapons208.UpgradeFlakChunk';
	}
	if (FlakAltFire(FireMode[1]) != None && FlakCannon(W) != None)
	{
		FlakAltFire(FireMode[1]).ProjectileClass=class'DEKWeapons208.UpgradeFlakShell';
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=70
     AbilityName="Upgrade: Flak Cannon"
     Description="Upgrades your Flak Cannon.||Flak shards bounce off surfaces more frequently, and the flak shell spawns more flak shards.||You must be level 70 before purchasing this ability.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=1
}
