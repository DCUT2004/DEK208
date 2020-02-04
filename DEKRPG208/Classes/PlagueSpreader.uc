//A flag to show who has the Plague ability
class PlagueSpreader extends Inventory;

var Pawn PawnOwner;
var int NumInfections;
var transient DruidsRPGKeysInteraction InteractionOwner;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		NumInfections;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if(Other == None)
	{
		destroy();
		return;
	}
	if (Other != None)
		PawnOwner = Other;
		
	SetTimer(1, True);
	Super.GiveTo(Other);
}

simulated function Timer()
{
	local int Counter;
	local PlagueInv PInv;
	local Controller C;
	
	for ( C = Level.ControllerList; C != None; C = C.NextController )
	{
		if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.SameTeamAs(PawnOwner.Controller))
		{
			PInv = PlagueInv(C.Pawn.FindInventoryType(class'PlagueInv'));
			if (PInv != None)
			{
				if (PInv.Necromancer == PawnOwner.Controller || PInv.InfectorOne == PawnOwner || PInv.InfectorTwo == PawnOwner || PInv.InfectorThree == PawnOwner)
					Counter++;
			}
		}
	}
	NumInfections = Counter;
	Counter = 0;
}

simulated function destroyed()
{
 	if( InteractionOwner != None )
 	{
 		InteractionOwner.PInv = None;
 		InteractionOwner = None;
 	}
	super.destroyed();
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
