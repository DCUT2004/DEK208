class AbilityReducedDamage extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float LevMultiplier;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0)
		Damage *= (default.LevMultiplier);
}

defaultproperties
{
     LevMultiplier=0.500000
     MinPlayerLevel=15
     PlayerLevelStep=1
     AbilityName="Reduced Damage"
     Description="This ability should not be purchaseable. Decreases your cumulative total damage bonus by 50% per level. |Cost (per level): 5. You must be level 15 to purchase the first level of this ability, level 16 to purchase the second level, and so on."
     StartingCost=5
     MaxLevel=1
}
