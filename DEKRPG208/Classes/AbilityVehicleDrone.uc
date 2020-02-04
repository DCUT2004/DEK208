class AbilityVehicleDrone extends CostRPGAbility
	config(UT2004RPG);
	
var config float TargetRadiusMultiplier;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local DefenseDroneOneInv Drone;
	
	Drone = DefenseDroneOneInv(Other.FindInventoryType(class'DefenseDroneOneInv'));

	if (Drone == None)
	{
		Drone = Other.spawn(class'DefenseDroneOneInv');
		Drone.ArmorHealingLevel = (AbilityLevel * 3);
		Drone.ResupplyLevel = (AbilityLevel/2);
		Drone.giveTo(Other);
	}
	else
		return;
}

defaultproperties
{
     AbilityName="Healing Drone"
     Description="Spawns a drone which will follow you and repair vehicles and Auto sentinels, and resupply your ammo.|Each level adds 3 to each vehicle and sentinel heal shot, and 0.5 to each resupply shot.||Cost(per level): 5,10,15,20,25,30,35,40,45,50..."
     StartingCost=5
     CostAddPerLevel=5
     MaxLevel=20
}
