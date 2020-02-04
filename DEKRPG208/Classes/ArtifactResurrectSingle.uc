class ArtifactResurrectSingle extends EnhancedRPGArtifact
	config(UT2004RPG);

var RPGRules Rules;
var RPGStatsInv StatsInv;
var MutUT2004RPG RPGMut;
var() Controller Resurrecting;
var config float SacrificePerc;
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

	foreach Instigator.DynamicActors(class'Controller', player)
	{
		if((player.PlayerReplicationInfo != None) && (player.PlayerReplicationInfo.bOutOfLives == True) && (player.PlayerReplicationInfo.Team == Instigator.PlayerReplicationInfo.Team) && (player != Instigator) && (!player.PlayerReplicationInfo.bOnlySpectator))
		{
			controllers.Insert(0, 1);
			controllers[0] = player;
		}
	}

	if (controllers.length == 0)
	{
	  	Instigator.ReceiveLocalizedMessage(MessageClass,4000,None,None,class);
		return false;
	}

	if (PlayerController(Instigator.Controller) != None)
	{
		RevivePlayer(controllers[rand(controllers.Length)]); // let's pick a random dead person... creepy. Go to function RevivePlayer
		return true;
	}
}

function bool RevivePlayer(Controller player)
{	
	if (player.PlayerReplicationInfo.bOutOfLives == False)
	{
	  	Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, class);
		return false;
		GotoState('');
		bActive = false;
	}
	
	if( PlayerController(player) != None)
	{
		player.GotoState('PlayerWaiting');
	}
	
	Resurrecting = player;
	SetTimer(1.00,false);

	//Take off health and adrenaline.
	Instigator.Health -= (SacrificePerc * Instigator.Health);
	if (default.AdrenalineRequired != 0)
		Instigator.Controller.Adrenaline -= (AdrenalineRequired*AdrenalineUsage);
	if (Instigator.Controller.Adrenaline < 0)
		Instigator.Controller.Adrenaline = 0;
	
	//Play the revive FX.
	//Instigator.Spawn(class'ReviveEffectA', Instigator,, Instigator.Location, Instigator.Rotation);
	Instigator.Spawn(class'ReviveEffectB', Instigator,, Instigator.Location, Instigator.Rotation);
	Instigator.PlaySound(Sound'DDAverted', SLOT_None, 400.0);
	
	Instigator.ReceiveLocalizedMessage(class'ReviveMessage', 0, player.PlayerReplicationInfo);
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
	Destroy();			// was a one shot artifact
	Instigator.NextItem();
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
		
	else
		return switch @ "Adrenaline is required to use this artifact";
}

defaultproperties
{
     AdrenalineRequired=100
     SacrificePerc=0.500000
     XPForUse=15
     TimeBetweenUses=2.000000
     CostPerSec=1
     IconMaterial=Shader'DEKRPGTexturesMaster207P.Artifacts.ResurrectionWeaponMakerIconShader'
     ItemName="One Use Revive"
}
