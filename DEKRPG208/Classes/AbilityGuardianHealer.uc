class AbilityGuardianHealer extends CostRPGAbility
	config(UT2004RPG);
	
var config int AdrenReductionPerLevel, MinimumAdrenRequired;
	
static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	local bool ok;
	local int x;

	for (x = 0; x < Data.Abilities.length; x++)
	{
		if (Data.Abilities[x] == class'AbilityDEKLoadedHealing')
			if (Data.AbilityLevels[x] >= 8)
				ok = true;
	}
	if (!ok)
		return 0;
	else
		return Super.Cost(Data, CurrentLevel);
}

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ArtifactGuardianHeal AGH;

	AGH = ArtifactGuardianHeal(Other.FindInventoryType(class'ArtifactGuardianHeal'));

	if(AGH == None)
	{
		AGH = Other.spawn(class'ArtifactGuardianHeal', Other,,, rot(0,0,0));
		if(AGH== None)
			return; //get em next pass I guess?
		AGH.giveTo(Other);
		// I'm guessing that NextItem is here to ensure players don't start with
		// no item selected.  So the if should stop wierd artifact scrambles.
		if(Other.SelectedItem == None)
			Other.NextItem();
	}
	if (AGH != None)
	{
		AGH.AdrenalineRequired -= (AbilityLevel*default.AdrenReductionPerLevel);
		if (AGH.AdrenalineRequired < default.MinimumAdrenRequired)
			AGH.AdrenalineRequired = default.MinimumAdrenRequired;
	}
}

defaultproperties
{
	 AdrenReductionPerLevel=10
	 MinimumAdrenRequired=50
     PlayerLevelReqd(1)=180
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityShamanHealer'
     AbilityName="Niche: Guardian"
     Description="Select a teammate with the Guardian artifact. Any time this teammate's health drops below a certain level, a healing blast is automatically spawned at the teammate's location, provided you have 100 adrenaline. Each level of this ability decreases the adrenaline cost by 10.|You must be level 180 and have at least level 8 of Loaded Healing before buying this niche. You can not be in more than one niche at a same time.||Cost(per level): 10"
     StartingCost=10
     MaxLevel=20
}
