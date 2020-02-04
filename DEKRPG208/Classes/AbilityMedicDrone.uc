class AbilityMedicDrone extends CostRPGAbility
	config(UT2004RPG);
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local MedicDrone Drone;
	local MedicDroneInv Inv;
	local ArtifactRemoteMedicDrone ARMD;
	
	Inv = MedicDroneInv(Other.FindInventoryType(class'MedicDroneInv'));
	ARMD = ArtifactRemoteMedicDrone(Other.FindInventoryType(class'ArtifactRemoteMedicDrone'));
	
	if (Inv == None)
	{
		Inv = Other.Spawn(class'MedicDroneInv',Other,,,rot(0,0,0));
		Inv.giveTo(Other);
	}
	else
		return;
		
	if (ARMD == None)
	{
		ARMD = Other.spawn(class'ArtifactRemoteMedicDrone', Other,,, rot(0,0,0));
		ARMD.giveTo(Other);
	}
	// I'm guessing that NextItem is here to ensure players don't start with
	// no item selected.  So the if should stop wierd artifact scrambles.
	if(Other.SelectedItem == None)
		Other.NextItem();
	
	Drone = Other.Spawn(class'MedicDrone',Other,,Other.Location+vect(0,-32,64),Other.Rotation);
	Drone.DroneTarget = None;
	Drone.DroneMaster = Other;
	if (Drone!= None && Drone.DroneMaster == Other && AbilityLevel >= 1)
	{
		Drone.HealthHealingLevel = AbilityLevel;

	}
}

defaultproperties
{
     LevelCost(1)=20
     LevelCost(2)=7
     LevelCost(3)=7
     LevelCost(4)=7
     LevelCost(5)=7
     AbilityName="Medic Drone"
     Description="Spawns a drone which will heal a friendly target. You can use the Remote Drone artifact to order your drone to follow a selected teammate with your crosshair. Aim on an opposing target to return the drone to you.|Each level increases the rate of healing.||Cost(per level): 20,7,7,7,7"
     MaxLevel=5
}
