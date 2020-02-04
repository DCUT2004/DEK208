class AbilityExperiencedArtifacts extends CostRPGAbility
	config(UT2004RPG);
	
var config float Lev1DamageExp, Lev1InvExp, Lev1RemoteExp;
var config float Lev2DamageExp, Lev2InvExp, Lev2RemoteExp;
var config float Lev3DamageExp, Lev3InvExp, Lev3RemoteExp;
var config float Lev4DamageExp, Lev4InvExp, Lev4RemoteExp;
var config float Lev5DamageExp, Lev5InvExp, Lev5RemoteExp;
var config int Lev1RemoteMaxExp, Lev2RemoteMaxExp, Lev3RemoteMaxExp, Lev4RemoteMaxExp, Lev5RemoteMaxExp;

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

	ASI = ArtifactSphereInvulnerability(Other.FindInventoryType(class'ArtifactSphereInvulnerability'));
	ASD = ArtifactSphereDamage(Other.FindInventoryType(class'ArtifactSphereDamage'));
	ARD = ArtifactRemoteDamage(Other.FindInventoryType(class'ArtifactRemoteDamage'));
	ARI = ArtifactRemoteInvulnerability(Other.FindInventoryType(class'ArtifactRemoteInvulnerability'));
	ARM = ArtifactRemoteMax(Other.FindInventoryType(class'ArtifactRemoteMax'));
	ARA = ArtifactRemoteAmplifier(Other.FindInventoryType(class'ArtifactRemoteAmplifier'));
	
	if(AbilityLevel == 1)
	{
		ASD.KillXPPerc = Default.Lev1DamageExp;
		ASI.ExpPerDamage = Default.Lev1InvExp;
		ARD.XPforUse = Default.Lev1RemoteExp;
		ARI.XPforUse = Default.Lev1RemoteExp;
		ARM.XPforUse = Default.Lev1RemoteMaxExp;
		ARA.XPforUse = Default.Lev1RemoteMaxExp;
		
	}
	if(AbilityLevel == 2)
	{
		ASD.KillXPPerc = Default.Lev2DamageExp;
		ASI.ExpPerDamage = Default.Lev2InvExp;
		ARD.XPforUse = Default.Lev2RemoteExp;
		ARI.XPforUse = Default.Lev2RemoteExp;
		ARM.XPforUse = Default.Lev2RemoteMaxExp;
		ARA.XPforUse = Default.Lev2RemoteMaxExp;
	}
	if(AbilityLevel == 3)
	{
		ASD.KillXPPerc = Default.Lev3DamageExp;
		ASI.ExpPerDamage = Default.Lev3InvExp;
		ARD.XPforUse = Default.Lev3RemoteExp;
		ARI.XPforUse = Default.Lev3RemoteExp;
		ARM.XPforUse = Default.Lev3RemoteMaxExp;
		ARA.XPforUse = Default.Lev3RemoteMaxExp;
	}
	if(AbilityLevel == 4)
	{
		ASD.KillXPPerc = Default.Lev4DamageExp;
		ASI.ExpPerDamage = Default.Lev4InvExp;
		ARD.XPforUse = Default.Lev4RemoteExp;
		ARI.XPforUse = Default.Lev4RemoteExp;
		ARM.XPforUse = Default.Lev4RemoteMaxExp;
		ARA.XPforUse = Default.Lev4RemoteMaxExp;
	}
	if(AbilityLevel == 5)
	{
		ASD.KillXPPerc = Default.Lev5DamageExp;
		ASI.ExpPerDamage = Default.Lev5InvExp;
		ARD.XPforUse = Default.Lev5RemoteExp;
		ARI.XPforUse = Default.Lev5RemoteExp;
		ARM.XPforUse = Default.Lev5RemoteMaxExp;
		ARA.XPforUse = Default.Lev5RemoteMaxExp;
	}
}

defaultproperties
{
     Lev1DamageExp=0.300000
     Lev1InvExp=0.040000
     Lev1RemoteExp=11.000000
     Lev2DamageExp=0.350000
     Lev2InvExp=0.050000
     Lev2RemoteExp=12.000000
     Lev3DamageExp=0.400000
     Lev3InvExp=0.060000
     Lev3RemoteExp=13.000000
     Lev4DamageExp=0.450000
     Lev4InvExp=0.070000
     Lev4RemoteExp=14.000000
     Lev5DamageExp=0.500000
     Lev5InvExp=0.080000
     Lev5RemoteExp=15.000000
     Lev1RemoteMaxExp=21
     Lev2RemoteMaxExp=22
     Lev3RemoteMaxExp=23
     Lev4RemoteMaxExp=24
     Lev5RemoteMaxExp=25
     RequiredAbilities(0)=Class'DEKRPG208.AbilityLoadedCraftsman'
     AbilityName="Experienced Artifacts"
     Description="Increases the XP of your team artifacts including remotes and spheres.||You will need to have Loaded Craftsman maxed before purchasing this ability.|Cost(per level): 5,10,15,20,25"
     StartingCost=5
     CostAddPerLevel=5
     MaxLevel=5
}
