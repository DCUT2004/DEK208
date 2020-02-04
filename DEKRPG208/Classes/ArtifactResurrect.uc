class ArtifactResurrect extends EnhancedRPGArtifact
	config(UT2004RPG);

var RPGRules Rules;
var RPGStatsInv StatsInv;
var MutUT2004RPG RPGMut;
var() Controller Resurrecting;
var Controller Revenant;
var PhantomDeathGhostInv PInv;
var class<DamageType> NecroDamageType;
var NecroInv Inv;
var config float XPMultiplier, SacrificePerc, RevenantLifeSpan;
var config int XPforUse;

replication
{
	reliable if (Role < ROLE_Authority)
		RevivePlayer;
}

function PostBeginPlay()
{
	local Mutator m;

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
	super.PostBeginPlay();
	disable('Tick');
	CheckRPGRules();
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

function activate()
{
	local Vehicle V;
	
	Super(EnhancedRPGArtifact).Activate();
	
	if ((Instigator != None) && (Instigator.Controller != None))
	{
		if (Instigator.Controller.Adrenaline < (AdrenalineRequired * AdrenalineUsage))
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, AdrenalineRequired*AdrenalineUsage, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		
		if (LastUsedTime  + (TimeBetweenUses*AdrenalineUsage) > Instigator.Level.TimeSeconds)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 5000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// cannot use yet
		}

		V = Vehicle(Instigator);
		if (V != None )
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// can't use in a vehicle
		}
		
		Apply(); //ok, so we have enough adren and we aren't in a vehicle. so far so good -- go to function Apply
	}
	bActive = false;
	GotoState('');
	return;
}	

function bool Apply()
{
	local Controller player;
	local Array<Controller> controllers;

	if (Instigator == None || Instigator.PlayerReplicationInfo == None)
	{
		return false;
	}

	foreach Instigator.DynamicActors(class'Controller', player)	//First, let's try human players
	{
		if ((player.PlayerReplicationInfo != None) && (player.PlayerReplicationInfo.Team == Instigator.PlayerReplicationInfo.Team) && (player != Instigator) && (!player.PlayerReplicationInfo.bOnlySpectator))
		{
			if (player.PlayerReplicationInfo.bOutOfLives)
			{
				if (!player.PlayerReplicationInfo.bBot)	//first, let's try to get a human player
				{
					controllers.Insert(0, 1);
					controllers[0] = player;
				}
			}
		}
	}
	
	if (controllers.length != 0) //We have some human players we can resurrect
	{
		if (PlayerController(Instigator.Controller) != None)
		{
			RevivePlayer(controllers[rand(controllers.Length)]);	//pick a random human player
			return true;
		}		
	}
	else	//No human players are out. Let's try bots
	{
		foreach Instigator.DynamicActors(class'Controller', player)
		{
			if ((player.PlayerReplicationInfo != None) && (player.PlayerReplicationInfo.Team == Instigator.PlayerReplicationInfo.Team) && (player != Instigator) && (!player.PlayerReplicationInfo.bOnlySpectator))
			{
				if (player.PlayerReplicationInfo.bOutOfLives)
				{
					if (player.PlayerReplicationInfo.bBot)
					{
						controllers.Insert(0, 1);
						controllers[0] = player;
					}
				}
			}
		}
		if (controllers.length != 0)	//we have some bots we can resurrect
		{
			if (PlayerController(Instigator.Controller) != None)
			{
				RevivePlayer(controllers[rand(controllers.Length)]);
				return true;
			}
		}
		else	//No one is out
		{
			Instigator.ReceiveLocalizedMessage(MessageClass,4000,None,None,class);
			return false;
		}
	}
}

function bool RevivePlayer(Controller player)
{	
	if (player.Pawn != None)
	{
		PInv = PhantomDeathGhostInv(player.Pawn.FindInventoryType(class'PhantomDeathGhostInv'));
		if (PInv != None)
		{
			//PInv.StopEffect();
			PInv.Resurrected();
			PInv.bResurrected = True;
			Zombify(player);
		}
		else
			//This person shouldn't have been chosen..
			return false;
	}
	else
	{
	
		if( PlayerController(player) != None)
		{
			player.GotoState('PlayerWaiting');
		}
		
		Resurrecting = player;
		SetTimer(1.00,false);
	}

	//Take off health and adrenaline.
	Instigator.Health -= (SacrificePerc * Instigator.Health);
	Instigator.Controller.Adrenaline -= (AdrenalineRequired*AdrenalineUsage);
	if (Instigator.Controller.Adrenaline < 0)
		Instigator.Controller.Adrenaline = 0;
	
	//Play the revive FX.
	Instigator.Spawn(class'ReviveEffectB', Instigator,, Instigator.Location, Instigator.Rotation);
	Instigator.PlaySound(Sound'DDAverted', SLOT_None, 400.0);
	
	Instigator.ReceiveLocalizedMessage(class'ReviveMessage', 0, player.PlayerReplicationInfo);
	
	Revenant = player;
		
	SetRecoveryTime(TimeBetweenUses*AdrenalineUsage);
	
	if ((XPforUse > 0) && (Rules != None))
	{
		Rules.ShareExperience(RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv')), XPforUse);
	}
}

function Timer()
{	
	if( Resurrecting == None)
	{
		GotoState('');
		bActive = false;
		return;
	}

	Resurrecting.PlayerReplicationInfo.bOutOfLives = false;
	Resurrecting.PlayerReplicationInfo.NumLives = 0;

	Level.Game.ReStartPlayer(Resurrecting);
	Resurrecting.ServerGivePawn();
	if( Resurrecting.Pawn == None )
	{
		GotoState('');
		bActive = false;
		return;
	}

	if ( PlayerController(Resurrecting) != None )
	{
	    PlayerController(Resurrecting).PlayerReplicationInfo.SetWaitingPlayer(false);
		PlayerController(Resurrecting).ClientSetViewTarget(Resurrecting.Pawn);
		PlayerController(Resurrecting).ClientSetBehindView(false);
	}
	
	if (Resurrecting.Pawn != None)
	{
		Zombify(Resurrecting);
	}
}

function Zombify(Controller Revenant)
{	
	Inv = NecroInv(Revenant.Pawn.FindInventoryType(class'NecroInv'));
	if(Inv == None)
	{
		Inv = spawn(class'NecroInv', Revenant.Pawn,,, rot(0,0,0));
		Inv.NecromancerController = Instigator.Controller;
		Inv.LifeSpan = RevenantLifeSpan;
		Inv.XPMultiplier = XPMultiplier;
		Inv.GiveTo(Revenant.Pawn);
		if (PInv != None)
			Inv.PhantomDeath = True;
		else
			Inv.PhantomDeath = False;
	}
}

exec function TossArtifact()
{
	//do nothing. This artifact cant be thrown
}

function DropFrom(vector StartLocation)
{
	if (bActive)
		GotoState('');
	bActive = false;

	Destroy();
	Instigator.NextItem();
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle.";
	else if (Switch == 4000)
		return "No one is dead to resurrect.";
	else if (Switch == 5000)
		return "Cannot resurrect again until cool down.";
	else if (Switch == 8000)
		return "You can only resurrect as a phantom!";
	else
		return switch @ "Adrenaline is required to use this artifact";
}

defaultproperties
{
     NecroDamageType=Class'DEKRPG208.DamTypeNecro'
     AdrenalineRequired=150
     XPMultiplier=1.000000
     SacrificePerc=0.500000
     RevenantLifeSpan=20.000000
     XPForUse=15
     TimeBetweenUses=2.000000
     CostPerSec=1
     IconMaterial=Shader'DEKRPGTexturesMaster207P.Artifacts.ResurrectionWeaponMakerIconShader'
     ItemName="Resurrection"
}
