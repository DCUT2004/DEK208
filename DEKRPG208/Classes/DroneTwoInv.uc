class DroneTwoInv extends Inventory;

var Drone Drone;
var Pawn PawnOwner;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if(Other == None)
	{
		destroy();
		return;
	}
	PawnOwner = Other;
	SpawnDrone();
	SetTimer(0.1, True);
	Super.GiveTo(Other);
}

simulated function SpawnDrone()
{
	Drone = PawnOwner.Spawn(class'Drone',PawnOwner,,PawnOwner.Location+vect(0,-32,64),PawnOwner.Rotation);
	Drone.protPawn = PawnOwner;
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
