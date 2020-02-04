class MeteorShowerInv extends Inventory
	config(UT2004RPG);

var Controller InstigatorController;
var Pawn PawnOwner;
var config float SpawnInterval;
var config float MinMeteorRange, MaxMeteorRange;

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
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local Pawn OldInstigator;

	if(Other == None)
	{
		destroy();
		return;
	}
	if (InstigatorController == None)
		InstigatorController = Other.Controller;

	//want Instigator to be the one that caused the freeze
	OldInstigator = Instigator;
	Super.GiveTo(Other);
	PawnOwner = Other;

	Instigator = OldInstigator;
	
	SetTimer(SpawnInterval,True);
}

simulated function Timer()
{
	local vector MeteorLocation;
	local float MeteorRangeX, MeteorRangeY;
	local Meteor M;
	local Pawn P;
	
	if (PawnOwner == None || PawnOwner.Health <= 0)
		Destroy();
		
	P = PawnOwner;
	if (P != None && P.IsA('Vehicle'))
		P = Vehicle(P).Driver;
	
	if (P != None && P.Controller != None)
	{
		MeteorRangeX = RandRange(MinMeteorRange, MaxMeteorRAnge);
		MeteorRangeY = RandRange(MinMeteorRange, MaxMeteorRAnge);
		MeteorLocation.X = P.Location.X + MeteorRangeX;
		MeteorLocation.Y = P.Location.Y + MeteorRangeY;
		M = P.spawn(class'Meteor',P,,MeteorLocation + vect(0,0,1200));
	}
}

defaultproperties
{
	MinMeteorRange=-1500.00
	MaxMeteorRange=1500.00
	SpawnInterval=0.50000
    bOnlyRelevantToOwner=False
    bAlwaysRelevant=True
    bReplicateInstigator=True
}
