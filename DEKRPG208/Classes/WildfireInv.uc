class WildfireInv extends Inventory
	config(UT2004RPG);
	
var Controller InstigatorController;
var Pawn PawnOwner;
	
replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
}

	
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Instigator != None)
		InstigatorController = Instigator.Controller;

	SetTimer(0.2, false);
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local Pawn OldInstigator;

	if (InstigatorController == None)
		InstigatorController = Other.DelayedDamageInstigatorController;

	//want Instigator to be the one that caused the poison
	OldInstigator = Instigator;
	Super.GiveTo(Other);
	PawnOwner = Other;
	Instigator = OldInstigator;
}

simulated function Timer()
{

	if (Level.NetMode != NM_DedicatedServer && PawnOwner != None)
	{
		PawnOwner.Spawn(class'WildfireFlame');
	}
	//dont call super. Bad things will happen.
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
     LifeSpan=1.000000
}
