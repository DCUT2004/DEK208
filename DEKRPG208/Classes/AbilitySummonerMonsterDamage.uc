class AbilitySummonerMonsterDamage extends AbilityMonsterDamage
	config(UT2004RPG) 
	abstract;

var config float DamageMultiplier;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0 && ClassIsChildOf(DamageType, class'WeaponDamageType'))
		Damage *= (1 + (AbilityLevel * default.DamageMultiplier));
			
	if(!bOwnedByInstigator || Instigator == None || Monster(Instigator) == None)
		return;
	// now know this is damage done by a monster
	if(Damage > 0)
		Damage *= (1 + (AbilityLevel * default.LevMultiplier));
}

defaultproperties
{
     DamageMultiplier=-0.050000
     Description="Increases the damage done by Pets by 10% per level, but decreases weapon damage by 5% per level. |Cost (per level): 7."
     StartingCost=7
}
