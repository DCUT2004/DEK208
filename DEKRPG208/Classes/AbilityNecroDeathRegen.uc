class AbilityNecroDeathRegen extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ShroudInv Inv;
	local DeathRegenInv DInv;
	
	if (Other.IsA('Monster'))
		return;
	
	Inv = ShroudInv(Other.FindInventoryType(class'ShroudInv'));
	if (Inv == None)
	{
		Inv = Other.spawn(class'ShroudInv', Other,,, rot(0,0,0));
		Inv.GiveTo(Other);
	}
	DInv = DeathRegenInv(Other.FindInventoryType(class'DeathRegenInv'));
	if (DInv == None)
	{
		DInv = Other.spawn(class'DeathRegenInv', Other,,, rot(0,0,0));
		DInv.RegenPerLevel = AbilityLevel;
		DInv.GiveTo(Other);
	}
}

defaultproperties
{
     MinHealthBonus=30
     HealthBonusStep=30
     AbilityName="Death Regeneration"
     Description="Heals 1 health per second per level for each ally that is either dead or resurrected, up to a maximum of 20 health per second.||You must have a Health Bonus stat equal to 30 times the ability level you wish to have before you can purchase it.||Cost (per level): 3,6,9..."
     StartingCost=3
	 CostAddPerLevel=3
     MaxLevel=10
}
