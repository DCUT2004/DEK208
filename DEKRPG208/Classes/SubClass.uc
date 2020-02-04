class SubClass extends RPGAbility
	config(UT2004RPG)
	abstract;

// this ability is just a place holder for the different subclasses on the system.
// each level represents a different subclass.
// AbilityConfigs(0)=(AvailableAbility=Class'DruidsRPG221.DruidSomeAbility',AvailableSubClasses="0,3,6,12",MaxLevels="5,15,15,10")


// mapping of level to subclass. level 0 is no subclass. level 1 is SubClasses(1) etc.
var config Array<string> SubClasses;

// structure containing list of subclasses available to each class, and what minimum level it can be bought at
struct SubClassAvailability
{
	var class<RPGClass> AvailableClass;
	var string AvailableSubClass;
	var int MinLevel;			// min level this class can use this subclass
};
var config Array<SubClassAvailability> SubClassConfigs;
// to remove a subclass, remove it from this SubClassConfigs list. Then the L screen will force the user to sell.

// structure containing list of abilities available to each class/subclass. Set MaxLevel to zero for abilities not available.
struct AbilityConfig
{
	var class<RPGAbility> AvailableAbility;
	var Array<int> MaxLevels;			// one maxlevel per subclass, zero means cannot have
};
var config Array<AbilityConfig> AbilityConfigs;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	if ( Data != None && Data.OwnerID == "Bot")
		return 0;		// do not let bots buy subclasses. Too complex for them.

	if (CurrentLevel==0)
		return 1;	// can buy. Check for valid class is done elsewhere
	else
		return 0;	// can only buy one level for cost purposes

}

static function int BotBuyChance(Bot B, RPGPlayerDataObject Data, int CurrentLevel)
{
		return 0;	// stop bots from buying. Could just set BotChance to 0, but we still then have the hassle of calculating the cost.
}

defaultproperties
{
     SubClasses(0)="None"
     SubClasses(1)="Class: Weapons Master"
     SubClasses(2)="Class: Adrenaline Master"
     SubClasses(3)="Class: Monster/Medic Master"
     SubClasses(4)="Class: Engineer"
     SubClasses(5)="Class: General"
     SubClasses(6)="Class: Classic RPG"
     SubClasses(7)="Extreme Weapons Master"
     SubClasses(8)="Berserker"
     SubClasses(9)="Weapons Proficiency"
     SubClasses(10)="Tank"
     SubClasses(11)="Extreme Adrenaline Master"
     SubClasses(12)="Craftsman"
     SubClasses(13)="Base Builder"
     SubClasses(14)="Engineer Weaponry"
     SubClasses(15)="Healer"
     SubClasses(16)="Summoner"
     SubClasses(17)="Weapon-Adrenaline Hybrid"
     SubClasses(18)="Weapon-Medic Hybrid"
     SubClasses(19)="Weapon-Engineer Hybrid"
     SubClasses(20)="Adrenaline-Medic Hybrid"
     SubClasses(21)="Adrenaline-Engineer Hybrid"
     SubClasses(22)="Medic-Engineer Hybrid"
     SubClasses(23)="Auto Engineer"
     SubClasses(24)="Sniper"
     SubClasses(25)="Necromancer"
     SubClasses(26)="Reset Your Skills"
     SubClassConfigs(0)=(AvailableClass=Class'DEKRPG208.ClassWeaponsMaster',AvailableSubClass="None",MinLevel=30)
     SubClassConfigs(1)=(AvailableClass=Class'DEKRPG208.ClassAdrenalineMaster',AvailableSubClass="None",MinLevel=30)
     SubClassConfigs(2)=(AvailableClass=Class'DEKRPG208.ClassMonsterMaster',AvailableSubClass="None",MinLevel=30)
     SubClassConfigs(3)=(AvailableClass=Class'DEKRPG208.ClassEngineer',AvailableSubClass="None",MinLevel=30)
     SubClassConfigs(4)=(AvailableClass=Class'DEKRPG208.ClassGeneral',AvailableSubClass="None",MinLevel=30)
     SubClassConfigs(5)=(AvailableClass=Class'DEKRPG208.ClassClassicRPG',AvailableSubClass="None",MinLevel=30)
     SubClassConfigs(6)=(AvailableClass=Class'DEKRPG208.ClassWeaponsMaster',AvailableSubClass="Extreme Weapons Master",MinLevel=90)
     SubClassConfigs(7)=(AvailableClass=Class'DEKRPG208.ClassWeaponsMaster',AvailableSubClass="Berserker",MinLevel=90)
     SubClassConfigs(8)=(AvailableClass=Class'DEKRPG208.ClassWeaponsMaster',AvailableSubClass="Sniper",MinLevel=90)
     SubClassConfigs(9)=(AvailableClass=Class'DEKRPG208.ClassWeaponsMaster',AvailableSubClass="Weapons Proficiency",MinLevel=90)
     SubClassConfigs(10)=(AvailableClass=Class'DEKRPG208.ClassWeaponsMaster',AvailableSubClass="Tank",MinLevel=90)
     SubClassConfigs(11)=(AvailableClass=Class'DEKRPG208.ClassAdrenalineMaster',AvailableSubClass="Extreme Adrenaline Master",MinLevel=90)
     SubClassConfigs(12)=(AvailableClass=Class'DEKRPG208.ClassAdrenalineMaster',AvailableSubClass="Craftsman",MinLevel=90)
     SubClassConfigs(13)=(AvailableClass=Class'DEKRPG208.ClassEngineer',AvailableSubClass="Base Builder",MinLevel=90)
     SubClassConfigs(14)=(AvailableClass=Class'DEKRPG208.ClassEngineer',AvailableSubClass="Engineer Weaponry",MinLevel=90)
     SubClassConfigs(15)=(AvailableClass=Class'DEKRPG208.ClassEngineer',AvailableSubClass="Auto Engineer",MinLevel=90)
     SubClassConfigs(16)=(AvailableClass=Class'DEKRPG208.ClassMonsterMaster',AvailableSubClass="Healer",MinLevel=90)
     SubClassConfigs(17)=(AvailableClass=Class'DEKRPG208.ClassMonsterMaster',AvailableSubClass="Summoner",MinLevel=90)
     SubClassConfigs(18)=(AvailableClass=Class'DEKRPG208.ClassMonsterMaster',AvailableSubClass="Necromancer",MinLevel=90)
     SubClassConfigs(19)=(AvailableClass=Class'DEKRPG208.ClassGeneral',AvailableSubClass="Weapon-Adrenaline Hybrid",MinLevel=90)
     SubClassConfigs(20)=(AvailableClass=Class'DEKRPG208.ClassGeneral',AvailableSubClass="Weapon-Medic Hybrid",MinLevel=90)
     SubClassConfigs(21)=(AvailableClass=Class'DEKRPG208.ClassGeneral',AvailableSubClass="Weapon-Engineer Hybrid",MinLevel=90)
     SubClassConfigs(22)=(AvailableClass=Class'DEKRPG208.ClassGeneral',AvailableSubClass="Adrenaline-Medic Hybrid",MinLevel=90)
     SubClassConfigs(23)=(AvailableClass=Class'DEKRPG208.ClassGeneral',AvailableSubClass="Adrenaline-Engineer Hybrid",MinLevel=90)
     SubClassConfigs(24)=(AvailableClass=Class'DEKRPG208.ClassGeneral',AvailableSubClass="Medic-Engineer Hybrid",MinLevel=90)
     SubClassConfigs(25)=(AvailableClass=Class'DEKRPG208.ClassWeaponsMaster',AvailableSubClass="Reset Your Skills",MinLevel=30)
     SubClassConfigs(26)=(AvailableClass=Class'DEKRPG208.ClassAdrenalineMaster',AvailableSubClass="Reset Your Skills",MinLevel=30)
     SubClassConfigs(27)=(AvailableClass=Class'DEKRPG208.ClassMonsterMaster',AvailableSubClass="Reset Your Skills",MinLevel=30)
     SubClassConfigs(28)=(AvailableClass=Class'DEKRPG208.ClassEngineer',AvailableSubClass="Reset Your Skills",MinLevel=30)
     SubClassConfigs(29)=(AvailableClass=Class'DEKRPG208.ClassGeneral',AvailableSubClass="Reset Your Skills",MinLevel=30)
     SubClassConfigs(30)=(AvailableClass=Class'DEKRPG208.ClassClassicRPG',AvailableSubClass="Reset Your Skills",MinLevel=30)
     AbilityConfigs(0)=(AvailableAbility=Class'DEKRPG208.DruidAmmoRegen',MaxLevels=(0,4,4,0,0,1,2,6,6,6,4,4,4,0,0,0,0,4,2,2,2,2,0,1,4,2,1))
     AbilityConfigs(1)=(AvailableAbility=Class'DEKRPG208.DruidAwareness',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(2)=(AvailableAbility=Class'DEKRPG208.DruidNoWeaponDrop',MaxLevels=(0,2,3,0,0,0,3,2,2,2,2,2,3,0,0,0,0,2,2,2,2,2,0,0,2,0,0))
     AbilityConfigs(3)=(AvailableAbility=Class'DEKRPG208.DruidRegen',MaxLevels=(3,5,1,5,1,3,5,5,5,5,5,1,1,1,1,0,5,3,5,3,3,1,3,2,5,0,3))
     AbilityConfigs(4)=(AvailableAbility=Class'DEKRPG208.AbilityHealerRegen',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(5)=(AvailableAbility=Class'DEKRPG208.DruidAdrenalineRegen',MaxLevels=(0,0,3,1,0,1,0,0,0,0,0,3,3,0,0,1,1,2,1,0,3,2,1,0,0,1,0))
     AbilityConfigs(6)=(AvailableAbility=Class'DEKRPG208.AbilityVehicleEject',MaxLevels=(1,1,1,1,4,2,1,1,1,1,1,1,1,4,4,1,1,1,1,2,1,2,2,4,1,1,1))
     AbilityConfigs(7)=(AvailableAbility=Class'DEKRPG208.AbilityWheeledVehicleStunts',MaxLevels=(2,2,2,2,4,2,2,2,2,2,2,2,2,2,4,2,2,2,2,3,3,3,3,4,2,2,2))
     AbilityConfigs(8)=(AvailableAbility=Class'DEKRPG208.DruidGhost',MaxLevels=(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,3))
     AbilityConfigs(9)=(AvailableAbility=Class'DEKRPG208.DruidUltima',MaxLevels=(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4))
     AbilityConfigs(10)=(AvailableAbility=Class'DEKRPG208.DruidCounterShove',MaxLevels=(5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5))
     AbilityConfigs(11)=(AvailableAbility=Class'DEKRPG208.DruidRetaliate',MaxLevels=(10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10))
     AbilityConfigs(12)=(AvailableAbility=Class'UT2004RPG.AbilityJumpZ',MaxLevels=(3,3,3,3,3,3,3,3,3,3,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3))
     AbilityConfigs(13)=(AvailableAbility=Class'UT2004RPG.AbilityReduceFallDamage',MaxLevels=(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4))
     AbilityConfigs(14)=(AvailableAbility=Class'UT2004RPG.AbilitySpeed',MaxLevels=(4,4,4,4,4,4,4,4,4,4,0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4))
     AbilityConfigs(15)=(AvailableAbility=Class'UT2004RPG.AbilityShieldStrength',MaxLevels=(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4))
     AbilityConfigs(16)=(AvailableAbility=Class'UT2004RPG.AbilityReduceSelfDamage',MaxLevels=(5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5))
     AbilityConfigs(17)=(AvailableAbility=Class'UT2004RPG.AbilitySmartHealing',MaxLevels=(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4))
     AbilityConfigs(18)=(AvailableAbility=Class'UT2004RPG.AbilityAirControl',MaxLevels=(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4))
     AbilityConfigs(19)=(AvailableAbility=Class'UT2004RPG.AbilityFastWeaponSwitch',MaxLevels=(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2))
     AbilityConfigs(20)=(AvailableAbility=Class'DEKRPG208.DruidAdrenalineSurge',MaxLevels=(0,0,2,0,0,0,0,0,0,0,0,3,2,0,0,0,0,3,0,0,1,1,0,0,0,3,0))
     AbilityConfigs(21)=(AvailableAbility=Class'DEKRPG208.DruidEnergyVampire',MaxLevels=(0,0,5,0,0,2,0,0,0,0,0,5,3,0,0,0,0,3,0,0,2,2,0,0,0,0,0))
     AbilityConfigs(22)=(AvailableAbility=Class'DEKRPG208.AbilityEnergyShield',MaxLevels=(0,0,2,0,0,0,0,0,0,0,0,2,3,0,0,0,0,1,0,0,1,1,0,0,0,0,0))
     AbilityConfigs(23)=(AvailableAbility=Class'DEKRPG208.AbilityMagicVault',MaxLevels=(0,3,0,0,0,0,0,3,3,3,3,0,3,0,0,0,0,2,1,1,0,0,0,0,3,0,0))
     AbilityConfigs(24)=(AvailableAbility=Class'DEKRPG208.DEKLoadedClassicShield',MaxLevels=(1,2,1,1,1,1,2,2,2,2,2,1,1,1,1,1,1,2,2,2,1,1,1,1,2,1,1))
     AbilityConfigs(25)=(AvailableAbility=Class'DEKRPG208.DEKLoadedClassicAR',MaxLevels=(1,2,1,1,1,1,0,2,2,2,2,1,1,1,1,1,1,2,2,2,1,1,1,1,2,1,1))
     AbilityConfigs(26)=(AvailableAbility=Class'DEKRPG208.DEKLoadedUtility',MaxLevels=(0,2,0,0,0,1,0,2,2,2,2,0,0,0,0,0,0,2,2,2,0,0,0,0,2,0,0))
     AbilityConfigs(27)=(AvailableAbility=Class'DEKRPG208.DEKLoadedAVRiL',MaxLevels=(0,2,0,0,0,1,0,2,2,2,2,0,0,0,0,0,0,2,2,2,0,0,0,0,2,0,0))
     AbilityConfigs(28)=(AvailableAbility=Class'DEKRPG208.DEKLoadedWarrior',MaxLevels=(0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(29)=(AvailableAbility=Class'DEKRPG208.DruidArtifactLoaded',MaxLevels=(0,0,4,0,0,2,0,0,0,0,0,5,0,0,0,0,0,3,0,0,3,3,0,0,0,0,0))
     AbilityConfigs(30)=(AvailableAbility=Class'DEKRPG208.AbilityLoadedCraftsman',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(31)=(AvailableAbility=Class'DEKRPG208.DruidLoaded',MaxLevels=(0,5,0,0,0,0,0,6,5,5,3,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0))
     AbilityConfigs(32)=(AvailableAbility=Class'DEKRPG208.AbilityHybridWeapons',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0))
     AbilityConfigs(33)=(AvailableAbility=Class'DEKRPG208.AbilityHybridWeaponsEM',MaxLevels=(0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0))
     AbilityConfigs(34)=(AvailableAbility=Class'DEKRPG208.DruidVampire',MaxLevels=(0,10,0,0,0,2,0,10,10,10,10,0,0,0,0,0,0,5,5,5,0,0,0,2,10,7,0))
     AbilityConfigs(35)=(AvailableAbility=Class'DEKRPG208.DruidVampireSurge',MaxLevels=(0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(36)=(AvailableAbility=Class'DEKRPG208.AbilityEnhancedDamage',MaxLevels=(0,10,0,0,0,3,15,0,0,0,0,0,0,0,0,0,0,5,5,5,0,0,0,0,0,0,0))
     AbilityConfigs(37)=(AvailableAbility=Class'DEKRPG208.AbilityBerserkerDamage',MaxLevels=(0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(38)=(AvailableAbility=Class'DEKRPG208.AbilityDistalDamage',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0))
     AbilityConfigs(39)=(AvailableAbility=Class'DEKRPG208.AbilityWeaponsProficiency',MaxLevels=(0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(40)=(AvailableAbility=Class'DEKRPG208.AbilityIncreasedDamage',MaxLevels=(0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(41)=(AvailableAbility=Class'DEKRPG208.AbilityIncreasedProtection',MaxLevels=(0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(42)=(AvailableAbility=Class'DEKRPG208.AbilityLoadedHealing',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(43)=(AvailableAbility=Class'DEKRPG208.AbilityDEKLoadedHealing',MaxLevels=(0,0,0,7,0,1,0,0,0,0,0,0,0,0,0,10,5,0,5,0,5,0,5,0,0,0,0))
     AbilityConfigs(44)=(AvailableAbility=Class'DEKRPG208.AbilityNecromancer',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0))
     AbilityConfigs(45)=(AvailableAbility=Class'DEKRPG208.AbilityExpHealing',MaxLevels=(0,0,0,9,0,2,0,0,0,0,0,0,0,0,0,12,2,0,5,0,5,0,5,0,0,0,0))
     AbilityConfigs(46)=(AvailableAbility=Class'DEKRPG208.AbilityMedicAwareness',MaxLevels=(0,0,0,2,0,1,0,0,0,0,0,0,0,0,0,2,2,0,2,0,2,0,2,0,0,0,0))
     AbilityConfigs(47)=(AvailableAbility=Class'DEKRPG208.AbilityLoadedMonsters',MaxLevels=(0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,5,20,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(48)=(AvailableAbility=Class'DEKRPG208.AbilityNecroLoadedMonsters',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0))
     AbilityConfigs(49)=(AvailableAbility=Class'DEKRPG208.AbilityMonsterHealthBonus',MaxLevels=(0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,3,10,0,0,0,0,0,0,0,0,10,0))
     AbilityConfigs(50)=(AvailableAbility=Class'DEKRPG208.AbilityMonsterPoints',MaxLevels=(0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,5,20,0,0,0,0,0,0,0,0,10,0))
     AbilityConfigs(51)=(AvailableAbility=Class'DEKRPG208.AbilityMonsterSkill',MaxLevels=(0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,7,7,0,0,0,0,0,0,0,0,7,0))
     AbilityConfigs(52)=(AvailableAbility=Class'DEKRPG208.AbilitySummonerMonsterDamage',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(53)=(AvailableAbility=Class'DEKRPG208.AbilityMonsterDamage',MaxLevels=(0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,5,0))
     AbilityConfigs(54)=(AvailableAbility=Class'DEKRPG208.AbilityEnhancedReduction',MaxLevels=(3,0,0,10,0,3,13,0,0,0,0,0,0,0,0,13,7,0,5,0,5,0,5,0,0,10,0))
     AbilityConfigs(55)=(AvailableAbility=Class'DEKRPG208.AbilityLoadedEngineer',MaxLevels=(0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(56)=(AvailableAbility=Class'DEKRPG208.AbilityGeneralEngineer',MaxLevels=(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(57)=(AvailableAbility=Class'DEKRPG208.AbilityExtremeEngineer',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(58)=(AvailableAbility=Class'DEKRPG208.AbilityTurretSpecialist',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(59)=(AvailableAbility=Class'DEKRPG208.AbilityEngineerWeaponry',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(60)=(AvailableAbility=Class'DEKRPG208.AbilityAutoEngineer',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0,0))
     AbilityConfigs(61)=(AvailableAbility=Class'DEKRPG208.AbilityBaseSpecialist',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(62)=(AvailableAbility=Class'DEKRPG208.DruidShieldRegen',MaxLevels=(0,0,0,0,10,3,0,0,0,0,0,0,0,5,10,0,0,0,0,5,0,5,5,15,0,0,0))
     AbilityConfigs(63)=(AvailableAbility=Class'DEKRPG208.AbilityShieldHealing',MaxLevels=(0,0,0,0,3,1,0,0,0,0,0,0,0,3,3,0,0,0,0,2,0,2,2,1,0,0,0))
     AbilityConfigs(64)=(AvailableAbility=Class'DEKRPG208.DruidArmorRegen',MaxLevels=(1,1,1,1,5,3,1,1,1,1,1,1,1,5,5,1,1,1,1,3,1,3,3,7,1,1,1))
     AbilityConfigs(65)=(AvailableAbility=Class'DEKRPG208.DruidArmorVampire',MaxLevels=(1,1,1,1,5,2,1,1,1,1,1,1,1,5,5,1,1,1,1,3,1,3,3,5,1,1,1))
     AbilityConfigs(66)=(AvailableAbility=Class'DEKRPG208.AbilityConstructionHealthBonus',MaxLevels=(0,0,0,0,7,5,0,0,0,0,0,0,0,9,7,0,0,0,0,5,0,5,5,7,0,0,0))
     AbilityConfigs(67)=(AvailableAbility=Class'DEKRPG208.AbilityEngineerAwareness',MaxLevels=(0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,1,0,1,1,1,0,0,0))
     AbilityConfigs(68)=(AvailableAbility=Class'DEKRPG208.AbilityRapidBuild',MaxLevels=(0,0,0,0,15,12,0,0,0,0,0,0,0,15,15,0,0,0,0,12,0,12,12,15,0,0,0))
     AbilityConfigs(69)=(AvailableAbility=Class'DEKRPG208.AbilityHybridEngineer',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,0,0,0,0))
     AbilityConfigs(70)=(AvailableAbility=Class'DEKRPG208.AbilityHybridEngineerWM',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0))
     AbilityConfigs(71)=(AvailableAbility=Class'DEKRPG208.AbilityDefenseSentinelResupply',MaxLevels=(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,5,0,0,0))
     AbilityConfigs(72)=(AvailableAbility=Class'DEKRPG208.AbilityDefenseSentinelHealing',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0))
     AbilityConfigs(73)=(AvailableAbility=Class'DEKRPG208.AbilityDefenseSentinelShields',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(74)=(AvailableAbility=Class'DEKRPG208.AbilityDefenseSentinelEnergy',MaxLevels=(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0))
     AbilityConfigs(75)=(AvailableAbility=Class'DEKRPG208.AbilityDefenseSentinelArmor',MaxLevels=(0,0,0,0,8,8,0,0,0,0,0,0,0,8,8,0,0,0,0,5,0,5,5,8,0,0,0))
     AbilityConfigs(76)=(AvailableAbility=Class'DEKRPG208.AbilitySpiderSteroids',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0))
     AbilityConfigs(77)=(AvailableAbility=Class'DEKRPG208.AbilityHardCore',MaxLevels=(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1))
     BotChance=1
}
