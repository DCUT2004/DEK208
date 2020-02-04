class LargeInv extends Inventory;

var Pawn PawnOwner;
var int AbilityLevel;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		AbilityLevel;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if(Other == None)
	{
		destroy();
		return;
	}

	PawnOwner = Other;
	
	SetTimer(0.1, true);
	
	Super.GiveTo(Other);
}

simulated function Timer()
{
	local xPawn X;
	
	if (PawnOwner == None || PawnOwner.Health <= 0)
	{
		Destroy();
	}

	X = xPawn(PawnOwner);
	if (X.BaseEyeheight != (1 +(AbilityLevel*0.3) * X.CollisionHeight))
	{
		X.BaseEyeheight = (1 +(AbilityLevel*0.3) * X.CollisionHeight);
	}
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
