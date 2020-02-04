class AbilityNecroExperiencedResurrect extends CostRPGAbility
	config(UT2004RPG);
	
var config float XPIncreasePerLevel;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ArtifactResurrect AR;
	
	AR = ArtifactResurrect(Other.FindInventoryType(class'ArtifactResurrect'));

	if (AR != None)
	{
		AR.XPMultiplier += default.XPIncreasePerLevel;
	}
	else
		return;
}

defaultproperties
{
	 XPIncreasePerLevel=0.100000
     RequiredAbilities(0)=Class'DEKRPG208.AbilityNecromancer'
     AbilityName="Experienced Resurrection"
     Description="Increases the experience received from resurrected teammates by 10% per level.||You must have at least level one of Loaded Necromancer before purchasing this ability.||Cost(per level): 5,8,11,14,17..."
     StartingCost=5
     CostAddPerLevel=3
     MaxLevel=20
}
