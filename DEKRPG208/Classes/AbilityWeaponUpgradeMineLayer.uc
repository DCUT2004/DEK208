class AbilityWeaponUpgradeMineLayer extends CostRPGAbility
	config(UT2004RPG) 
	abstract;
	
var config int L1MaxMines,L2MaxMines,L3MaxMines,L4MaxMines,L5MaxMines,L6MaxMines,L7MaxMines,L8MaxMines,L9MaxMines,L10MaxMines;

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
		
	if (DEKMineLayer(W) != None)
		if (AbilityLevel == 1)
			DEKMineLayer(W).MaxMines = default.L1MaxMines; //default is 3 for DC Server
		else if (AbilityLevel == 2)
			DEKMineLayer(W).MaxMines = default.L2MaxMines; //default is 3 for DC Server
		else if (AbilityLevel == 3)
			DEKMineLayer(W).MaxMines = default.L3MaxMines; //default is 3 for DC Server
		else if (AbilityLevel == 4)
			DEKMineLayer(W).MaxMines = default.L4MaxMines; //default is 3 for DC Server
		else if (AbilityLevel == 5)
			DEKMineLayer(W).MaxMines = default.L5MaxMines; //default is 3 for DC Server
		else if (AbilityLevel == 6)
			DEKMineLayer(W).MaxMines = default.L6MaxMines; //default is 3 for DC Server
		else if (AbilityLevel == 7)
			DEKMineLayer(W).MaxMines = default.L7MaxMines; //default is 3 for DC Server
		else if (AbilityLevel == 8)
			DEKMineLayer(W).MaxMines = default.L8MaxMines; //default is 3 for DC Server
		else if (AbilityLevel == 9)
			DEKMineLayer(W).MaxMines = default.L9MaxMines; //default is 3 for DC Server
		else if (AbilityLevel == 10)
			DEKMineLayer(W).MaxMines = default.L10MaxMines; //default is 3 for DC Server
}

defaultproperties
{
     L1MaxMines=4
     L2MaxMines=5
     L3MaxMines=6
     L4MaxMines=7
     L5MaxMines=8
     L6MaxMines=9
     L7MaxMines=10
     L8MaxMines=11
     L9MaxMines=12
     L10MaxMines=13
     PlayerLevelReqd(1)=40
     AbilityName="Upgrade: Mine Layer"
     Description="Upgrades your Mine Layer.|| Adds an additional deployable spider mine by one per level.||You must be level 40 before purchasing this ability.|Cost (per level): 5."
     StartingCost=5
     MaxLevel=10
}
