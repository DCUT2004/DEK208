class AbilityWizardEAM extends CostRPGAbility
	config(UT2004RPG) 
	abstract;
	
static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	local bool ok;
	local int x;

	for (x = 0; x < Data.Abilities.length; x++)
	{
		if (Data.Abilities[x] == class'DruidArtifactLoaded')
			if (Data.AbilityLevels[x] > 4)
				ok = true;
	}
	if (!ok)
		return 0;
	else
		return Super.Cost(Data, CurrentLevel);
}

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local WizardInv Inv;
	
	Inv = WizardInv(Other.FindInventoryType(class'WizardInv'));
	
	if (Inv == None)
	{
		Inv = Other.Spawn(class'WizardInv', Other);
		Inv.GiveTo(Other);
	}
}
	
static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local RPGWeapon W;
	
	W = RPGWeapon(Weapon);
		
	if (W != None && ClassIsChildOf(W.class, class'RPGWeapon'))
	{
		if (W.MaxModifier > W.default.MaxModifier/2)
			W.MaxModifier = W.default.MaxModifier/2;
		if (W.MinModifier > 0)
			W.MinModifier = W.default.MinModifier/2;
		if (W.MaxModifier <= 0)
			W.MaxModifier = 1;
	}
}

defaultproperties
{
	 ExcludingAbilities(0)=Class'DEKRPG208.AbilityPowerEAM'
	 ExcludingAbilities(1)=Class'DEKRPG208.AbilityMaxedEAM'
     PlayerLevelReqd(1)=180
     AbilityName="Niche: Wizard"
     Description="Adrenaline usage and cooldown time is reduced even further for artifacts. However, the max modifier on magic weapons is reduced.|You must be level 180 to buy a niche. You need Loaded Artifacts 5 before purchasing this ability. You can not be in more than one niche at a time.|Cost (per level): 50."
     StartingCost=50
     MaxLevel=1
}
