class MissionPortalBallSpawnerInv extends Inventory
	config(UT2004RPG);

var Controller InstigatorController;
var Pawn PawnOwner;
var config float SpawnInterval;
var int PortalBallCount, PortalCount;
var config int MaxPortalBalls, MaxPortals;
var MissionMultiplayerInv MMPI;
var int XPPerScore;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner, PortalBallCount, PortalCount;
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
	
	PortalBallCount = 0;
	SetTimer(SpawnInterval,True);
	
	if (PawnOwner != None)
		MMPI = MissionMultiplayerInv(PawnOwner.FindInventoryType(class'MissionMultiplayerInv'));
}

simulated function Timer()
{
	local NavigationPoint Dest;
	local MissionPortalBall B;
	local MissionPortalBallRed R;
	local MissionPortalBallBlue Bl;
	local MissionPortalBallGreen G;
	local MissionPortalBallOrange O;
	local MissionPortalBallPurple Pu;
	local MissionPortalBallPink Pi;
	local MissionPortal Portal;
	local Pawn P;
	
	if (PawnOwner == None || PawnOwner.Health <= 0)
		Destroy();
		
	P = PawnOwner;
	if (P != None && P.IsA('Vehicle'))
		P = Vehicle(P).Driver;
	
	if (P != None && P.Controller != None)
	{
		if (PortalBallCount < default.MaxPortalBalls)
		{
			Dest = P.Controller.FindRandomDest();
			Rand(100);
			if (Rand(100) <= 14.28)
				B = P.spawn(class'MissionPortalBall',,,Dest.Location + vect(0,0,40));
			else if (Rand(100) <= 28.57)
				R = P.spawn(class'MissionPortalBallRed',,,Dest.Location + vect(0,0,40));
			else if (Rand(100) <= 42.86)
				Bl = P.spawn(class'MissionPortalBallBlue',,,Dest.Location + vect(0,0,40));
			else if (Rand(100) <= 57.14)
				G = P.spawn(class'MissionPortalBallGreen',,,Dest.Location + vect(0,0,40));
			else if (Rand(100) <= 71.43)
				O = P.spawn(class'MissionPortalBallOrange',,,Dest.Location + vect(0,0,40));
			else if (Rand(100) <= 85.71)
				Pu = P.spawn(class'MissionPortalBallPurple',,,Dest.Location + vect(0,0,40));
			else if (Rand(100) <= 100.00)
				Pi = P.spawn(class'MissionPortalBallPink',,,Dest.Location + vect(0,0,40));
			if (B != None)
			{
				if (B.Controller != None)
					B.Controller.Destroy();
				PortalBallCount++;
			}
			if (R != None)
			{
				if (R.Controller != None)
					R.Controller.Destroy();
				PortalBallCount++;
			}
			if (Bl != None)
			{
				if (Bl.Controller != None)
					Bl.Controller.Destroy();
				PortalBallCount++;
			}
			if (G != None)
			{
				if (G.Controller != None)
					G.Controller.Destroy();
				PortalBallCount++;
			}
			if (O != None)
			{
				if (O.Controller != None)
					O.Controller.Destroy();
				PortalBallCount++;
			}
			if (Pu != None)
			{
				if (Pu.Controller != None)
					Pu.Controller.Destroy();
				PortalBallCount++;
			}
			if (Pi != None)
			{
				if (Pi.Controller != None)
					Pi.Controller.Destroy();
				PortalBallCount++;
			}
		}
		if (PortalCount < default.MaxPortals)
		{
			Dest = P.Controller.FindRandomDest();
			Portal = P.spawn(class'MissionPortal',,,Dest.Location + vect(0,0,40));
			if (Portal != None)
			{
				Portal.Spawner = P;
				Portal.XPPerScore = XPPerScore;
				PortalCount++;
			}
		}
		if (MMPI != None)
		{
			if (MMPI.Stopped || !MMPI.PortalBallActive || !MMPI.MasterMMPI)
			{
				Destroy();
			}
		}
	}
}

defaultproperties
{
	SpawnInterval=1.000000
	MaxPortalBalls=2
	MaxPortals=2
    bOnlyRelevantToOwner=False
    bAlwaysRelevant=True
    bReplicateInstigator=True
}
