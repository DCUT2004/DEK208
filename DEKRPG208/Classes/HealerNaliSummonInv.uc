class HealerNaliSummonInv extends Inventory;

var Controller InstigatorController;
var Pawn PawnOwner;
var RPGRules Rules;
var bool stopped, ActiveNali;	//signifies whether a mission is paused or active.
var config float CheckInterval;
var HealerNaliSummon Nali;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		stopped, ActiveNali;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	CheckRPGRules();

	if (Instigator != None)
		InstigatorController = Instigator.Controller;
		
	SetTimer(CheckInterval, true);
}

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}
	}

	if(Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local Pawn OldInstigator;

	if(Other == None)
	{
		destroy();
		return;
	}

	stopped = true;
	if (InstigatorController == None)
		InstigatorController = Other.Controller;

	//want Instigator to be the one that caused the freeze
	OldInstigator = Instigator;
	Super.GiveTo(Other);
	PawnOwner = Other;

	Instigator = OldInstigator;
	
	ActiveNali = False;
}

function vector getSpawnLocation(Class<Monster> ChosenMonster)
{
	local float Dist, BestDist;
	local vector SpawnLocation;
	local NavigationPoint N, BestDest;

	BestDist = 50000.f;
	for (N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint)
	{
		Dist = VSize(N.Location - PawnOwner.Location);
		if (Dist < BestDist && Dist > ChosenMonster.default.CollisionRadius * 2)
		{
			BestDest = N;
			BestDist = VSize(N.Location - PawnOwner.Location);
		}
	}

	if (BestDest != None)
		SpawnLocation = BestDest.Location + (ChosenMonster.default.CollisionHeight - BestDest.CollisionHeight) * vect(0,0,1);
	else
		SpawnLocation = PawnOwner.Location + ChosenMonster.default.CollisionHeight * vect(0,0,1.5); //is this why monsters spawn on heads?

	return SpawnLocation;	
}

function rotator getSpawnRotator(Vector SpawnLocation)
{
	local rotator SpawnRotation;

	SpawnRotation.Yaw = rotator(SpawnLocation - Instigator.Location).Yaw;
	return SpawnRotation;
}

function Timer()
{
	Local Vector SpawnLocation;
	local rotator SpawnRotation;
	
	SpawnLocation = getSpawnLocation(class'HealerNali');
	SpawnRotation = getSpawnRotator(SpawnLocation);
	
	if (!ActiveNali)
		Nali = Spawn(class'HealerNaliSummon',PawnOwner,,SpawnLocation, SpawnRotation);
	
	if (Nali != None)
	{
		ActiveNali = True;
		stopped = False;
	}
	else
	{
		stopped = True;
		ActiveNali = False;
	}
}



defaultproperties
{
	CheckInterval=10.000
}
