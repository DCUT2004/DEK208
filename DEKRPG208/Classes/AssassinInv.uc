class AssassinInv extends Inventory;

var Pawn PawnOwner, Target;
var AssassinMarker AssassinFX;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		Target;
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
	Super.GiveTo(Other);
}

simulated function SpawnFX()
{
	AssassinFX = PawnOwner.spawn(class'AssassinMarker', PawnOwner,, Target.Location, Target.Rotation);
	if (AssassinFX != None)
	{
		AssassinFX.RemoteRole = ROLE_SimulatedProxy;
		AssassinFX.SetBase(Target);
	}
}

simulated function Timer()
{
	if (PawnOwner == None || PawnOwner.Health <= 0)
	{
		if (AssassinFX != None)
			AssassinFX.Destroy();
		Destroy();
	}
	if (Target == None || Target.Health <= 0)
	{
		if (AssassinFX != None)
			AssassinFX.Destroy();
		Target = None;
		SetTimer(0, False);
	}
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
