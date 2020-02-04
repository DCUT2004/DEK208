class AbilityMagicShield extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local MagicShieldInv Inv;

	Inv = MagicShieldInv(Other.FindInventoryType(class'MagicShieldInv'));
		
	if(Inv == None)
	{
		Inv = Other.spawn(class'MagicShieldInv');
		Inv.giveTo(Other);
	}
}

defaultproperties
{
     AbilityName="Magic Shield"
     Description="Prevents magic from affecting you including Null, Vorpal, Knockback, Freeze, and Heat. Also prevents Vampire and Energy for the enemy.|Cost (per level): 30"
     StartingCost=30
     MaxLevel=1
}
