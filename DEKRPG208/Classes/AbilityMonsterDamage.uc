class AbilityMonsterDamage extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float LevMultiplier;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator || Instigator == None || Monster(Instigator) == None)
		return;
	// now know this is damage done by a monster
	if(Damage > 0)
		Damage *= (1 + (AbilityLevel * default.LevMultiplier));
}

defaultproperties
{
     LevMultiplier=0.100000
     AbilityName="Pets: Damage Bonus"
     Description="Increases the damage done by Pets by 10% per level. |Cost (per level): 5."
     StartingCost=5
     MaxLevel=20
}
