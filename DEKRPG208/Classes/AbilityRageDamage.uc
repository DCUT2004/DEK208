class AbilityRageDamage extends CostRPGAbility
	config(UT2004RPG) 
	abstract;
	
var config float MaxMultiplier;
var int TheHealth;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local RageInv Inv;

	Inv = RageInv(Other.FindInventoryType(class'RageInv'));
	if (Inv == None)
	{
		Inv = Other.spawn(class'RageInv', Other,,, rot(0,0,0));
		Inv.giveTo(Other);
		Inv.TheHealth = default.TheHealth;
	}
	if(Inv == None)
		return; //get em next pass I guess?
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local float DamageToMultiply;
	
	if (Damage > 0)
	{
		if (bOwnedByInstigator) 
		{
			DamageToMultiply = ((AbilityLevel / Instigator.Health) * 25) +1;
			//if (DamageToMultiply > default.MaxMultiplier)
				//DamageToMultiply = default.MaxMultiplier;
			Damage *= DamageToMultiply;
		}
		else
			return;
	}
}

defaultproperties
{
     MinPlayerLevel=60
     PlayerLevelStep=2
     AbilityName="Rage Damage"
     Description="The lower your health, the higher your cumulative damage bonus per level. |Cost (per level): 10,20,30,40,50. You must be level 60 to purchase the first level of this ability, level 62 to purchase the second level, and so on."
     StartingCost=10
     CostAddPerLevel=10
     MaxLevel=5
}
