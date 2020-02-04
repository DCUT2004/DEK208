class AbilityRecklessTank extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float SelfDamageMultiplier, ProtectionMultiplier;


static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(bOwnedByInstigator)
	{
		if (Injured == Instigator)
			Damage *= 2;
		else if (Injured != Instigator)
			return;
	}
	if(Damage > 0 && !bOwnedByInstigator)
		Damage *= (abs((AbilityLevel * default.ProtectionMultiplier)-1));
}

defaultproperties
{
     PlayerLevelReqd(1)=180
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityHeavyTank'
     ExcludingAbilities(1)=Class'DEKRPG208.AbilityLargeTank'
     SelfDamageMultiplier=0.150000
	 ProtectionMultiplier=0.050000
     AbilityName="Niche: Reckless"
     Description="Increases your cumulative total damage reduction by 5% per level, but also doubles self-damage.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
