class AbilityBeastSummoner extends CostRPGAbility
	abstract;
	
var config float DamageMultiplier;
var config int MonsterPointSubtract;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	local bool ok;
	local int x;

	for (x = 0; x < Data.Abilities.length; x++)
	{
		if (Data.Abilities[x] == class'AbilityMonsterPoints')
			if (Data.AbilityLevels[x] >= 20)
				ok = true;
	}
	if (!ok)
		return 0;
	else
		return Super.Cost(Data, CurrentLevel);
}

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local MonsterPointsInv Inv;
	local RPGStatsInv StatsInv;
	local int x, y;

	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		if (StatsInv.Data.Abilities[x] == class'AbilityMonsterPoints')
			y = StatsInv.Data.AbilityLevels[x];

	Inv = MonsterPointsInv(Other.FindInventoryType(class'MonsterPointsInv'));
	
	if (Inv == None)
		return;
	else
	{
		Inv.TotalMonsterPoints -= default.MonsterPointSubtract;
	}

}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator || Instigator == None || Monster(Instigator) == None)
		return;
	// now know this is damage done by a monster
	if(Damage > 0)
		Damage *= (1 + (AbilityLevel * default.DamageMultiplier));
}

defaultproperties
{
	 MonsterPointSubtract=5
	 DamageMultiplier=0.25000
	 RequiredAbilities(0)=class'DEKRPG208.AbilityMonsterPoints'
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityHordeSummoner'
     ExcludingAbilities(1)=Class'DEKRPG208.AbilityMindControlSummoner'
     AbilityName="Niche: Beast"
     Description="Further increases the damage dealt by your pets by 25%, but also reduces your maximum monster points by 5.|You must be level 180 and have maxed out Monster Points before buying this niche. You can not be in more than one niche at a same time.||Cost(per level): 50"
     StartingCost=50
     MaxLevel=1
}
