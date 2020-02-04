class PaladinInv extends Inventory;

var Controller InstigatorController;
var Controller GuardianController;
var Pawn PawnOwner;
var RPGRules Rules;
var bool bInvulReady;
var config int AdrenalineRequired;
var int Counter;
var config int TimeBetweenInvul;
var PaladinMarker Marker;
var int PlayerHealth;
var ArtifactPaladin AP;
var float ExpPerDamage;
var config int InvulTime;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		GuardianController, bInvulReady;
}

simulated function PostBeginPlay()
{
	if (Instigator != None)
		InstigatorController = Instigator.Controller;
	CheckRPGRules();
		
	Super.PostBeginPlay();
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

	if (InstigatorController == None)
		InstigatorController = Other.Controller;
		
		if (Instigator == None && InstigatorController != None)
			Instigator = InstigatorController.Pawn;

	//want Instigator to be the one that caused the freeze
	OldInstigator = Instigator;
	Super.GiveTo(Other);
	PawnOwner = Other;

	Instigator = OldInstigator;
	
	if (GuardianController.Pawn != None)
	{
		Marker = PawnOwner.spawn(class'PaladinMarker',GuardianController.Pawn,,PawnOwner.Location,PawnOwner.Rotation);
		if (Marker != None)
		{
			Marker.SetBase(PawnOwner);
			Marker.RemoteRole = ROLE_SimulatedProxy;
		}
		AP = ArtifactPaladin(GuardianController.Pawn.FindInventoryType(class'ArtifactPaladin'));
		if (AP != None)
		{
			AP.TargetChosen = True;
			AP.TargetPlayer = PawnOwner;
		}
	}
	if (PawnOwner != None)
		PawnOwner.ReceiveLocalizedMessage(class'PaladinGrantedMessage', 0, GuardianController.PlayerReplicationInfo);
	Counter = 10;
	PlayerHealth = PawnOwner.Health;  // save as reference
	SetTimer(1.0, true);
}

simulated function Timer()
{	
	if (PawnOwner == None || PawnOwner.Health <= 0)
	{
		PlayerController(GuardianController).ReceiveLocalizedMessage(class'PaladinRemoveMessage', 1);
		Destroy();
		return;
	}
	if (GuardianController.PlayerReplicationInfo != None && GuardianController.PlayerReplicationInfo.bOutofLives)
	{
		PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'PaladinRemoveMessage', 0);
		Destroy();
		return;
	}
	Counter++;
	if (Counter >= default.TimeBetweenInvul)
		bInvulReady = True;
	else
		bInvulReady = False;
}

function stopEffect()
{
	if (Marker != None)
		Marker.Destroy();
	if (AP != None)
	{
		AP.TargetChosen = False;
		AP.TargetPlayer = None;
	}
	if (GuardianController.Pawn != None && GuardianController.Pawn.Health > 0)
		PlayerController(GuardianController).ReceiveLocalizedMessage(class'PaladinRemoveMessage', 1);
}

function destroyed()
{
	stopEffect();
	super.destroyed();
}

defaultproperties
{
	 InvulTime=7	//How long, once a player is saved from death, invul lasts on them. TimeBetweenInvul - InvulTime = vulnerable time for player
     AdrenalineRequired=200
	 TimeBetweenInvul=12	//time in seconds after this player is saved that the player can next be saved
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
