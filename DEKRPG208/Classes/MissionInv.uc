class MissionInv extends Inventory
	config(UT2004RPG);

var Pawn PawnOwner;
var MissionInvHolder Holder;

var bool AngerManagementComplete;
var bool PyromancerComplete;
var bool FrostmancerComplete;
var bool AquamanComplete;
var bool AVRiLAmityComplete;
var bool BioBerserkComplete;
var bool BoneCrusherComplete;
var bool BugHuntComplete;
var bool DeflectorComplete;
var bool DisarmerComplete;
var bool FlakFrenzyComplete;
var bool GhostBusterComplete;
var bool GlacialHuntComplete;
var bool HexedComplete;
var bool LifeMendComplete;
var bool LinkLunaticComplete;
var bool MightyLightningComplete;
var bool MinigunMayhemComplete;
var bool NaniteCrashComplete;
var bool NullmancerComplete;
var bool PopComplete;
var bool RocketRageComplete;
var bool RootedStanceComplete;
var bool SharpShotFlyComplete;
var bool ShockSlaughterComplete;
var bool SkaarjHuntComplete;
var bool SpidermanComplete;
var bool StarHuntComplete;
var bool SupermanComplete;
var bool ThunderGodComplete;
var bool UtilityMutilityComplete;
var bool VolcanicHuntComplete;
var bool WarlordHuntComplete;
var bool WizardryComplete;
var bool ZombieSlayerComplete;
var bool FeatherweightComplete;
var bool EmeraldShatterComplete;
var bool KrallHuntComplete;
var bool HaltComplete;
var int MissionsCompleted;

var transient DruidsRPGKeysInteraction InteractionOwner;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role<ROLE_Authority)
		ExitMissionOneCommand, ExitMissionTwoCommand, ExitMissionThreeCommand;
	reliable if (Role == ROLE_Authority)
		MissionsCompleted, AngerManagementComplete, PyromancerComplete, FrostmancerComplete, AquamanComplete, AVRiLAmityComplete, BioBerserkComplete, BoneCrusherComplete, BugHuntComplete, DeflectorComplete, DisarmerComplete, FlakFrenzyComplete, GhostBusterComplete, GlacialHuntComplete, HexedComplete, LifeMendComplete, LinkLunaticComplete, MightyLightningComplete, MinigunMayhemComplete, NaniteCrashComplete, NullmancerComplete, PopComplete, RocketRageComplete, RootedStanceComplete, SharpShotFlyComplete, ShockSlaughterComplete, SkaarjHuntComplete, SpidermanComplete, StarHuntComplete, SupermanComplete, ThunderGodComplete, UtilityMutilityComplete, VolcanicHuntComplete, WarlordHuntComplete, WizardryComplete, ZombieSlayerComplete, FeatherweightComplete, EmeraldShatterComplete, KrallHuntComplete, HaltComplete;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if (Invasion(Level.Game) == None)
	{
		Destroy();
		return;
	}
	
	if (Other != None)
		PawnOwner = Other;
	
	foreach PawnOwner.DynamicActors(class'MissionInvHolder', Holder)
		if (Holder != None && Holder.Owner == PawnOwner.Controller)
		{
			MissionsCompleted = Holder.MissionsCompleted;
			if (Holder.AngerManagementComplete)
				AngerManagementComplete = True;
			else
				AngerManagementComplete = False;
			if (Holder.PyromancerComplete)
				PyromancerComplete = True;
			else
				PyromancerComplete = False;
			if (Holder.FrostmancerComplete)
				FrostmancerComplete = True;
			else
				FrostmancerComplete = False;
			if (Holder.AquamanComplete)
				AquamanComplete = True;
			else
				AquamanComplete = False;
			if (Holder.AVRiLAmityComplete)
				AVRiLAmityComplete = True;
			else
				AVRiLAmityComplete = False;
			if (Holder.BioBerserkComplete)
				BioBerserkComplete = True;
			else
				BioBerserkComplete = False;
			if (Holder.BoneCrusherComplete)
				BoneCrusherComplete = True;
			else
				BoneCrusherComplete = False;
			if (Holder.BugHuntComplete)
				BugHuntComplete = True;
			else
				BugHuntComplete = False;
			if (Holder.DeflectorComplete)
				DeflectorComplete = True;
			else
				DeflectorComplete = False;
			if (Holder.DisarmerComplete)
				DisarmerComplete = True;
			else
				DisarmerComplete = False;
			if (Holder.FlakFrenzyComplete)
				FlakFrenzyComplete = True;
			else
				FlakFrenzyComplete = False;
			if (Holder.GhostBusterComplete)
				GhostBusterComplete = True;
			else
				GhostBusterComplete = False;
			if (Holder.GlacialHuntComplete)
				GlacialHuntComplete = True;
			else
				GlacialHuntComplete = False;
			if (Holder.HexedComplete)
				HexedComplete = True;
			else
				HexedComplete = False;
			if (Holder.LifeMendComplete)
				LifeMendComplete = True;
			else
				LifeMendComplete = False;
			if (Holder.LinkLunaticComplete)
				LinkLunaticComplete = True;
			else
				LinkLunaticComplete = False;
			if (Holder.MightyLightningComplete)
				MightyLightningComplete = True;
			else
				MightyLightningComplete = False;
			if (Holder.MinigunMayhemComplete)
				MinigunMayhemComplete = True;
			else
				MinigunMayhemComplete = False;
			if (Holder.NaniteCrashComplete)
				NaniteCrashComplete = True;
			else
				NaniteCrashComplete = False;
			if (Holder.NullmancerComplete)
				NullmancerComplete = True;
			else
				NullmancerComplete = False;
			if (Holder.PopComplete)
				PopComplete = True;
			else
				PopComplete = False;
			if (Holder.RocketRageComplete)
				RocketRageComplete = True;
			else
				RocketRageComplete = False;
			if (Holder.RootedStanceComplete)
				RootedStanceComplete = True;
			else
				RootedStanceComplete = False;
			if (Holder.SharpShotFlyComplete)
				SharpShotFlyComplete = True;
			else
				SharpShotFlyComplete = False;
			if (Holder.ShockSlaughterComplete)
				ShockSlaughterComplete = True;
			else
				ShockSlaughterComplete = False;
			if (Holder.SkaarjHuntComplete)
				SkaarjHuntComplete = True;
			else
				SkaarjHuntComplete = False;
			if (Holder.SpidermanComplete)
				SpidermanComplete = True;
			else
				SpidermanComplete = False;
			if (Holder.StarHuntComplete)
				StarHuntComplete = True;
			else
				StarHuntComplete = False;
			if (Holder.SupermanComplete)
				SupermanComplete = True;
			else
				SupermanComplete = False;
			if (Holder.ThunderGodComplete)
				ThunderGodComplete = True;
			else
				ThunderGodComplete = False;
			if (Holder.UtilityMutilityComplete)
				UtilityMutilityComplete = True;
			else
				UtilityMutilityComplete = False;
			if (Holder.VolcanicHuntComplete)
				VolcanicHuntComplete = True;
			else
				VolcanicHuntComplete = False;
			if (Holder.WarlordHuntComplete)
				WarlordHuntComplete = True;
			else
				WarlordHuntComplete = False;
			if (Holder.WizardryComplete)
				WizardryComplete = True;
			else
				WizardryComplete = False;
			if (Holder.ZombieSlayerComplete)
				ZombieSlayerComplete = True;
			else
				ZombieSlayerComplete = False;
			if (Holder.FeatherweightComplete)
				FeatherweightComplete = True;
			else
				FeatherweightComplete = False;
			if (Holder.EmeraldShatterComplete)
				EmeraldShatterComplete = True;
			else
				EmeraldShatterComplete = False;
			if (Holder.KrallHuntComplete)
				KrallHuntComplete = True;
			else
				KrallHuntComplete = False;
			if (Holder.HaltComplete)
				HaltComplete = True;
			else
				HaltComplete = False;
			Holder.Destroy();
		}
	
	Super.GiveTo(Other);
}

static function ExitMissionOne(Pawn P)
{
	local MissionInv Inv;

	if (P == None)
		return;

	// ok, lets try it
	Inv = MissionInv(P.FindInventoryType(class'MissionInv'));
	if (Inv != None)
	{
		Inv.ExitMissionOneCommand(P);
	}
}

static function ExitMissionTwo(Pawn P)
{
	local MissionInv Inv;

	if (P == None)
		return;

	// ok, lets try it
	Inv = MissionInv(P.FindInventoryType(class'MissionInv'));
	if (Inv != None)
	{
		Inv.ExitMissionTwoCommand(P);
	}
}

static function ExitMissionThree(Pawn P)
{
	local MissionInv Inv;

	if (P == None)
		return;

	// ok, lets try it
	Inv = MissionInv(P.FindInventoryType(class'MissionInv'));
	if (Inv != None)
	{
		Inv.ExitMissionThreeCommand(P);
	}
}

function ExitMissionOneCommand(Pawn P)
{
	local Mission1Inv M1Inv;
	local NullEntropyInv NInv;
	
	M1Inv = Mission1Inv(P.FindInventoryType(class'Mission1Inv'));
	NInv = NullEntropyInv(P.FindInventoryType(class'NullEntropyInv'));
	
	if (M1Inv != None)
	{
		if (M1Inv.HaltActive && NInv != None)
			NInv.Destroy();
		M1Inv.stopEffect();
		M1Inv.MissionCount = 0;
		P.ReceiveLocalizedMessage(MessageClass, 1, None, None, Class);
	}
}

function ExitMissionTwoCommand(Pawn P)
{
	local Mission2Inv M2Inv;
	local NullEntropyInv NInv;
	
	M2Inv = Mission2Inv(P.FindInventoryType(class'Mission2Inv'));
	NInv = NullEntropyInv(P.FindInventoryType(class'NullEntropyInv'));
	
	if (M2Inv != None)
	{
		if (M2Inv.HaltActive && NInv != None)
			NInv.Destroy();
		M2Inv.stopEffect();
		M2Inv.MissionCount = 0;
		P.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
	}
}

function ExitMissionThreeCommand(Pawn P)
{
	local Mission3Inv M3Inv;
	local NullEntropyInv NInv;
	
	M3Inv = Mission3Inv(P.FindInventoryType(class'Mission3Inv'));
	NInv = NullEntropyInv(P.FindInventoryType(class'NullEntropyInv'));
	
	if (M3Inv != None)
	{
		if (M3Inv.HaltActive && NInv != None)
			NInv.Destroy();
		M3Inv.stopEffect();
		M3Inv.MissionCount = 0;
		P.ReceiveLocalizedMessage(MessageClass, 3, None, None, Class);
	}
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 1)
		return "Mission 1 forfeited/reset.";
	if (Switch == 2)
		return "Mission 2 forfeited/reset.";
	if (Switch == 3)
		return "Mission 3 forfeited/reset.";

	return Super.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
}

simulated function destroyed()
{
	if (PawnOwner.Controller != None)
	{
		Holder = PawnOwner.spawn(class'MissionInvHolder',PawnOwner.Controller);
		if (Holder != None)
		{
			Holder.MissionsCompleted = MissionsCompleted;
			if (AngerManagementComplete)
				Holder.AngerManagementComplete = True;
			if (PyromancerComplete)
				Holder.PyromancerComplete = True;
			if (FrostmancerComplete)
				Holder.FrostmancerComplete = True;
			if (AquamanComplete)
				Holder.AquamanComplete = True;
			if (AVRiLAmityComplete)
				Holder.AVRiLAmityComplete = True;
			if (BioBerserkComplete)
				Holder.BioBerserkComplete = True;
			if (BoneCrusherComplete)
				Holder.BoneCrusherComplete = True;
			if (BugHuntComplete)
				Holder.BugHuntComplete = True;
			if (DeflectorComplete)
				Holder.DeflectorComplete = True;
			if (DisarmerComplete)
				Holder.DisarmerComplete = True;
			if (FlakFrenzyComplete)
				Holder.FlakFrenzyComplete = True;
			if (GhostBusterComplete)
				Holder.GhostBusterComplete = True;
			if (GlacialHuntComplete)
				Holder.GlacialHuntComplete = True;
			if (HexedComplete)
				Holder.HexedComplete = True;
			if (LifeMendComplete)
				Holder.LifeMendComplete = True;
			if (LinkLunaticComplete)
				Holder.LinkLunaticComplete = True;
			if (MightyLightningComplete)
				Holder.MightyLightningComplete = True;
			if (MinigunMayhemComplete)
				Holder.MinigunMayhemComplete = True;
			if (NaniteCrashComplete)
				Holder.NaniteCrashComplete = True;
			if (NullmancerComplete)
				Holder.NullmancerComplete = True;
			if (PopComplete)
				Holder.PopComplete = True;
			if (RocketRageComplete)
				Holder.RocketRageComplete = True;
			if (RootedStanceComplete)
				Holder.RootedStanceComplete = True;
			if (SharpShotFlyComplete)
				Holder.SharpShotFlyComplete = True;
			if (ShockSlaughterComplete)
				Holder.ShockSlaughterComplete = True;
			if (SkaarjHuntComplete)
				Holder.SkaarjHuntComplete = True;
			if (SpidermanComplete)
				Holder.SpidermanComplete = True;
			if (StarHuntComplete)
				Holder.StarHuntComplete = True;
			if (SupermanComplete)
				Holder.SupermanComplete = True;
			if (ThunderGodComplete)
				Holder.ThunderGodComplete = True;
			if (UtilityMutilityComplete)
				Holder.UtilityMutilityComplete = True;
			if (VolcanicHuntComplete)
				Holder.VolcanicHuntComplete = True;
			if (WarlordHuntComplete)
				Holder.WarlordHuntComplete = True;
			if (WizardryComplete)
				Holder.WizardryComplete = True;
			if (ZombieSlayerComplete)
				Holder.ZombieSlayerComplete = True;
			if (FeatherweightComplete)
				Holder.FeatherweightComplete = True;
			if (EmeraldShatterComplete)
				Holder.EmeraldShatterComplete = True;
			if (KrallHuntComplete)
				Holder.KrallHuntComplete = True;
			if (HaltComplete)
				Holder.HaltComplete = True;
			Holder.SetOwner(PawnOwner.Controller);
		}
	}
		
 	if( InteractionOwner != None )
 	{
 		InteractionOwner.MissionInv = None;
 		InteractionOwner = None;
 	}
	super.destroyed();
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
     MessageClass=Class'UnrealGame.StringMessagePlus'
}
