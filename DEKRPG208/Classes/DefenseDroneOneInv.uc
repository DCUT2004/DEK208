class DefenseDroneOneInv extends Inventory;

var DefenseDrone D;
var Pawn PawnOwner;
var int ArmorHealingLevel,ResupplyLevel;

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
	Super.GiveTo(Other);
}

simulated function SpawnDrone()
{
	if (D == None)
	{
		D = PawnOwner.Spawn(class'DefenseDrone',PawnOwner,,PawnOwner.Location+vect(0,-32,64),PawnOwner.Rotation);
	}
	if (D != None)
	{
		D.ResupplyLevel = ResupplyLevel;
		D.ArmorHealingLevel = ArmorHealingLevel;
		D.protPawn = PawnOwner;
	}
}

simulated function TurnOnDefense()
{
	if (D != None && D.P != None)
		D.P.CanDefend = True;
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
