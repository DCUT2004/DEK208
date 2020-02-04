class AbilityRoboticsAuto extends CostRPGAbility
	config(UT2004RPG);
	
var config float WeaponDamage;
var config int Level1MaxPoints, Level2MaxPoints, Level3MaxPoints, Level4MaxPoints, Level5MaxPoints;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local EngineerPointsInv Inv;
	local int i;
	
	Inv = EngineerPointsInv(Other.FindInventoryType(class'EngineerPointsInv'));
	if (Inv != None)
		Inv.TotalSentinelPoints += (AbilityLevel*2);
	if (AbilityLevel == 1)
	{
		if (Inv.TotalSentinelPoints > default.Level1MaxPoints)
			Inv.TotalSentinelPoints = default.LEvel1MaxPoints;
	}
	else if (AbilityLevel == 2)
	{
		if (Inv.TotalSentinelPoints > default.Level2MaxPoints)
			Inv.TotalSentinelPoints = default.LEvel2MaxPoints;
	}
	else if (AbilityLevel == 3)
	{
		if (Inv.TotalSentinelPoints > default.Level3MaxPoints)
			Inv.TotalSentinelPoints = default.LEvel3MaxPoints;
	}
	else if (AbilityLevel == 4)
	{
		if (Inv.TotalSentinelPoints > default.Level4MaxPoints)
			Inv.TotalSentinelPoints = default.LEvel4MaxPoints;
	}
	else if (AbilityLevel == 5)
	{
		if (Inv.TotalSentinelPoints > default.Level5MaxPoints)
			Inv.TotalSentinelPoints = default.LEvel5MaxPoints;
	}
	for (i = 0; i < Inv.SentinelAvailability.length; i++)
	{
		Inv.SentinelAvailability[i].Number++;
	}
	
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{	
	if(!bOwnedByInstigator)
		return;

	if(Damage > 0)
	{
		if (ClassIsChildOf(DamageType, class'WeaponDamageType'))
		{
				Damage *= default.WeaponDamage;
		}
	}
}

defaultproperties
{
	 Level1MaxPoints=17
	 Level2MaxPoints=19
	 Level3MaxPoints=21
	 Level4MaxPoints=23
	 Level5MaxPoints=25
	 WeaponDamage=0.75000
     PlayerLevelReqd(1)=180
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityCompanionAuto'
     AbilityName="Niche: Robotics"
     Description="Increases your maximum sentinel points by 2 per level and your maximum sentinels summonable by 1. Decreases weapon damage.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.||Cost(per level): 10"
     StartingCost=10
     MaxLevel=5
}
