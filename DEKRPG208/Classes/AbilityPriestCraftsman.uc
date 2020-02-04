class AbilityPriestCraftsman extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float WeaponDamage;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local PriestInv Inv;
	
	if (Other != None)
	{
		Inv = PriestInv(Other.FindInventoryType(class'PriestInv'));
		if (Inv == None)
		{
			Inv = Other.spawn(class'PriestInv', Other,,, rot(0,0,0));
			Inv.GiveTo(Other);
			Inv.AbilityLevel = AbilityLevel;
		}
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0)
	{
		if (ClassIsChildOf(DamageType, class'WeaponDamageType') || ClassIsChildOf(DamageType, class'VehicleDamageType'))
			Damage *= default.WeaponDamage;
	}
}

defaultproperties
{
	 WeaponDamage=0.500000
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityPaladinCraftsman'
     ExcludingAbilities(1)=Class'DEKRPG208.AbilityEnchanterCraftsman'
     PlayerLevelReqd(1)=180
     AbilityName="Niche: Priest"
     Description="Each time a team player that you've granted invulnerability or boost damage to makes a kill, you receive 10% per level of their adrenaline kill value as adrenaline. This can be useful for sustaining spheres and remote artifacts. Weapon and vehicle damage is reduced.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
