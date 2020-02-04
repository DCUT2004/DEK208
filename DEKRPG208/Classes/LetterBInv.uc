class LetterBInv extends Inventory
	config(UT2004RPG);

var Controller InstigatorController;
var Pawn PawnOwner;
var RPGRules Rules;
var bool stopped;
var config float CheckInterval;

var transient DruidsRPGKeysInteraction InteractionOwner;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		stopped;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	CheckRPGRules();

	if (Instigator != None)
		InstigatorController = Instigator.Controller;
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

	stopped = false;
	if (InstigatorController == None)
		InstigatorController = Other.Controller;

	//want Instigator to be the one that caused the freeze
	OldInstigator = Instigator;
	Super.GiveTo(Other);
	PawnOwner = Other;

	Instigator = OldInstigator;

	SetTimer(CheckInterval, true);
}

simulated function Timer()
{
	local Controller C;
	local LetterBInv B;
	local LetterOInv O;
	local letterNInv N;
	local LetterUInv U;
	local LetterSInv S;
	local Pawn P;

	if(!stopped)
	{
		if (Instigator == None && InstigatorController != None)
			Instigator = InstigatorController.Pawn;
			
		if (Invasion(Level.Game) == None)
		{
			Destroy();
			return;
		}
		
		if (PawnOwner != None && PawnOwner.Health > 0)
		{
			for ( C = Level.ControllerList; C != None; C = C.NextController )
				if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.SameTeamAs(PawnOwner.Controller) && !C.Pawn.IsA('Monster') )
				{
					P = C.Pawn;
					if(P != None && P.isA('Vehicle'))
						P = Vehicle(P).Driver;
					if (P != None && P.Health > 0)
					{
						B = LetterBInv(P.FindInventoryType(class'LetterBInv'));
						if (B == None)
						{
							B = spawn(class'LetterBInv', P,,, rot(0,0,0));
							B.GiveTo(P);
						}
					}
				}
			O = LetterOInv(PawnOwner.FindInventoryType(class'LetterOInv'));
			N = LetterNInv(PawnOwner.FindInventoryType(class'LetterNInv'));
			U = LetterUInv(PawnOwner.FindInventoryType(class'LetterUInv'));
			S = LetterSInv(PawnOwner.FindInventoryType(class'LetterSInv'));
			if (Invasion(Level.Game) != None && O != None && N != None && U != None && S != None)
			{
				if (Invasion(Level.Game).FinalWave <= 16)
				{
					Invasion(Level.Game).FinalWave = 17;
					BroadcastLocalizedMessage(class'BonusWaveMessage');
					for ( C = Level.ControllerList; C != None; C = C.NextController )
						if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(PawnOwner.Controller) )
							PlayerController(C).ClientPlaySound(Sound'GameSounds.Fanfares.UT2k3Fanfare03');
				}
			}
		}
	}
}

function stopEffect()
{
	if(stopped)
		return;
	else
		stopped = true;
}

simulated function destroyed()
{
 	if( InteractionOwner != None )
 	{
 		InteractionOwner.BInv = None;
 		InteractionOwner = None;
 	}
	stopEffect();
	super.destroyed();
}

defaultproperties
{
     CheckInterval=1.000000
     PickupClass=Class'DEKRPG208.ArtifactLetterBPickup'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
