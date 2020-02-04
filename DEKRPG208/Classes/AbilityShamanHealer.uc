class AbilityShamanHealer extends CostRPGAbility
	config(UT2004RPG);
	
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
	local ArtifactMassHeal AMH;

	AMH = ArtifactMassHeal(Other.FindInventoryType(class'ArtifactMassHeal'));
	
	if(AMH == None)
	{
		AMH = Other.spawn(class'ArtifactMassHeal', Other,,, rot(0,0,0));
		if(AMH== None)
			return; //get em next pass I guess?
		AMH.giveTo(Other);
		// I'm guessing that NextItem is here to ensure players don't start with
		// no item selected.  So the if should stop wierd artifact scrambles.
		if(Other.SelectedItem == None)
			Other.NextItem();
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=180
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityGuardianHealer'
     AbilityName="Niche: Shaman"
     Description="Use the Sacrificial Heal artifact to heal up to three teammates with the lowest health. You will lose health equivalent to the healing amount received by your teammates.|You must be level 180 and have at least level 8 of Loaded Healing before buying this niche. You can not be in more than one niche at a time.||Cost(per level): 50"
     StartingCost=50
     MaxLevel=1
}
