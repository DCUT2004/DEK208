class MissionInvHolder extends Actor;

var int MissionsCompleted;

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

replication
{
	reliable if (Role == ROLE_Authority)
		MissionsCompleted, AngerManagementComplete, PyromancerComplete, FrostmancerComplete, AquamanComplete, AVRiLAmityComplete, BioBerserkComplete, BoneCrusherComplete, BugHuntComplete, DeflectorComplete, DisarmerComplete, FlakFrenzyComplete, GhostBusterComplete, GlacialHuntComplete, HexedComplete, LifeMendComplete, LinkLunaticComplete, MightyLightningComplete, MinigunMayhemComplete, NaniteCrashComplete, NullmancerComplete, PopComplete, RocketRageComplete, RootedStanceComplete, SharpShotFlyComplete, ShockSlaughterComplete, SkaarjHuntComplete, SpidermanComplete, StarHuntComplete, SupermanComplete, ThunderGodComplete, UtilityMutilityComplete, VolcanicHuntComplete, WarlordHuntComplete, WizardryComplete, ZombieSlayerComplete, FeatherweightComplete, EmeraldShatterComplete, KrallHuntComplete, HaltComplete;
}

function PostBeginPlay()
{
	SetTimer(5.0, true);

	Super.PostBeginPlay();
}

function Timer()
{
	if (Controller(Owner) == None)
		Destroy();
}

defaultproperties
{
     bHidden=True
     RemoteRole=ROLE_None
}
