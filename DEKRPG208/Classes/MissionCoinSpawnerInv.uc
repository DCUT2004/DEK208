class MissionCoinSpawnerInv extends Inventory
	config(UT2004RPG);

var Controller InstigatorController;
var Pawn PawnOwner;
var config float SpawnInterval;
var int CoinCount;
var config int MaxCoins;
var MissionMultiplayerInv MMPI;

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

	OldInstigator = Instigator;
	Super.GiveTo(Other);
	PawnOwner = Other;

	Instigator = OldInstigator;
	
	CoinCount = 0;
	SetTimer(SpawnInterval,True);
	
	if (PawnOwner != None)
		MMPI = MissionMultiplayerInv(PawnOwner.FindInventoryType(class'MissionMultiplayerInv'));
}

function Timer()
{
	local NavigationPoint Dest;
	local MissionCoin C;
	local Pawn P;
	
	if (PawnOwner == None || PawnOwner.Health <= 0)
		Destroy();
		
	P = PawnOwner;
	if (P != None && P.IsA('Vehicle'))
		P = Vehicle(P).Driver;
	
	if (P != None && P.Controller != None)
	{
		Dest = P.Controller.FindRandomDest();
		C = P.spawn(class'MissionCoin',,,Dest.Location + vect(0,0,1500));
		if (C != None)
			CoinCount++;
		if (MMPI != None && (MMPI.Stopped || !MMPI.CoinGrabActive))
		{
			Destroy();
		}
	}
	if (CoinCount >= default.MaxCoins)
	{
		Destroy();
	}
}

simulated function destroyed()
{
	super.destroyed();
}

defaultproperties
{
	SpawnInterval=0.500000
	MaxCoins=500
    bOnlyRelevantToOwner=False
    bAlwaysRelevant=True
    bReplicateInstigator=True
}
