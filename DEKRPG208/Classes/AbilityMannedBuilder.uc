class AbilityMannedBuilder extends CostRPGAbility
	config(UT2004RPG);
	
var config float SentinelDamage;
var config int Level1MaxPoints, Level2MaxPoints, Level3MaxPoints, Level4MaxPoints, Level5MaxPoints;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local EngineerPointsInv Inv;
	local int i;
	
	Inv = EngineerPointsInv(Other.FindInventoryType(class'EngineerPointsInv'));
	if (Inv != None)
		Inv.TotalTurretPoints += (AbilityLevel*2);
	if (AbilityLevel == 1)
	{
		if (Inv.TotalTurretPoints > default.Level1MaxPoints)
			Inv.TotalTurretPoints = default.Level1MaxPoints;
	}
	else if (AbilityLevel == 2)
	{
		if (Inv.TotalTurretPoints > default.Level2MaxPoints)
			Inv.TotalTurretPoints = default.LEvel2MaxPoints;
	}
	else if (AbilityLevel == 3)
	{
		if (Inv.TotalTurretPoints > default.Level3MaxPoints)
			Inv.TotalTurretPoints = default.LEvel3MaxPoints;
	}
	else if (AbilityLevel == 4)
	{
		if (Inv.TotalTurretPoints > default.Level4MaxPoints)
			Inv.TotalTurretPoints = default.LEvel4MaxPoints;
	}
	else if (AbilityLevel == 5)
	{
		if (Inv.TotalTurretPoints > default.Level5MaxPoints)
			Inv.TotalTurretPoints = default.LEvel5MaxPoints;
	}
	for (i = 0; i < Inv.TurretAvailability.length; i++)
	{
		Inv.TurretAvailability[i].Number++;
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
			if (Instigator.Controller != None && 
				(DruidSentinelController(Instigator.Controller) != None || DruidBaseSentinelController(Instigator.Controller) != None || DruidLightningSentinelController(Instigator.Controller) != None || DruidEnergyWallController(Instigator.Controller) != None || DEKMercuryController(Instigator.Controller) != None || DEKBeamSentinelController(Instigator.Controller) != None || DEKAutoMachinegunController(Instigator.Controller) != None || DEKAutoSniperController(Instigator.Controller) != None || DEKHellfireSentinelController(Instigator.Controller) != None || DEKMachineGunSentinelController(Instigator.Controller) != None || DEKSniperSentinelController(Instigator.Controller) != None || DEKRocketSentinelController(Instigator.Controller) != None ))
			{
				// I don't think we actually get here, as sentinels do not get the abilities added.
				Damage *= default.SentinelDamage;
			}
		}
	}
}

defaultproperties
{
	 Level1MaxPoints=22
	 Level2MaxPoints=24
	 Level3MaxPoints=26
	 Level4MaxPoints=28
	 Level5MaxPoints=30
	 SentinelDamage=0.75000
     PlayerLevelReqd(1)=180
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityLinkUpBuilder'
     AbilityName="Niche: Manned"
     Description="Increases your maximum turret points by 2 per level and your maximum turrets summonable by 1. Decreases offensive sentinel damage.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.||Cost(per level): 10"
     StartingCost=10
     MaxLevel=5
}
