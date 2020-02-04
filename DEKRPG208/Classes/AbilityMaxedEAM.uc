class AbilityMaxedEAM extends CostRPGAbility
	config(UT2004RPG) 
	abstract;
	
var config int AdrenReductionPerLevel;
var config int HealthReductionPerLevel;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local AdrenReducerInv AInv;
	local HealthReducerInv HInv;
	
	if (Other != None)
	{
		HInv = HealthReducerInv(Other.FindInventoryType(class'HealthReducerInv'));
		AInv = AdrenReducerInv(Other.FindInventoryType(class'AdrenReducerInv'));
	}
	if (HInv == None)
	{
		HInv = Other.spawn(class'HealthReducerInv');		
		HInv.AbilityLevel = AbilityLevel;
		HInv.HealthReductionPerLevel = default.HealthReductionPerLevel;
		HInv.giveTo(Other);
	}
	if (AInv == None)
	{
		AInv = Other.spawn(class'AdrenReducerInv');		
		AInv.AbilityLevel = AbilityLevel;
		AInv.AdrenReductionPerLevel = default.AdrenReductionPerLevel;
		AInv.giveTo(Other);
	}
}

defaultproperties
{
	 AdrenReductionPerLevel=-10
	 HealthReductionPerLevel=10
	 ExcludingAbilities(0)=Class'DEKRPG208.AbilityWizardEAM'
	 ExcludingAbilities(1)=Class'DEKRPG208.AbilityPowerEAM'
     PlayerLevelReqd(1)=180
     AbilityName="Niche: Maxed"
     Description="Increases your max adrenaline by 10 per level, but also decreases max health by 10 per level.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
