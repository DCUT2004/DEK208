class AbilityCompanionAuto extends CostRPGAbility
	config(UT2004RPG);
	
var config float HealthMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local DefenseDroneOneInv Drone;
	
	Drone = DefenseDroneOneInv(Other.FindInventoryType(class'DefenseDroneOneInv'));

	if (Drone != None)
	{
		Drone.TurnOnDefense();
	}
	else
		return;
}

static simulated function ModifyConstruction(Pawn Other, int AbilityLevel)
{
	Other.HealthMax *= default.HealthMultiplier;
	Other.Health *= default.HealthMultiplier;
	Other.SuperHealthMax *= default.HealthMultiplier;
}

defaultproperties
{
	 HealthMultiplier=0.75000000
     PlayerLevelReqd(1)=180
	 RequiredAbilities(0)=Class'DEKRPG208.AbilityVehicleDrone'
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityRoboticsAuto'
     AbilityName="Niche: Companion"
     Description="Adds defense bolts to your healing drone, but reduces the max health of your constructions.|You must have the healing drone ability before purchasing this niche. You must be level 180 to buy a niche. You can not be in more than one niche at a time.||Cost(per level): 10"
     StartingCost=50
     MaxLevel=1
}
