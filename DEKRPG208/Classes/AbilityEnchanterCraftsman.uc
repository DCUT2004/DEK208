class AbilityEnchanterCraftsman extends CostRPGAbility
	config(UT2004RPG);
	
var config int AdrenReductionPerLevel;
var config float MaxModifierMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local AdrenReducerInv Inv;
	
	Inv = AdrenReducerInv(Other.FindInventoryType(class'AdrenReducerInv'));
	if (Inv == None)
	{
		Inv = Other.spawn(class'AdrenReducerInv');		
		Inv.AbilityLevel = AbilityLevel;
		Inv.AdrenReductionPerLevel = default.AdrenReductionPerLevel;
		Inv.giveTo(Other);
	}
}

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local RPGWeapon W;
	
	if (Weapon != None && Weapon.IsA('RPGWeapon'))
		W = RPGWeapon(Weapon);
		
	if (W != None)
	{
		if (W.MaxModifier < W.default.MaxModifier*default.MaxModifierMultiplier)
		{
			W.MaxModifier *= default.MaxModifierMultiplier;
		}
	}
}

defaultproperties
{
	 MaxModifierMultiplier=2.00
	 AdrenReductionPerLevel=75
     PlayerLevelReqd(1)=180
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityPriestCraftsman'
     ExcludingAbilities(1)=Class'DEKRPG208.AbilityPaladinCraftsman'
     AbilityName="Niche: Enchanter"
     Description="Increases the max modifier on all magic weapons, but reduces your max adrenaline.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost(per level): 50"
     StartingCost=50
     MaxLevel=1
}
