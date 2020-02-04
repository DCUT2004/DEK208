class AbilityEnhancedAmmo extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float AmmoMultiplier;

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local Inventory Inv;
	local Ammunition Ammo;
	local int Count;
	local float Modifier;
	local RPGStatsInv StatsInv;
	local int AmmoMax;
	
	if (Weapon == None)
		return;
		
	AmmoMax = 0;
	
	if (Pawn(Weapon.Owner) != None)
	{
		StatsInv = RPGStatsInv(Pawn(Weapon.Owner).FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None)
			AmmoMax =  StatsInv.Data.AmmoMax;
	}

	Modifier = 1.0 + AmmoMax * 0.01;	// first add on his weaponspeed stats
	Modifier *= 1.f + (default.AmmoMultiplier * AbilityLevel);	// now add the speed due to this ability
	if (Modifier < 0.1)
		Modifier = 0.1;
	for (Inv = Pawn(Weapon.Owner).Inventory; Inv != None; Inv = Inv.Inventory)
	{
		Ammo = Ammunition(Inv);
		if (Ammo != None)
		{
			Ammo.MaxAmmo = Ammo.default.MaxAmmo * Modifier;
			if (Ammo.AmmoAmount > Ammo.MaxAmmo)
				Ammo.AmmoAmount = Ammo.MaxAmmo;
			if (!class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Ammo.Class))
			{
				Ammo.InitialAmount = Ammo.default.InitialAmount * Modifier;
			}
		}
		Count++;
		if (Count > 1000)
			break;
	}
}

defaultproperties
{
     AmmoMultiplier=0.030000
     MinPlayerLevel=75
     PlayerLevelStep=1
     AbilityName="Advanced Ammo Bonus"
     Description="Increases your cumulative total damage bonus by 3% per level. |Cost (per level): 5. You must be level 75 to purchase the first level of this ability, level 76 to purchase the second level, and so on."
     StartingCost=5
     MaxLevel=20
}
