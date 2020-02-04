class MissionMultiplayerInv extends Inventory
	config(UT2004RPG);

var Controller InstigatorController;
var Pawn PawnOwner;
var MutUT2004RPG RPGMut;
var RPGRules Rules;
var bool stopped;	//signifies whether a mission is paused or active.

var int MissionCount;		//set by ability.
var int MissionGoal;	//set by artifact.
var int MissionXP;		//set by artifact.
var localized string MissionName;
var localized string Description;
var config float CheckInterval;
var Pawn MMPIOwner;		//Pawn controlling the team mission for everyone
var bool MasterMMPI;	//True if this inventory controls the team mission for everyone
var int MissionClock;		//internal system for tracking time. Used in conjunction with TimeLimit.
var int TimeRemaining;
var config int Countdown;		//the time for players to prepare before the mission/minigame actually starts.
var int TimeLimit;	//time that mission or minigame must be completed by. Used in conjunction with MissionClock.
var config int ExpForWinAdd;
var bool RewardGranted;

var bool PowerPartyActive;
var bool TarydiumKeepActive;
var bool BalloonPopActive;
var bool RingAndHoldActive;
var bool GenomeProjectActive;
var bool MusicalWeaponsActive;
var bool CoinGrabActive;
var bool PortalBallActive;

//Tarydium Keep Variables
var TarydiumCrystal TC;
var int TCHealth;

//Ring and Hold Variables
var RingRed RR;
var RingBlue RB;
var RingGold RG;
var bool RRActive, RBActive, RGActive;

//Genome Project Variables
var GenomeProjectNode GPN;
var config int GenomeXPPerVial;

//Musical Weapons Variables
var config float MusicalChangeChance;	// % chance per CheckInterval the required weapon changes
var config int MusicalMinimumTime;	//how long in seconds a weapon should remain once changed. Prevents constant switching
var bool AVRiLActive;
var bool BioActive;
var bool ShockActive;
var bool LinkActive;
var bool MinigunActive;
var bool FlakActive;
var bool RocketActive;
var bool LightningActive;

//Coin Grab Variables
var config int CoinGrabXPPerCoin;

var transient DruidsRPGKeysInteraction InteractionOwner;

#exec  AUDIO IMPORT NAME="MP3VoiceDraw" FILE="C:\UT2004\Sounds\MP3VoiceDraw.WAV" GROUP="MissionSounds"
#exec  AUDIO IMPORT NAME="MP3VoiceFinish" FILE="C:\UT2004\Sounds\MP3VoiceFinish.WAV" GROUP="MissionSounds"
#exec  AUDIO IMPORT NAME="MP3VoiceStart" FILE="C:\UT2004\Sounds\MP3VoiceStart.WAV" GROUP="MissionSounds"
#exec  AUDIO IMPORT NAME="MP3VoiceTimeUp" FILE="C:\UT2004\Sounds\MP3VoiceTimeUp.WAV" GROUP="MissionSounds"

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		Stopped, MissionName, Description, MMPIOwner, MasterMMPI, MissionCount, MissionGoal, MissionXP, MissionClock, TimeRemaining, Countdown, TimeLimit, RewardGranted, PowerPartyActive, TarydiumKeepActive, TC, TCHealth, BalloonPopActive, RingAndHoldActive, RRActive, RBActive, RGActive, GenomeProjectActive, MusicalWeaponsActive, CoinGrabActive, PortalBallActive, AVRiLActive, BioActive, ShockActive, LinkActive, MinigunActive, FlakActive, RocketActive, LightningActive;
}

simulated function PostBeginPlay()
{
	local Mutator M;

	Super.PostBeginPlay();

	if (Instigator != None)
		InstigatorController = Instigator.Controller;

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
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

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local Pawn OldInstigator;

	if(Other == None)
	{
		destroy();
		return;
	}
	if (Invasion(Level.Game) == None)
	{
		Destroy();
		return;
	}

	stopped = true;
	if (InstigatorController == None)
		InstigatorController = Other.Controller;

	OldInstigator = Instigator;
	Super.GiveTo(Other);
	PawnOwner = Other;
	Instigator = OldInstigator;
	
	stopped = true;
	SetTimer(0, False);
	MMPIOwner = None;
	MasterMMPI = False;
	MissionCount = 0;
	MissionGoal = 0;
	MissionXP = 0;
	MissionClock = 0;
	TimeRemaining = 0;
	Countdown = default.Countdown;
	RewardGranted = False;
	PowerPartyActive = False;
	TarydiumKeepActive = False;
	BalloonPopActive = False;
	RingAndHoldActive = False;
	GenomeProjectActive = False;
	MusicalWeaponsActive = False;
	CoinGrabActive = False;
	PortalBallActive = False;
}

//The only person with a timer running is the team mission handler, set by the team mission artifact.
simulated function Timer()
{
	local Controller C, NextC;
	local Pawn P;
	local MissionMultiplayerInv MMPI;
	
	if(!stopped)
	{
		if (PawnOwner == None || PawnOwner.Health <= 0)
		{
			StopMission();
			Destroy();
		}
		else if (PawnOwner != None && PawnOwner.Health > 0)
		{
			Countdown--;	//start the countdown to commence mission/minigame. This gives players time to prepare and read the objective.
			if (Countdown == 0)
			{
				for ( C = Level.ControllerList; C != None; C = C.NextController )
					if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(PawnOwner.Controller) )
						PlayerController(C).ClientPlaySound(Sound'DEKRPG208.MissionSounds.MP3VoiceStart');
				Level.Game.Broadcast(self, "Start!");
			}
			else if (Countdown > 0)	//still counting down to start minigame/mission.
			{
				if (MissionCount > 0)
					MissionCount = 0;
				if (TC != None)
				{
					TC.Health = TC.default.HealthMax;
					TCHealth = TC.default.HealthMax;
				}
			}
			else if (MissionClock >= TimeLimit && MissionClock != 0)
			{
				for ( C = Level.ControllerList; C != None; C = C.NextController )
					if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(PawnOwner.Controller) )
						PlayerController(C).ClientPlaySound(Sound'DEKRPG208.MissionSounds.MP3VoiceTimeUp');
				if (GenomeProjectActive)
				{
					if (MissionCount > 0)
						GenomeProjectComplete();
					else
						StopMission();
				}
				else if (CoinGrabActive)
				{
					if (MissionCount > 0)
						CoinGrabComplete();
					else
						StopMission();
				}
				else
					StopMission();
			}
			else
			{
				MissionClock++;	//mission/minigame has started. Start the time limit and allow mission counts to accrue.
				TimeRemaining = (TimeLimit - MissionClock);
			}
			if (TarydiumKeepActive)
			{
				if (TC != None)
					TCHealth = TC.Health;
				if (TC == None || TC.Health <= 0)
				{
					StopMission();
				}
			}
			if (RingAndHoldActive)
			{
				if (RR != None)
				{
					if (RR.CheckRadius())
						RRActive = True;
					else
						RRActive = False;
				}
				if (RB != None)
				{
					if (RB.CheckRadius())
						RBActive = True;
					else
						RBActive = False;
				}
				if (RG != None)
				{
					if (RG.CheckRadius())
						RGActive = True;
					else
						RGActive = False;
				}
			}
			if (MusicalWeaponsActive)
			{
				if ( Rand(99) <= MusicalChangeChance)	//Time to switch a weapon.
				{
					if (Rand(99) <= 12.5)	//Set AVRiL
					{
						AVRiLActive = True;
						BioActive = False;
						ShockActive = False;
						LinkActive = False;
						MinigunActive = False;
						FlakActive = False;
						RocketActive = False;
						LightningActive = False;
					}
					else if (Rand(99) <= 25)	//Set Bio
					{
						AVRiLActive = False;
						BioActive = True;
						ShockActive = False;
						LinkActive = False;
						MinigunActive = False;
						FlakActive = False;
						RocketActive = False;
						LightningActive = False;
					}
					else if (Rand(99) <= 37.5)	//Set Shock
					{
						AVRiLActive = False;
						BioActive = False;
						ShockActive = True;
						LinkActive = False;
						MinigunActive = False;
						FlakActive = False;
						RocketActive = False;
						LightningActive = False;
					}
					else if (Rand(99) <= 50)	//Set Link
					{
						AVRiLActive = False;
						BioActive = False;
						ShockActive = False;
						LinkActive = True;
						MinigunActive = False;
						FlakActive = False;
						RocketActive = False;
						LightningActive = False;
					}
					else if (Rand(99) <= 62.5)	//Set Mini
					{
						AVRiLActive = False;
						BioActive = False;
						ShockActive = False;
						LinkActive = False;
						MinigunActive = True;
						FlakActive = False;
						RocketActive = False;
						LightningActive = False;
					}
					else if (Rand(99) <= 75)	//Set Flak
					{
						AVRiLActive = False;
						BioActive = False;
						ShockActive = False;
						LinkActive = False;
						MinigunActive = False;
						FlakActive = True;
						RocketActive = False;
						LightningActive = False;
					}
					else if (Rand(99) <= 87.5)	//Set Rocket
					{
						AVRiLActive = False;
						BioActive = False;
						ShockActive = False;
						LinkActive = False;
						MinigunActive = False;
						FlakActive = False;
						RocketActive = True;
						LightningActive = False;
					}
					else	//Set Lightning
					{
						AVRiLActive = False;
						BioActive = False;
						ShockActive = False;
						LinkActive = False;
						MinigunActive = False;
						FlakActive = False;
						RocketActive = False;
						LightningActive = True;
					}
				}
			}
		
			//Any time someone joins during a team mission, "unlock" their MMPI and set the current team mission.
			C = Level.ControllerList;
			while (C != None)
			{
				NextC = C.NextController;
				if(C == None)
				{
					C = NextC;
					break;
				}
		
				if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn != PawnOwner)
				{
					P = C.Pawn;
					if(P != None && P.isA('Vehicle'))
						P = Vehicle(P).Driver;
					if (P != None && P != PawnOwner && (P.GetTeam() == PawnOwner.GetTeam() && PawnOwner.GetTeam() != None) )
						MMPI = MissionMultiplayerInv(P.FindInventoryType(class'MissionMultiplayerInv'));
					if (MMPI != None)
					{
						MMPI.MMPIOwner = MMPIOwner;
						MMPI.MasterMMPI = False;
						MMPI.MissionName = MissionName;
						MMPI.TimeLimit = TimeLimit;
						MMPI.MissionCount = MissionCount;
						MMPI.TimeRemaining = TimeRemaining;
						MMPI.MissionGoal = MissionGoal;
						if (Countdown <= 0)
							MMPI.stopped = False;
						if (PowerPartyActive)
							MMPI.PowerPartyActive = True;
						if (TarydiumKeepActive)
						{
							MMPI.TarydiumKeepActive = True;
							MMPI.TC = TC;
						}
						if (BalloonPopActive)
							MMPI.BalloonPopActive = True;
						if (RingAndHoldActive)
						{
							MMPI.RingAndHoldActive = True;
							if (RRActive)
								MMPI.RRActive = True;
							else
								MMPI.RRActive = False;
							if (RBActive)
								MMPI.RBActive = True;
							else
								MMPI.RBActive = False;
							if (RGActive)
								MMPI.RGActive = True;
							else
								MMPI.RGActive = False;
						}
						if (GenomeProjectActive)
							MMPI.GenomeProjectActive = True;
						if (MusicalWeaponsActive)
						{
							MMPI.MusicalWeaponsActive = True;
							if (AVRiLActive)
							{
								MMPI.AVRiLActive = True;
								MMPI.BioActive = False;
								MMPI.ShockActive = False;
								MMPI.LinkActive = False;
								MMPI.MinigunActive = False;
								MMPI.FlakActive = False;
								MMPI.RocketActive = False;
								MMPI.LightningActive = False;
							}
							if (BioActive)
							{
								MMPI.AVRiLActive = False;
								MMPI.BioActive = True;
								MMPI.ShockActive = False;
								MMPI.LinkActive = False;
								MMPI.MinigunActive = False;
								MMPI.FlakActive = False;
								MMPI.RocketActive = False;
								MMPI.LightningActive = False;
							}
							if (ShockActive)
							{
								MMPI.AVRiLActive = False;
								MMPI.BioActive = False;
								MMPI.ShockActive = True;
								MMPI.LinkActive = False;
								MMPI.MinigunActive = False;
								MMPI.FlakActive = False;
								MMPI.RocketActive = False;
								MMPI.LightningActive = False;
							}
							if (LinkActive)
							{
								MMPI.AVRiLActive = False;
								MMPI.BioActive = False;
								MMPI.ShockActive = False;
								MMPI.LinkActive = True;
								MMPI.MinigunActive = False;
								MMPI.FlakActive = False;
								MMPI.RocketActive = False;
								MMPI.LightningActive = False;
							}
							if (MinigunActive)
							{
								MMPI.AVRiLActive = False;
								MMPI.BioActive = False;
								MMPI.ShockActive = False;
								MMPI.LinkActive = False;
								MMPI.MinigunActive = True;
								MMPI.FlakActive = False;
								MMPI.RocketActive = False;
								MMPI.LightningActive = False;
							}
							if (FlakActive)
							{
								MMPI.AVRiLActive = False;
								MMPI.BioActive = False;
								MMPI.ShockActive = False;
								MMPI.LinkActive = False;
								MMPI.MinigunActive = False;
								MMPI.FlakActive = True;
								MMPI.RocketActive = False;
								MMPI.LightningActive = False;
							}
							if (RocketActive)
							{
								MMPI.AVRiLActive = False;
								MMPI.BioActive = False;
								MMPI.ShockActive = False;
								MMPI.LinkActive = False;
								MMPI.MinigunActive = False;
								MMPI.FlakActive = False;
								MMPI.RocketActive = True;
								MMPI.LightningActive = False;
							}
							if (LightningActive)
							{
								MMPI.AVRiLActive = False;
								MMPI.BioActive = False;
								MMPI.ShockActive = False;
								MMPI.LinkActive = False;
								MMPI.MinigunActive = False;
								MMPI.FlakActive = False;
								MMPI.RocketActive = False;
								MMPI.LightningActive = True;
							}
						}
						if (CoinGrabActive)
							MMPI.CoinGrabActive = True;
						if (PortalBallActive)
							MMPI.PortalBallActive = True;
					}
				}
				C = NextC;
			}	
			if ( MasterMMPI && MissionCount != 0 && MissionGoal != 0 && MissionCount >= MissionGoal)	//Mission complete. Stop timer and reward players.
			{
				if (!RewardGranted)
					MissionComplete();
				else	//Player must be ghosting and this function is getting repeatedly called
					StopMission();
			}
		}
	}
	else
		return;
}

static function UpdateCounts(int Count)
{
	local MissionMultiplayerInv MMPI;
	local Pawn P;
	local Vehicle V;
	
	P = default.MMPIOwner;
	
	if (P.DrivenVehicle != None)
		V = Vehicle(P);
	
	if (P != None && V != None)
		P = V.Driver;	
	
	if (P != None && P.Health > 0)
	{
		MMPI = MissionMultiplayerInv(P.FindInventoryType(class'MissionMultiplayerInv'));
		if ( MMPI != None && !MMPI.Stopped && MMPI.MasterMMPI)
			MMPI.MissionCount += Count;
	}
}

simulated function StopMission()
{
	local Controller C, NextC;
	local Pawn P;
	local MissionMultiplayerInv MMPI;
	
	if (!RewardGranted)
	{
		if (TarydiumKeepActive)
			Level.Game.Broadcast(self, "Tarydium destroyed! Team mission failed.");
		else
			Level.Game.Broadcast(self, "Team mission failed.");
	}
	
	C = Level.ControllerList;
	while (C != None)
	{
		NextC = C.NextController;
	
		if(C == None)
		{
			C = NextC;
			break;
		}
		
		if (C != None && C.Pawn != None && C.Pawn.Health > 0)
		{
			P = C.Pawn;
			if(P != None && P.isA('Vehicle'))
				P = Vehicle(P).Driver;
			if (P != None && (P.GetTeam() == PawnOwner.GetTeam() && PawnOwner.GetTeam() != None) )
				MMPI = MissionMultiplayerInv(P.FindInventoryType(class'MissionMultiplayerInv'));
			if (MMPI != None)
			{
				MMPI.StopEffect();
			}
		}
		C = NextC;
	}
}

simulated function TeamMissionBroadcast()
{
	Level.Game.Broadcast(self, "Team mission started: " $ MissionName $ ". " $ Description $ " Reward: " $ MissionXP $ "XP.");
	Level.Game.Broadcast(self, "10 seconds to start...");
}

simulated function TeamMissionGenomeBroadcast()
{
	Level.Game.Broadcast(self, "Team mission started: " $ MissionName $ ". " $ Description $ " Reward: " $ GenomeXPPerVial $ "XP per vial.");
	Level.Game.Broadcast(self, "10 seconds to start...");
}

simulated function MissionComplete()
{
	local Controller C, NextC;
	local Pawn P;
	local MissionMultiplayerInv MMPI;
	
	Level.Game.Broadcast(self, "" $ MissionName $ " complete! +" $ MissionXP $ " XP.");
	Level.Game.Broadcast(self, "+" $ ExpForWinAdd $ " end of game XP.");
	
	RewardGranted = True;
	
	if (RPGMut != None)
	{
		RPGMut.EXPForWin += default.EXPForWinAdd;
	}
	
	C = Level.ControllerList;
	while (C != None)
	{
		NextC = C.NextController;
	
		if(C == None)
		{
			C = NextC;
			break;
		}
		
		if (C != None && C.Pawn != None && C.Pawn.Health > 0)
		{
			P = C.Pawn;
			if(P != None && P.isA('Vehicle'))
				P = Vehicle(P).Driver;
			if (P != None && (P.GetTeam() == PawnOwner.GetTeam() && PawnOwner.GetTeam() != None) )
				MMPI = MissionMultiplayerInv(P.FindInventoryType(class'MissionMultiplayerInv'));
			if (MMPI != None)
			{
				if ((MissionXP > 0) && (Rules != None))
				{
					Rules.ShareExperience(RPGStatsInv(P.FindInventoryType(class'RPGStatsInv')), MissionXP);
				}
				MMPI.StopEffect();
				MMPI.SetTimer(0, False);
			if (PlayerController(C) != None)
				PlayerController(C).ClientPlaySound(Sound'DEKRPG208.MissionSounds.MP3VoiceFinish');
			}
		}
		C = NextC;
	}
	if (TC != None)
		TC.Destroy();
	if (RR != None)
		RR.Destroy();
	if (RB != None)
		RB.Destroy();
	if (RG != None)
		RG.Destroy();
	if (GPN != None)
		GPN.Destroy();
}

simulated function GenomeProjectComplete()
{
	local Controller C, NextC;
	local Pawn P;
	local MissionMultiplayerInv MMPI;
	
	Level.Game.Broadcast(self, "" $ MissionName $ ": +" $ (MissionCount*GenomeXPPerVial) $ " XP.");
	
	RewardGranted = True;
	
	C = Level.ControllerList;
	while (C != None)
	{
		NextC = C.NextController;
	
		if(C == None)
		{
			C = NextC;
			break;
		}
		
		if (C != None && C.Pawn != None && C.Pawn.Health > 0)
		{
			P = C.Pawn;
			if(P != None && P.isA('Vehicle'))
				P = Vehicle(P).Driver;
			if (P != None && (P.GetTeam() == PawnOwner.GetTeam() && PawnOwner.GetTeam() != None) )
				MMPI = MissionMultiplayerInv(P.FindInventoryType(class'MissionMultiplayerInv'));
			if (MMPI != None)
			{
				if ((MissionXP > 0) && (Rules != None))
				{
					Rules.ShareExperience(RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv')), (MissionCount*GenomeXPPerVial));
				}
				MMPI.StopEffect();
				MMPI.SetTimer(0, False);
			}
		}
		C = NextC;
	}
	if (RPGMut != None)
	{
		RPGMut.EXPForWin += default.EXPForWinAdd;
	}
	if (GPN != None)
		GPN.Destroy();
}

simulated function CoinGrabComplete()
{
	local Controller C, NextC;
	local Pawn P;
	local MissionMultiplayerInv MMPI;
	
	Level.Game.Broadcast(self, "" $ MissionName $ ": +" $ (MissionCount*CoinGrabXPPerCoin) $ " XP.");
	
	RewardGranted = True;
	
	C = Level.ControllerList;
	while (C != None)
	{
		NextC = C.NextController;
	
		if(C == None)
		{
			C = NextC;
			break;
		}
		
		if (C != None && C.Pawn != None && C.Pawn.Health > 0)
		{
			P = C.Pawn;
			if(P != None && P.isA('Vehicle'))
				P = Vehicle(P).Driver;
			if (P != None && (P.GetTeam() == PawnOwner.GetTeam() && PawnOwner.GetTeam() != None) )
				MMPI = MissionMultiplayerInv(P.FindInventoryType(class'MissionMultiplayerInv'));
			if (MMPI != None)
			{
				if ((MissionXP > 0) && (Rules != None))
				{
					Rules.ShareExperience(RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv')), (MissionCount*CoinGrabXPPerCoin));
				}
				MMPI.StopEffect();
				MMPI.SetTimer(0, False);
			}
		}
		C = NextC;
	}
	if (RPGMut != None)
	{
		RPGMut.EXPForWin += default.EXPForWinAdd;
	}
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 1000)
		return "Start!";
	else if (Switch == 2000)
		return "Time up! Team mission failed.";
	else if (Switch == 3000)
		return "Tarydium destroyed! Team mission failed.";
}

function stopEffect()
{
	local Pawn P;
	
	P = PawnOwner;
	if(P != None && P.isA('Vehicle'))
		P = Vehicle(P).Driver;
	if (P != None)
	{
		stopped = true;
		SetTimer(0, False);
		MMPIOwner = None;
		MasterMMPI = False;
		MissionCount = 0;
		MissionGoal = 0;
		MissionXP = 0;
		MissionClock = 0;
		TimeRemaining = 0;
		Countdown = default.Countdown;
		RewardGranted = False;
		PowerPartyActive = False;
		TarydiumKeepActive = False;
		BalloonPopActive = False;
		RingAndHoldActive = False;
		GenomeProjectActive = False;
		MusicalWeaponsActive = False;
		CoinGrabActive = False;
		PortalBallActive = False;
		AVRiLActive = False;
		BioActive = False;
		ShockActive = False;
		LinkActive = False;
		MinigunActive = False;
		FlakActive = False;
		RocketActive = False;
		LightningActive = False;
		if (TC != None)
			TC.Destroy();
		if (RR != None)
			RR.Destroy();
		if (RB != None)
			RB.Destroy();
		if (RG != None)
			RG.Destroy();
		if (GPN != None)
			GPN.Destroy();
	}
}
simulated function destroyed()
{
	local Controller C, NextC;
	local Pawn P;
	local MissionMultiplayerInv MMPI;
	
 	if( InteractionOwner != None )
 	{
 		InteractionOwner.MMPI = None;
 		InteractionOwner = None;
 	}
	
	if (MasterMMPI)
	{
		C = Level.ControllerList;
		while (C != None)
		{
			NextC = C.NextController;
	
			if(C == None)
			{
				C = NextC;
				break;
			}
		
			if (C != None && C.Pawn != None && C.Pawn.Health > 0)
			{
				P = C.Pawn;
				if(P != None && P.isA('Vehicle'))
					P = Vehicle(P).Driver;
				if (P != None && (P.GetTeam() == PawnOwner.GetTeam() && PawnOwner.GetTeam() != None) )
					MMPI = MissionMultiplayerInv(P.FindInventoryType(class'MissionMultiplayerInv'));
				if (MMPI != None)
				{
					MMPI.StopEffect();
				}
			}
			C = NextC;
		}
	}
	super.destroyed();
}

defaultproperties
{
	 MusicalChangeChance=10
	 MusicalMinimumTime=5
     CheckInterval=1.000000
	 Countdown=10
	 ExpForWinAdd=10
	 GenomeXPPerVial=5
     MessageClass=Class'UnrealGame.StringMessagePlus'
}