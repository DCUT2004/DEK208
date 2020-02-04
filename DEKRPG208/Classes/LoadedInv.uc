//-----------------------------------------------------------
//
//-----------------------------------------------------------
class LoadedInv extends Inventory;

// extended to allow multiple loaded skills to be held at the same time
var bool bGotLoadedWeapons;
var bool bGotLoadedArtifacts;
var bool bGotLoadedMonsters;
var bool bGotLoadedEngineer;
var bool bGotLoadedWarrior;
var bool bGotLoadedClassicShield;
var bool bGotLoadedClassicAR;
var bool bGotLoadedAVRiL;
var bool bGotLoadedUtility;
var bool bGotLoadedExplosives;
var bool bGotLoadedLaser;
var bool bGotAerialTrap;
var bool bGotBombTrap;
var bool bGotFrostTrap;
var bool bGotShockTrap;
var bool bGotWildfireTrap;
var bool bGotRailGun;
var bool bGotLoadedNecromancer;
var bool bGotAGGL;

var int LWAbilityLevel;
var int LAAbilityLevel;
var int LMAbilityLevel;
var int LEAbilityLevel;
var int LWarAbilityLevel;
var int LShieldAbilityLevel;
var int LARAbilityLevel;
var int LAVRiLAbilityLevel;
var int LUtilityAbilityLevel;
var int LExplosivesAbilityLevel;
var int LLaserAbilityLevel;
var int ATrapAbilityLevel;
var int BTrapAbilityLevel;
var int FTrapAbilityLevel;
var int STrapAbilityLevel;
var int WTrapAbilityLevel;
var int LRailGunAbilityLevel;
var int LNAbilityLevel;
var int LAGGLLevel;

var bool ProtectArtifacts;
var bool DirectMonsters;

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
     RemoteRole=ROLE_DumbProxy
}
