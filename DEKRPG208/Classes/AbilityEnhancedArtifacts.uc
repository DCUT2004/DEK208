class AbilityEnhancedArtifacts extends CostRPGAbility
	config(UT2004RPG);
	
var config int Lev1DAMMWAdren, Lev2DAMMWAdren, Lev3DAMMWAdren, Lev4DAMMWAdren, Lev5DAMMWAdren;
var config int Lev1DMMAdren, Lev2DMMAdren, Lev3DMMAdren, Lev4DMMAdren, Lev5DMMAdren;
var config int Lev1DDMAdren, Lev2DDMAdren, Lev3DDMAdren, Lev4DDMAdren, Lev5DDMAdren;
var config int Lev1RemoteAdren, Lev2RemoteAdren, Lev3RemoteAdren, Lev4RemoteAdren, Lev5RemoteAdren;
var config int Lev1ASICostPerSec, Lev2ASICostPerSec, Lev3ASICostPerSec, Lev4ASICostPerSec, Lev5ASICostPerSec;
var config int Lev1ASIAdren, Lev2ASIAdren, Lev3ASIAdren, Lev4ASIAdren, Lev5ASIAdren;
var config int Lev1ASDCostPerSec, Lev2ASDCostPerSec, Lev3ASDCostPerSec, Lev4ASDCostPerSec, Lev5ASDCostPerSec;
var config int Lev1ASDAdren, Lev2ASDAdren, Lev3ASDAdren, Lev4ASDAdren, Lev5ASDAdren;
var config int AdrenDecreasePerLevel;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	local bool ok;
	local int x;

	for (x = 0; x < Data.Abilities.length; x++)
	{
		if (Data.Abilities[x] == class'AbilityLoadedCraftsman')
			if (Data.AbilityLevels[x] >= 3)
				ok = true;
	}
	if (!ok)
		return 0;
	else
		return Super.Cost(Data, CurrentLevel);
}

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ArtifactSphereInvulnerability ASI;
	local ArtifactSphereDamage ASD;
	local ArtifactRemoteDamage ARD;
	local ArtifactRemoteInvulnerability ARI;
	local ArtifactRemoteMax ARM;
	local ArtifactRemoteAmplifier ARA;
	local DruidArtifactMakeMagicWeapon DAMMW;
	local DruidMaxModifier DMM;
	local DruidDoubleModifier DDM;

	ASI = ArtifactSphereInvulnerability(Other.FindInventoryType(class'ArtifactSphereInvulnerability'));

	ASD = ArtifactSphereDamage(Other.FindInventoryType(class'ArtifactSphereDamage'));

	ARD = ArtifactRemoteDamage(Other.FindInventoryType(class'ArtifactRemoteDamage'));

	ARI = ArtifactRemoteInvulnerability(Other.FindInventoryType(class'ArtifactRemoteInvulnerability'));

	ARM = ArtifactRemoteMax(Other.FindInventoryType(class'ArtifactRemoteMax'));
	
	ARA = ArtifactRemoteAmplifier(Other.FindInventoryType(class'ArtifactRemoteAmplifier'));

	DAMMW = DruidArtifactMakeMagicWeapon(Other.FindInventoryType(class'DruidArtifactMakeMagicWeapon'));

	DMM = DruidMaxModifier(Other.FindInventoryType(class'DruidMaxModifier'));

	DDM = DruidDoubleModifier(Other.FindInventoryType(class'DruidDoubleModifier'));
	
	if (ARA != None)
	{
		ARA.AdrenalineRequired -= (AbilityLevel * default.AdrenDecreasePerLevel);
	}
	
	if(AbilityLevel == 1)
	{
		DAMMW.AdrenalineRequired = (Default.Lev1DAMMWAdren);
		DMM.AdrenalineRequired = (Default.Lev1DMMAdren);
		DDM.CostPerSec = (Default.Lev1DDMAdren);
		ARI.AdrenalineRequired = (Default.Lev1RemoteAdren);
		ARD.AdrenalineRequired = (Default.Lev1RemoteAdren);
		ARM.AdrenalineRequired = (Default.Lev1DMMAdren);
		
	}
	if(AbilityLevel == 2)
	{
		DAMMW.AdrenalineRequired = (Default.Lev2DAMMWAdren);
		DMM.AdrenalineRequired = (Default.Lev2DMMAdren);
		DDM.CostPerSec = (Default.Lev2DDMAdren);
		ARI.AdrenalineRequired = (Default.Lev2RemoteAdren);
		ARD.AdrenalineRequired = (Default.Lev2RemoteAdren);
		ARM.AdrenalineRequired = (Default.Lev2DMMAdren);
	}
	if(AbilityLevel == 3)
	{
		DAMMW.AdrenalineRequired = (Default.Lev3DAMMWAdren);
		DMM.AdrenalineRequired = (Default.Lev3DMMAdren);
		DDM.CostPerSec = (Default.Lev3DDMAdren);
		ARI.AdrenalineRequired = (Default.Lev3RemoteAdren);
		ARD.AdrenalineRequired = (Default.Lev3RemoteAdren);
		ARM.AdrenalineRequired = (Default.Lev3DMMAdren);
	}
	if(AbilityLevel == 4)
	{
		DAMMW.AdrenalineRequired = (Default.Lev4DAMMWAdren);
		DMM.AdrenalineRequired = (Default.Lev4DMMAdren);
		DDM.CostPerSec = (Default.Lev4DDMAdren);
		ARI.AdrenalineRequired = (Default.Lev4RemoteAdren);
		ARD.AdrenalineRequired = (Default.Lev4RemoteAdren);
		ARM.AdrenalineRequired = (Default.Lev4DMMAdren);
	}
	if(AbilityLevel == 5)
	{
		DAMMW.AdrenalineRequired = (Default.Lev5DAMMWAdren);
		DMM.AdrenalineRequired = (Default.Lev5DMMAdren);
		DDM.CostPerSec = (Default.Lev5DDMAdren);
		ARI.AdrenalineRequired = (Default.Lev5RemoteAdren);
		ARD.AdrenalineRequired = (Default.Lev5RemoteAdren);
		ARM.AdrenalineRequired = (Default.Lev5DMMAdren);
	}
	if(AbilityLevel == 6)
	{
		DAMMW.AdrenalineRequired = (Default.Lev5DAMMWAdren);
		DMM.AdrenalineRequired = (Default.Lev5DMMAdren);
		DDM.CostPerSec = (Default.Lev5DDMAdren);
		ARI.AdrenalineRequired = (Default.Lev5RemoteAdren);
		ARD.AdrenalineRequired = (Default.Lev5RemoteAdren);
		ARM.AdrenalineRequired = (Default.Lev5DMMAdren);
		ASI.CostPerSec = (Default.Lev1ASICostPerSec);
		ASI.AdrenalineRequired = (Default.Lev1ASIAdren);
		ASD.CostPerSec = (Default.Lev1ASDCostPerSec);
		ASD.AdrenalineRequired = (Default.Lev1ASDAdren);
	}
	if(AbilityLevel == 7)
	{
		DAMMW.AdrenalineRequired = (Default.Lev5DAMMWAdren);
		DMM.AdrenalineRequired = (Default.Lev5DMMAdren);
		DDM.CostPerSec = (Default.Lev5DDMAdren);
		ARI.AdrenalineRequired = (Default.Lev5RemoteAdren);
		ARD.AdrenalineRequired = (Default.Lev5RemoteAdren);
		ARM.AdrenalineRequired = (Default.Lev5DMMAdren);
		ASI.CostPerSec = (Default.Lev2ASICostPerSec);
		ASI.AdrenalineRequired = (Default.Lev2ASIAdren);
		ASD.CostPerSec = (Default.Lev2ASDCostPerSec);
		ASD.AdrenalineRequired = (Default.Lev2ASDAdren);
	}
	if(AbilityLevel == 8)
	{
		DAMMW.AdrenalineRequired = (Default.Lev5DAMMWAdren);
		DMM.AdrenalineRequired = (Default.Lev5DMMAdren);
		DDM.CostPerSec = (Default.Lev5DDMAdren);
		ARI.AdrenalineRequired = (Default.Lev5RemoteAdren);
		ARD.AdrenalineRequired = (Default.Lev5RemoteAdren);
		ARM.AdrenalineRequired = (Default.Lev5DMMAdren);
		ASI.CostPerSec = (Default.Lev3ASICostPerSec);
		ASI.AdrenalineRequired = (Default.Lev3ASIAdren);
		ASD.CostPerSec = (Default.Lev3ASDCostPerSec);
		ASD.AdrenalineRequired = (Default.Lev3ASDAdren);
	}
	if(AbilityLevel == 9)
	{
		DAMMW.AdrenalineRequired = (Default.Lev5DAMMWAdren);
		DMM.AdrenalineRequired = (Default.Lev5DMMAdren);
		DDM.CostPerSec = (Default.Lev5DDMAdren);
		ARI.AdrenalineRequired = (Default.Lev5RemoteAdren);
		ARD.AdrenalineRequired = (Default.Lev5RemoteAdren);
		ARM.AdrenalineRequired = (Default.Lev5DMMAdren);
		ASI.CostPerSec = (Default.Lev4ASICostPerSec);
		ASI.AdrenalineRequired = (Default.Lev4ASIAdren);
		ASD.CostPerSec = (Default.Lev4ASDCostPerSec);
		ASD.AdrenalineRequired = (Default.Lev4ASDAdren);
	}
	if(AbilityLevel == 10)
	{
		DAMMW.AdrenalineRequired = (Default.Lev5DAMMWAdren);
		DMM.AdrenalineRequired = (Default.Lev5DMMAdren);
		DDM.CostPerSec = (Default.Lev5DDMAdren);
		ARI.AdrenalineRequired = (Default.Lev5RemoteAdren);
		ARD.AdrenalineRequired = (Default.Lev5RemoteAdren);
		ARM.AdrenalineRequired = (Default.Lev5DMMAdren);
		ASI.CostPerSec = (Default.Lev5ASICostPerSec);
		ASI.AdrenalineRequired = (Default.Lev5ASIAdren);
		ASD.CostPerSec = (Default.Lev5ASDCostPerSec);
		ASD.AdrenalineRequired = (Default.Lev5ASDAdren);
	}
}

defaultproperties
{
	 AdrenDecreasePerLevel=5
     Lev1DAMMWAdren=70
     Lev2DAMMWAdren=65
     Lev3DAMMWAdren=60
     Lev4DAMMWAdren=55
     Lev5DAMMWAdren=50
     Lev1DMMAdren=140
     Lev2DMMAdren=130
     Lev3DMMAdren=120
     Lev4DMMAdren=110
     Lev5DMMAdren=100
     Lev1DDMAdren=9
     Lev2DDMAdren=8
     Lev3DDMAdren=7
     Lev4DDMAdren=6
     Lev5DDMAdren=5
     Lev1RemoteAdren=90
     Lev2RemoteAdren=80
     Lev3RemoteAdren=70
     Lev4RemoteAdren=60
     Lev5RemoteAdren=50
     Lev1ASICostPerSec=17
     Lev2ASICostPerSec=16
     Lev3ASICostPerSec=15
     Lev4ASICostPerSec=14
     Lev5ASICostPerSec=12
     Lev1ASIAdren=67
     Lev2ASIAdren=62
     Lev3ASIAdren=57
     Lev4ASIAdren=52
     Lev5ASIAdren=47
     Lev1ASDCostPerSec=14
     Lev2ASDCostPerSec=13
     Lev3ASDCostPerSec=12
     Lev4ASDCostPerSec=11
     Lev5ASDCostPerSec=10
     Lev1ASDAdren=38
     Lev2ASDAdren=36
     Lev3ASDAdren=34
     Lev4ASDAdren=32
     Lev5ASDAdren=30
     LevelCost(1)=7
     LevelCost(2)=7
     LevelCost(3)=7
     LevelCost(4)=7
     LevelCost(5)=7
     LevelCost(6)=9
     LevelCost(7)=9
     LevelCost(8)=9
     LevelCost(9)=9
     LevelCost(10)=9
     RequiredAbilities(0)=Class'DEKRPG208.AbilityLoadedCraftsman'
     AbilityName="Enhanced Artifacts"
     Description="Each level of this ability will decrease the adrenaline cost of all your artifacts, except sphere artifacts and enchanter artifacts, by 10%, until level 5.|After level 5, each level will decrease the adrenaline cost of your sphere artifacts by 10%.||You will need to have Loaded Craftsman maxed before purchasing this ability.|Cost(per level): 7,7,7,7,7,9,9,9,9,9"
     MaxLevel=10
}
