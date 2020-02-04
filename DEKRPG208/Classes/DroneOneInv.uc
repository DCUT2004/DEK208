class DroneOneInv extends Inventory;

var Drone D;
var Pawn PawnOwner;
var config float TargetRadius;

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
	if (D == None)
	{
		D = PawnOwner.Spawn(class'Drone',PawnOwner,,PawnOwner.Location+vect(0,-32,64),PawnOwner.Rotation);
		D.TargetRadius = TargetRadius;
	}
	D.protPawn = PawnOwner;
}

defaultproperties
{
	 TargetRadius=1500.00
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
