class AbilityPrimalEWM extends AbilityEnhancedWeaponSpeed
	config(UT2004RPG) 
	abstract;
	
var config int AdrenReductionPerLevel;

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

defaultproperties
{
	 ExcludingAbilities(0)=Class'DEKRPG208.AbilityBloodlustEWM'
	 ExcludingAbilities(1)=Class'DEKRPG208.AbilityRageEWM'
	 AdrenReductionPerLevel=15
     SpeedMultiplier=0.050000
     AbilityName="Niche: Primal"
     Description="Increases your cumulative weapon speed by 5% per level, but also decreases your max adrenaline by 15 per level.|You must be level 180 to buy a niche. You can not be in more than one niche at a time. Cost (per level): 10."
     StartingCost=10
}
