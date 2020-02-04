class MissionBalloonSpawnerInv extends Inventory
	config(UT2004RPG);

var Controller InstigatorController;
var Pawn PawnOwner;
var config float SpawnInterval;
var int BalloonCount;
var config int MaxBalloons;
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

	//want Instigator to be the one that caused the freeze
	OldInstigator = Instigator;
	Super.GiveTo(Other);
	PawnOwner = Other;

	Instigator = OldInstigator;
	
	BalloonCount = 0;
	SetTimer(SpawnInterval,True);
	
	if (PawnOwner != None)
		MMPI = MissionMultiplayerInv(PawnOwner.FindInventoryType(class'MissionMultiplayerInv'));
}

function Timer()
{
	local NavigationPoint Dest;
	local MissionBalloon R;
	local MissionBalloonGreen G;
	local MissionBalloonBlue B;
	local MissionBalloonOrange O;
	local MissionBalloonPurple Pu;
	local MissionBalloonYellow Y;
	local Pawn P;
	
	if (PawnOwner == None || PawnOwner.Health <= 0)
		Destroy();
		
	P = PawnOwner;
	if (P != None && P.IsA('Vehicle'))
		P = Vehicle(P).Driver;
	
	if (P != None && P.Controller != None)
	{
		Dest = P.Controller.FindRandomDest();
		if (Rand(99) <= 16.66)
		{
			R = P.spawn(class'MissionBalloon',,,Dest.Location + vect(0,0,40));
			BalloonCount++;
		}
		else if (Rand(99) <= 33.32)
		{
			G = P.spawn(class'MissionBalloonGreen',,,Dest.Location + vect(0,0,40));
			BalloonCount++;
		}
		else if (Rand(99) <= 49.98)
		{
			B = P.spawn(class'MissionBalloonBlue',,,Dest.Location + vect(0,0,40));
			BalloonCount++;
		}
		else if (Rand(99) <= 66.64)
		{
			O = P.spawn(class'MissionBalloonOrange',,,Dest.Location + vect(0,0,40));
			BalloonCount++;
		}
		else if (Rand(99) <= 83.3)
		{
			Pu = P.spawn(class'MissionBalloonPurple',,,Dest.Location + vect(0,0,40));
			BalloonCount++;
		}
		else if (Rand(99) <= 100.0)
		{
			Y = P.spawn(class'MissionBalloonYellow',,,Dest.Location + vect(0,0,40));
			BalloonCount++;
		}
		if (MMPI != None)
		{
			if (!MMPI.stopped && MMPI.BalloonPopActive && MMPI.MissionCount >= MMPI.MissionGoal)
			{
				Destroy();
			}
		}
	}
	if (R != None)
	{
		if (R.Controller != None)
			R.Controller.Destroy();
	}
	if (G != None)
	{
		if (G.Controller != None)
			G.Controller.Destroy();
	}
	if (B != None)
	{
		if (B.Controller != None)
			B.Controller.Destroy();
	}
	if (O != None)
	{
		if (O.Controller != None)
			O.Controller.Destroy();
	}
	if (Pu != None)
	{
		if (Pu.Controller != None)
			Pu.Controller.Destroy();
	}
	if (Y != None)
	{
		if (Y.Controller != None)
			Y.Controller.Destroy();
	}
	if (BalloonCount >= default.MaxBalloons)
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
	SpawnInterval=1.000000
	MaxBalloons=100
    bOnlyRelevantToOwner=False
    bAlwaysRelevant=True
    bReplicateInstigator=True
}
