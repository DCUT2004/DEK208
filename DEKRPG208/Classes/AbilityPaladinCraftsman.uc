class AbilityPaladinCraftsman extends CostRPGAbility
	config(UT2004RPG);
	
var config int AdrenReductionPerLevel;
var config float ExpAddPerLevel;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ArtifactPaladin AP;

	AP = ArtifactPaladin(Other.FindInventoryType(class'ArtifactPaladin'));

	if(AP == None)
	{
		AP = Other.spawn(class'ArtifactPaladin', Other,,, rot(0,0,0));
		if(AP == None)
			return; //get em next pass I guess?
		AP.giveTo(Other);
		// I'm guessing that NextItem is here to ensure players don't start with
		// no item selected.  So the if should stop wierd artifact scrambles.
		if(Other.SelectedItem == None)
			Other.NextItem();
	}
	if (AP != None)
	{
		AP.AdrenalineRequired -= (AbilityLevel * default.AdrenReductionPerLevel);
		AP.ExpPerDamage += (AbilityLevel * default.ExpAddPerLevel);
	}
}

defaultproperties
{
	 ExpAddPerLevel=0.01
	 AdrenReductionPerLevel=10
     PlayerLevelReqd(1)=180
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityPriestCraftsman'
     ExcludingAbilities(1)=Class'DEKRPG208.AbilityEnchanterCraftsman'
     AbilityName="Niche: Paladin"
     Description="Allows you to protect one teammate by automatically casting safety on that player when they take fatal damage, provided you have 200 adrenaline at the time of impact. Each level of this ability reduces the adrenaline cost by 10, and also increases the XP when saving this player.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost(per level): 10"
     StartingCost=10
     MaxLevel=20
}
