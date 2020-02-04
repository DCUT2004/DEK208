class AbilitySturdy extends CostRPGAbility
	config(UT2004RPG);
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	Other.Mass=20000.000000;
}

defaultproperties
{
     LevelCost(1)=10
     AbilityName="Sturdiness"
     Description="Prevents knockback when taking damage. Cost: 10."
     MaxLevel=1
}
