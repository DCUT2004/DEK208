class AbilityDroneOne extends CostRPGAbility
	config(UT2004RPG);
	
var config float TargetRadiusMultiplier;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	//local Drone Drone;
	local DroneOneInv DroneOneInv;
	
	DroneOneInv = DroneOneInv(Other.FindInventoryType(class'DroneOneInv'));
	if (DroneOneInv == None)
	{
		DroneOneInv = Other.spawn(class'DroneOneInv');
		DroneOneInv.TargetRadius = (1+(AbilityLevel* default.TargetRadiusMultiplier));
		DroneOneInv.giveTo(Other);
	}
	else
		return;
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if (Injured != Instigator || !bOwnedByInstigator)
		return;
	if(Damage > 0 && DamageType == class'DamTypeDronePlasma')
		Damage = 0; //Don't let drone hurt spawner.
}

defaultproperties
{
     TargetRadiusMultiplier=0.200000
     LevelCost(1)=20
     LevelCost(2)=7
     LevelCost(3)=7
     LevelCost(4)=7
     LevelCost(5)=7
     AbilityName="Drone"
     Description="Spawns a drone which will follow you and attack nearby targets.|Each level also increases the target radius of your drones by 20% per level.|Cost(per level): 20,7,7,7,7"
     MaxLevel=5
}
