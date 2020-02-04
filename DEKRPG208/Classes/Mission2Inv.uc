class Mission2Inv extends Inventory
	config(UT2004RPG);

var Controller InstigatorController;
var Pawn PawnOwner;
var RPGRules Rules;
var bool stopped;	//signifies whether a mission is paused or active.

var MissionInv Inv;
var int MissionCount;		//set by ability.
var int MissionGoal;	//set by artifact.
var int MissionXP;		//set by artifact.
var localized string MissionName;
var config float CheckInterval;

var LetterBInv BInv;
var LetterOInv OInv;
var LetterNInv NInv;
var LetterUInv UInv;
var LetterSInv SInv;

var NullEntropyInv Null;
var SuperHeatInv Heat;
var FreezeInv Freeze;
var KnockbackInv Knockback;
var DruidPoisonInv Poison;

var ArtifactMaxModifier RewardWizardry;
var HealerNaliSummonInv RewardLifeMend;
var ArtifactSummonSkaarj RewardSkaarjHunt;
var ArtifactSummonWarlord RewardWarlordHunt;
var ArtifactSummonSkeleton RewardBoneCrusher;
var ArtifactResurrectSingle RewardGhostBuster;
var ThunderGodInv RewardThunderGod;
var DroneOneInv RewardNaniteCrash;
var ArtifactPriestMagnet RewardStarHunt;

var bool AngerManagementActive;
var bool PyromancerActive;
var bool FrostmancerActive;
var bool AquamanActive;
var bool AVRiLAmityActive;
var bool BioBerserkActive;
var bool BoneCrusherActive;
var bool BugHuntActive;
var bool DeflectorActive;
var bool DisarmerActive;
var bool FlakFrenzyActive;
var bool GhostBusterActive;
var bool GlacialHuntActive;
var bool HexedActive;
var bool LifeMendActive;
var bool LinkLunaticActive;
var bool MightyLightningActive;
var bool MinigunMayhemActive;
var bool NaniteCrashActive;
var bool NullmancerActive;
var bool PopActive;
var bool RocketRageActive;
var bool RootedStanceActive;
var bool SharpShotFlyActive;
var bool ShockSlaughterActive;
var bool SkaarjHuntActive;
var bool SpidermanActive;
var bool StarHuntActive;
var bool SupermanActive;
var bool ThunderGodActive;
var bool UtilityMutilityActive;
var bool VolcanicHuntActive;
var bool WarlordHuntActive;
var bool WizardryActive;
var bool ZombieSlayerActive;
var bool FeatherweightActive;
var bool EmeraldShatterActive;
var bool KrallHuntActive;
var bool HaltActive;

var config int HexDamage;
var config float RegenRewardAmount;
var Translauncher Trans;
var DruidArtifactFlight Boots;

var transient DruidsRPGKeysInteraction InteractionOwner;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		Stopped, MissionName, MissionCount, MissionGoal, MissionXP, AngerManagementActive, PyromancerActive, FrostmancerActive, AquamanActive, AVRiLAmityActive, BioBerserkActive, BoneCrusherActive, BugHuntActive, DeflectorActive, DisarmerActive, FlakFrenzyActive, GhostBusterActive, GlacialHuntActive, HexedActive, LifeMendActive, LinkLunaticActive, MightyLightningActive, MinigunMayhemActive, NaniteCrashActive, NullmancerActive, PopActive, RocketRageActive, RootedStanceActive, SharpShotFlyActive, ShockSlaughterActive, SkaarjHuntActive, SpidermanActive, StarHuntActive, SupermanActive, ThunderGodActive, UtilityMutilityActive, VolcanicHuntActive, WarlordHuntActive, WizardryActive, ZombieSlayerActive, FeatherweightActive, EmeraldShatterActive, KrallHuntActive, HaltActive;
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
	
	if (Invasion(Level.Game) == None)
	{
		Destroy();
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
	
	Inv = MissionInv(PawnOwner.FindInventoryType(class'MissionInv'));
	
	MissionCount = 0;
	
	AngerManagementActive = False;
	PyromancerActive = False;
	FrostmancerActive = False;
	AquamanActive = False;
	AVRiLAmityActive = False;
	BioBerserkActive = False;
	BoneCrusherActive = False;
	BugHuntActive = False;
	DeflectorActive = False;
	DisarmerActive = False;
	FlakFrenzyActive = False;
	GhostBusterActive = False;
	GlacialHuntActive = False;
	HexedActive = False;
	LifeMendActive = False;
	LinkLunaticActive = False;
	MightyLightningActive = False;
	MinigunMayhemActive = False;
	NaniteCrashActive = False;
	NullmancerActive = False;
	PopActive = False;
	RocketRageActive = False;
	RootedStanceActive = False;
	SharpShotFlyActive = False;
	ShockSlaughterActive = False;
	SkaarjHuntActive = False;
	SpidermanActive = False;
	StarHuntActive = False;
	SupermanActive = False;
	ThunderGodActive = False;
	UtilityMutilityActive = False;
	VolcanicHuntActive = False;
	WarlordHuntActive = False;
	WizardryActive = False;
	ZombieSlayerActive = False;
	FeatherweightActive = False;
	EmeraldShatterActive = False;
	KrallHuntActive = False;
	HaltActive = False;
}

function Timer()
{
	local Pawn P;
	local Vehicle V;
	local xPawn X;
	
	P = PawnOwner;
	if(P != None && P.isA('Vehicle'))
		P = Vehicle(P).Driver;
	V = Vehicle(InstigatorController.Pawn);
	X = xPawn(PawnOwner);
	
	if(!stopped)
	{
		if (P == None || P.Health <= 0)
		{
			Destroy();
			return;
		}
		else if (P != None && P.Health > 0)
		{
			BInv = LetterBInv(P.FindInventoryType(class'LetterBInv'));
			OInv = LetterOInv(P.FindInventoryType(class'LetterOInv'));
			NInv = LetterNInv(P.FindInventoryType(class'LetterNInv'));
			UInv = LetterUInv(P.FindInventoryType(class'LetterUInv'));
			SInv = LetterSInv(P.FindInventoryType(class'LetterSInv'));
	
			Null = NullEntropyInv(P.FindInventoryType(class'NullEntropyInv'));
			Heat = SuperHeatInv(P.FindInventoryType(class'SuperHeatInv'));
			Freeze = FreezeInv(P.FindInventoryType(class'FreezeInv'));
			Knockback = KnockbackInv(P.FindInventoryType(class'KnockbackInv'));
			Poison = DruidPoisonInv(P.FindInventoryType(class'DruidPoisonInv'));
			Trans = Translauncher(P.Weapon);
			Boots = DruidArtifactFlight(P.FindInventoryType(class'DruidArtifactFlight'));
			
			RewardWizardry = ArtifactMaxModifier(P.FindInventoryType(class'ArtifactMaxModifier'));
			RewardLifeMend = HealerNaliSummonInv(P.FindInventoryType(class'HealerNaliSummonInv'));
			RewardSkaarjHunt = ArtifactSummonSkaarj(P.FindInventoryType(class'ArtifactSummonSkaarj'));
			RewardWarlordHunt = ArtifactSummonWarlord(P.FindInventoryType(class'ArtifactSummonWarlord'));
			RewardBoneCrusher = ArtifactSummonSkeleton(P.FindInventoryType(class'ArtifactSummonSkeleton'));
			RewardGhostBuster = ArtifactResurrectSingle(P.FindInventoryType(class'ArtifactResurrectSingle'));
			RewardThunderGod = ThunderGodInv(P.FindInventoryType(class'ThunderGodInv'));
			RewardNaniteCrash = DroneOneInv(P.FindInventoryType(class'DroneOneInv'));
			RewardStarHunt = ArtifactPriestMagnet(P.FindInventoryType(class'ArtifactPriestMagnet'));
	
			if (HexedActive)
			{
				if (V != None)
				{
					V.Driver.TakeDamage(HexDamage, V.Driver, V.Driver.Location, vect(0,0,0), class'DamTypeHex');
				}
				else
					P.TakeDamage(HexDamage, P, P.Location, vect(0,0,0), class'DamTypeHex');
				MissionCount++;
			}
			if (WizardryActive)
			{
				
				if (Null == None && Heat == None && Freeze == None && Knockback == None && Poison == None)
					MissionCount = 0;
			}
			if (FeatherweightActive)
			{
				if (Trans != None || V != None || (Boots != None && Boots.bActive) || P.bIsWalking)
					MissionCount = 0;
				if (P.Physics == PHYS_Falling)
					MissionCount++;
				else
					MissionCount = 0;
			}
			if (HaltActive)
			{
				if (Null == None)
					StopEffect();
				if (V != None)
				{
					MissionCount = 0;
				}
				if (V == None && Null != None)
					MissionCount++;
			}
			if (MissionCount >= MissionGoal)
			{
				if ((MissionXP > 0) && (Rules != None))
				{
					Rules.ShareExperience(RPGStatsInv(P.FindInventoryType(class'RPGStatsInv')), MissionXP);
				}
				
				if (AngerManagementActive)
				{
					Inv.AngerManagementComplete = True;
					if (NInv == None)
					{
						NInv = P.spawn(class'LetterNInv');
						NInv.giveTo(P);
					}
				}
				else if (PyromancerActive)
					Inv.PyromancerComplete = True;
				else if (FrostmancerActive)
					Inv.FrostmancerComplete = True;
				else if (AquamanActive)
					Inv.AquamanComplete = True;
				else if (AVRiLAmityActive)
					Inv.AVRiLAmityComplete = True;
				else if (BioBerserkActive)
					Inv.BioBerserkComplete = True;
				else if (BoneCrusherActive)
				{
					Inv.BoneCrusherComplete = True;
					if (RewardBoneCrusher == None)
					{
						RewardBoneCrusher = P.spawn(class'ArtifactSummonSkeleton');
						RewardBoneCrusher.giveTo(P);
					}
				}
				else if (BugHuntActive)
					Inv.BugHuntComplete = True;
				else if (DeflectorActive)
					Inv.DeflectorComplete = True;
				else if (DisarmerActive)
				{
					Inv.DisarmerComplete = True;
					if (UInv == None)
					{
						UInv = P.spawn(class'LetterUInv');
						UInv.giveTo(P);
					}
				}
				else if (FlakFrenzyActive)
					Inv.FlakFrenzyComplete = True;
				else if (GhostBusterActive)
				{
					Inv.GhostBusterComplete = True;
					if (RewardGhostBuster == None)
					{
						RewardGhostBuster = P.spawn(class'ArtifactResurrectSingle');
						RewardGhostBuster.giveTo(P);
					}
				}					
				else if (GlacialHuntActive)
					Inv.GlacialHuntComplete = True;
				else if (HexedActive)
				{
					Inv.HexedComplete = True;
					P.GiveHealth(RegenRewardAmount, P.HealthMax);
				}
				else if (LifeMendActive)
				{
					Inv.LifeMendComplete = True;
					if (RewardLifeMend == None)
					{
						RewardLifeMend = P.spawn(class'HealerNaliSummonInv');
						RewardLifeMend.giveTo(P);
					}
				}
				else if (LinkLunaticActive)
					Inv.LinkLunaticComplete = True;
				else if (MightyLightningActive)
					Inv.MightyLightningComplete = True;
				else if (MinigunMayhemActive)
					Inv.MinigunMayhemComplete = True;
				else if (NaniteCrashActive)
				{
					Inv.NaniteCrashComplete = True;
					if (RewardNaniteCrash == None)
					{
						RewardNaniteCrash = P.spawn(class'DroneOneInv');
						RewardNaniteCrash.giveTo(P);
					}
				}
				else if (NullmancerActive)
					Inv.NullmancerComplete = True;
				else if (PopActive)
				{
					Inv.PopComplete = True;
					if (SInv == None)
					{
						SInv = P.spawn(class'LetterSInv');
						SInv.giveTo(P);
					}
				}
				else if (RocketRageActive)
					Inv.RocketRageComplete = True;
				else if (RootedStanceActive)
					Inv.RootedStanceComplete = True;
				else if (SharpShotFlyActive)
				{
					Inv.SharpShotFlyComplete = True;
					if (BInv == None)
					{
						BInv = P.spawn(class'LetterBInv');
						BInv.giveTo(P);						
					}
				}
				else if (ShockSlaughterActive)
					Inv.ShockSlaughterComplete = True;
				else if (SkaarjHuntActive)
				{
					Inv.SkaarjHuntComplete = True;
					if (RewardSkaarjHunt == None)
					{
						RewardSkaarjHunt = P.spawn(class'ArtifactSummonSkaarj');
						RewardSkaarjHunt.giveTo(P);
					}
				}
				else if (SpidermanActive)
					Inv.SpidermanComplete = True;
				else if (StarHuntActive)
				{
					Inv.StarHuntComplete = True;
					if (RewardStarHunt == None)
					{
						RewardStarHunt = P.spawn(class'ArtifactPriestMagnet');
						RewardStarHunt.giveTo(P);
					}
				}
				else if (SupermanActive)
					Inv.SupermanComplete = True;
				else if (ThunderGodActive)
				{
					Inv.ThunderGodComplete = True;
					if (RewardThunderGod == None)
					{
						RewardThunderGod = P.spawn(class'ThunderGodInv');
						RewardThunderGod.giveTo(P);
					}
				}
				else if (UtilityMutilityActive)
					Inv.UtilityMutilityComplete = True;
				else if (VolcanicHuntActive)
					Inv.VolcanicHuntComplete = True;
				else if (WarlordHuntActive)
				{
					Inv.WarlordHuntComplete = True;
					if (RewardWarlordHunt == None)
					{
						RewardWarlordHunt = P.spawn(class'ArtifactSummonWarlord');
						RewardWarlordHunt.giveTo(P);		
					}
				}
				else if (WizardryActive)
				{
					Inv.WizardryComplete = True;
					if (RewardWizardry == None)
					{
						RewardWizardry = P.spawn(class'ArtifactMaxModifier');
						RewardWizardry.giveTo(P);		
					}
				}
				else if (ZombieSlayerActive)
				{
					Inv.ZombieSlayerComplete = True;
					if (BInv == None)
					{
						BInv = P.spawn(class'LetterBInv');
						BInv.giveTo(P);						
					}
					if (OInv == None)
					{
						OInv = P.spawn(class'LetterOInv');
						OInv.giveTo(P);						
					}
					if (NInv == None)
					{
						NInv = P.spawn(class'LetterNInv');
						NInv.giveTo(P);						
					}
					if (UInv == None)
					{
						UInv = P.spawn(class'LetterUInv');
						UInv.giveTo(P);						
					}
					if (SInv == None)
					{
						SInv = P.spawn(class'LetterSInv');
						SInv.giveTo(P);						
					}
				}
				else if (FeatherweightActive)
				{
					Inv.FeatherweightComplete = True;
					if (X != None)
					{
						X.MaxMultiJump = 4;
						X.MultiJumpRemaining = 4;
					}
				}
				else if (EmeraldShatterActive)
				{
					Inv.EmeraldShatterComplete = True;
					if (OInv == None)
					{
						OInv = P.spawn(class'LetterOInv');
						OInv.giveTo(P);						
					}
				}
				else if (KrallHuntActive)
					Inv.KrallHuntComplete = True;
				else if (HaltActive)
				{
					Inv.HaltComplete = True;
					if (Null != None)
						Null.Destroy();
				}
					
				Level.Game.Broadcast(self, P.PlayerReplicationInfo.PlayerName $ " achieved " $ MissionName $ "!");
				P.PlaySound(Sound'DEKRPG208.MissionSounds.MissionComplete1', SLOT_None, 400.0);
				Inv.MissionsCompleted += 1;
				StopEffect();
			}
		}
		//else
		//{
		//	stopEffect();
		//	// Don't destroy. We want to keep this inventory on player so PostRender can draw icon for mission completion.
		//}
	}
	else
		stopEffect();	//Something wrong here, we should be stopped.
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
		MissionCount = 0;
		MissionGoal = 0;
		AngerManagementActive = False;
		PyromancerActive = False;
		FrostmancerActive = False;
		AquamanActive = False;
		AVRiLAmityActive = False;
		BioBerserkActive = False;
		BoneCrusherActive = False;
		BugHuntActive = False;
		DeflectorActive = False;
		DisarmerActive = False;
		FlakFrenzyActive = False;
		GhostBusterActive = False;
		GlacialHuntActive = False;
		HexedActive = False;
		LifeMendActive = False;
		LinkLunaticActive = False;
		MightyLightningActive = False;
		MinigunMayhemActive = False;
		NaniteCrashActive = False;
		NullmancerActive = False;
		PopActive = False;
		RocketRageActive = False;
		RootedStanceActive = False;
		SharpShotFlyActive = False;
		ShockSlaughterActive = False;
		SkaarjHuntActive = False;
		SpidermanActive = False;
		SupermanActive = False;
		ThunderGodActive = False;
		UtilityMutilityActive = False;
		VolcanicHuntActive = False;
		WarlordHuntActive = False;
		WizardryActive = False;
		FeatherweightActive = False;
		EmeraldShatterActive = False;
		KrallHuntActive = False;
		HaltActive = False;
	}
}

simulated function destroyed()
{
 	if( InteractionOwner != None )
 	{
 		InteractionOwner.M2Inv = None;
 		InteractionOwner = None;
 	}
	super.destroyed();
}

defaultproperties
{
     CheckInterval=1.000000
     HexDamage=10
	 RegenRewardAmount=1.0000
}
