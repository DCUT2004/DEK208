class AbilityPowerEAM extends CostRPGAbility
	config(UT2004RPG) 
	abstract;
	
var config float LightningMaxDamageMultiplier;
var config float DamageMultiplier;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	local bool ok;
	local int x;

	for (x = 0; x < Data.Abilities.length; x++)
	{
		if (Data.Abilities[x] == class'DruidArtifactLoaded')
			if (Data.AbilityLevels[x] > 4)
				ok = true;
	}
	if (!ok)
		return 0;
	else
		return Super.Cost(Data, CurrentLevel);
}

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local PowerAMInv Inv;
	local DruidArtifactLightningRod Rod;
	local ArtifactChainLightning Chain;
	local ArtifactLightningBolt Bolt;
	local ArtifactLightningBeam Beam;
	
	if (Other != None)
	{
		Inv = PowerAMInv(Other.FindInventoryType(class'PowerAMInv'));		
		Rod = DruidArtifactLightningRod(Other.FindInventoryType(class'DruidArtifactLightningRod'));
		Chain = ArtifactChainLightning(Other.FindInventoryType(class'ArtifactChainLightning'));
		Bolt = ArtifactLightningBolt(Other.FindInventoryType(class'ArtifactLightningBolt'));
		Beam = ArtifactLightningBeam(Other.FindInventoryType(class'ArtifactLightningBeam'));
		
		if (Inv == None)
		{
			Inv = Other.Spawn(class'PowerAMInv', Other);
			Inv.GiveTo(Other);
		}
		if (Bolt != None)
			Bolt.MaxDamage *= default.LightningMaxDamageMultiplier;
		if (Beam != None)
		{
			Beam.MaxDamage *= default.LightningMaxDamageMultiplier;
			Beam.MaxRAnge *= default.LightningMaxDamageMultiplier;
		}
		if (Rod != None)
		{
			Rod.MaxDamagePerHit *= default.LightningMaxDamageMultiplier;
			Rod.MinDamagePerHit *=  default.LightningMaxDamageMultiplier;
		}
		if (Chain != None)
		{
			Chain.MaxSteps *=  default.LightningMaxDamageMultiplier;
			Chain.MaxStepRange *=  default.LightningMaxDamageMultiplier;
		}
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if (!bOwnedByInstigator)
		return;
	if (Damage > 0 && bOwnedByInstigator)
	{
		if (ClassIsChildOf(DamageType, class'DamageType') && !ClassIsChildOf(DamageType, class'WeaponDamageType') && !ClassIsChildOf(DamageType, class'VehicleDamageType'))
		{
			Damage *= (1+(AbilityLevel*default.DamageMultiplier));
		}
	}
}

defaultproperties
{
	 LightningMaxDamageMultiplier=1.50000
	 DamageMultiplier=0.2000
	 ExcludingAbilities(0)=Class'DEKRPG208.AbilityWizardEAM'
	 ExcludingAbilities(1)=Class'DEKRPG208.AbilityMaxedEAM'
     PlayerLevelReqd(1)=180
     AbilityName="Niche: Power"
     Description="Increases artifact damage by 20% per level, but also increases the adrenaline cost of artifacts.|You must be level 180 to buy a niche. You need Loaded Artifacts 5 before purchasing this ability. You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
