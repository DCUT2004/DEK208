class AbilityBloodLustEWM extends DruidVampireSurge
	config(UT2004RPG) 
	abstract;
	
var config float DamageMultiplier;
	
static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{	
	if (bOwnedByInstigator)
		return;
	if (!bOwnedByInstigator)
	{
		if (Damage > 0)
			Damage *= 1 + (default.DamageMultiplier);
	}
}

defaultproperties
{
	 DamageMultiplier=0.25000
     MinDB=50
	 ExcludingAbilities(0)=Class'DEKRPG208.AbilityPrimalEWM'
	 ExcludingAbilities(1)=Class'DEKRPG208.AbilityRageEWM'
     AbilityName="Niche: Bloodlust"
     Description="For each level of this ability, you gain health from all kills. Your damage reduction is reduced by 25%.|You must have at least 50 Damage Bonus to purchase this niche. You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 10"
     StartingCost=10
     MaxLevel=20
}
