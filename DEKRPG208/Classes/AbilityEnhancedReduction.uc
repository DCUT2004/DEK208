class AbilityEnhancedReduction extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float LevMultiplier;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(bOwnedByInstigator)
		return; //if the instigator is doing the damage, ignore this.
	if(Damage > 0 )
		Damage *= (abs((AbilityLevel * default.LevMultiplier)-1));
}

defaultproperties
{
     LevMultiplier=0.040000
     MinPlayerLevel=40
     PlayerLevelStep=1
     AbilityName="Advanced Damage Reduction"
     Description="Increases your cumulative total damage reduction by 4% per level. Does not apply to self damage.|Cost (per level): 5. You must be level 40 to purchase the first level of this ability, level 41 to purchase the second level, and so on."
     StartingCost=5
     MaxLevel=20
}
