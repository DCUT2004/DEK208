class AbilityDroneDamage extends CostRPGAbility
	config(UT2004RPG);
	
var config float DamageMultiplier;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	local bool ok;
	local int x;

	for (x = 0; x < Data.Abilities.length; x++)
	{
		if (Data.Abilities[x] == class'AbilityDroneOne' || Data.Abilities[x] == class'AbilityDroneTwo')
				ok = true;
	}
	if (!ok)
		return 0;
	else
		return Super.Cost(Data, CurrentLevel);
}
	
static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0 && DamageType == class'DamTypeDronePlasma')
		Damage *= (1 + (AbilityLevel * default.DamageMultiplier));
}

defaultproperties
{
     DamageMultiplier=0.100000
     AbilityName="Drone Damage"
     Description="If you have an offensive drone, this ability will increase its damage by 10% per level. You must have Drone I or II before buying.|Cost(per level): 5,10,15,20,25..."
     StartingCost=5
     CostAddPerLevel=5
     MaxLevel=10
}
