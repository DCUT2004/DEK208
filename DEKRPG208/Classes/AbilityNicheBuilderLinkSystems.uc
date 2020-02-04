class AbilityNicheBuilderLinkSystems extends CostRPGAbility
	config(UT2004RPG);
	
var config int Lev1HealShot,Lev2HealShot,Lev3HealShot,Lev4HealShot,Lev5HealShot,Lev6HealShot,Lev7HealShot,Lev8HealShot,Lev9HealShot,Lev10HealShot,Lev11HealShot,Lev12HealShot,Lev13HealShot,Lev14HealShot,Lev15HealShot,Lev16HealShot,Lev17HealShot,Lev18HealShot,Lev19HealShot,Lev20HealShot;
	
static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	local bool ok;
	local int x;

	for (x = 0; x < Data.Abilities.length; x++)
	{
		if (Data.Abilities[x] == class'AbilityBaseSpecialist')
			if (Data.AbilityLevels[x] >= 15)
				ok = true;
	}
	if (!ok)
		return 0;
	else
		return Super.Cost(Data, CurrentLevel);
}

static simulated function ModifyConstruction(Pawn Other, int AbilityLevel)
{
	local DruidLinkSentinelController DLSC;
	
	DLSC = DruidLinkSentinelController(Other.Controller);
	
	if (DruidLinkSentinel(Other) != None || DruidAddLinkSentinel(Other) != None)
	{
		if (DLSC != None)
		{
			if (AbilityLevel == 1)
				DLSC.VehicleHealPerShot = default.Lev1HealShot;
			else if (AbilityLevel == 2)
				DLSC.VehicleHealPerShot = default.Lev2HealShot;
			else if (AbilityLevel == 3)
				DLSC.VehicleHealPerShot = default.Lev3HealShot;
			else if (AbilityLevel == 4)
				DLSC.VehicleHealPerShot = default.Lev4HealShot;
			else if (AbilityLevel == 5)
				DLSC.VehicleHealPerShot = default.Lev5HealShot;
			else if (AbilityLevel == 6)
				DLSC.VehicleHealPerShot = default.Lev6HealShot;
			else if (AbilityLevel == 7)
				DLSC.VehicleHealPerShot = default.Lev7HealShot;
			else if (AbilityLevel == 8)
				DLSC.VehicleHealPerShot = default.Lev8HealShot;
			else if (AbilityLevel == 9)
				DLSC.VehicleHealPerShot = default.Lev9HealShot;
			else if (AbilityLevel == 10)
				DLSC.VehicleHealPerShot = default.Lev10HealShot;
			else if (AbilityLevel == 11)
				DLSC.VehicleHealPerShot = default.Lev11HealShot;
			else if (AbilityLevel == 12)
				DLSC.VehicleHealPerShot = default.Lev12HealShot;
			else if (AbilityLevel == 13)
				DLSC.VehicleHealPerShot = default.Lev13HealShot;
			else if (AbilityLevel == 14)
				DLSC.VehicleHealPerShot = default.Lev14HealShot;
			else if (AbilityLevel == 15)
				DLSC.VehicleHealPerShot = default.Lev15HealShot;
			else if (AbilityLevel == 16)
				DLSC.VehicleHealPerShot = default.Lev16HealShot;
			else if (AbilityLevel == 17)
				DLSC.VehicleHealPerShot = default.Lev17HealShot;
			else if (AbilityLevel == 18)
				DLSC.VehicleHealPerShot = default.Lev18HealShot;
			else if (AbilityLevel == 19)
				DLSC.VehicleHealPerShot = default.Lev19HealShot;
			else if (AbilityLevel == 20)
				DLSC.VehicleHealPerShot = default.Lev20HealShot;
		}
	}
}

defaultproperties
{
     Lev1HealShot=45
     Lev2HealShot=50
     Lev3HealShot=55
     Lev4HealShot=60
     Lev5HealShot=65
     Lev6HealShot=70
     Lev7HealShot=75
     Lev8HealShot=80
     Lev9HealShot=85
     Lev10HealShot=90
     Lev11HealShot=95
     Lev12HealShot=100
     Lev13HealShot=105
     Lev14HealShot=110
     Lev15HealShot=115
     Lev16HealShot=120
     Lev17HealShot=125
     Lev18HealShot=130
     Lev19HealShot=135
     Lev20HealShot=140
     PlayerLevelReqd(1)=180
     AbilityName="Niche: Link Systems"
     Description="One of several Base Builder niches. You must be level 180 and have at least level 15 of Base Builder before buying a niche. You can not be in more than one niche at the same time.||The Link System niche enhances your Link Sentinel. Each level adds 5 to each heal shot.||Cost(per level): 10,15,20,25,30,35,40,45,50."
     StartingCost=10
     CostAddPerLevel=5
     MaxLevel=20
}
