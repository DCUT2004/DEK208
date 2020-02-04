class AbilityEnhancedAdrenalineMax extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config int AdrenPerLevel;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	if (Other.Controller != None)
		Other.Controller.AdrenalineMax += (AbilityLevel * default.AdrenPerLevel);
}

defaultproperties
{
	 AdrenPerLevel=5
     MinAdrenalineMax=250
     AbilityName="Advanced Adren Bonus"
     Description="Increases your max adrenaline by 5 per level.||You must have at least 250 max adrenaline to purchase this ability.||Cost(per level): 7."
     StartingCost=7
     MaxLevel=20
}
