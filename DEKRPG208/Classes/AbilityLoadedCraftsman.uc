//Placeholder Loaded Artifact ability for Craftsman Subclass
class AbilityLoadedCraftsman extends RPGDeathAbility
	config(UT2004RPG) 
	abstract;

var config Array< class<RPGArtifact> > Level1Artifact;
var config Array< class<RPGArtifact> > Level2Artifact;
var config Array< class<RPGArtifact> > Level3Artifact;

var config int AdrenDecreasePerLevel, CostPerSecReduction, SphereCostReduction;
var config float ProtectionMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local int x;
	local LoadedInv LoadedInv;
	local RPGStatsInv StatsInv;
	local CraftsmanInv Inv;

	LoadedInv = LoadedInv(Other.FindInventoryType(class'LoadedInv'));
	Inv = CraftsmanInv(Other.FindInventoryType(class'CraftsmanInv'));

	if(LoadedInv != None)
	{
		if(LoadedInv.bGotLoadedArtifacts && LoadedInv.LAAbilityLevel == AbilityLevel)
			return;
	}
	else
	{
		LoadedInv = Other.spawn(class'LoadedInv');
		LoadedInv.giveTo(Other);
	}

	if(LoadedInv == None)
		return;

	LoadedInv.bGotLoadedArtifacts = true;
	LoadedInv.LAAbilityLevel = AbilityLevel;

	if(AbilityLevel >= 2)
		LoadedInv.ProtectArtifacts = true;
	else
		LoadedInv.ProtectArtifacts = false;
		
	if(Inv == None)
	{
		Inv = Other.spawn(class'CraftsmanInv');
		Inv.giveTo(Other);
	}
		

	for(x = 0; x < default.Level1Artifact.length; x++)
		if (default.Level1Artifact[x] != None)
			giveArtifact(other, default.Level1Artifact[x], AbilityLevel);

	if(AbilityLevel > 1)
		for(x = 0; x < default.Level2Artifact.length; x++)
			if (default.Level2Artifact[x] != None)
				giveArtifact(other, default.Level2Artifact[x], AbilityLevel);

	if(AbilityLevel > 2)
	{
		for(x = 0; x < default.Level3Artifact.length; x++)
			if (default.Level3Artifact[x] != None)
				giveArtifact(other, default.Level3Artifact[x], AbilityLevel);
				Other.Controller.Adrenaline = Other.Controller.AdrenalineMax;	// extreme starts maxed
		Enhance(Other, AbilityLevel);
	}
		
	if(AbilityLevel >= 2)
	{
		// now check if we get the other hybrid artifacts
		StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

		for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		{
			if (StatsInv.Data.Abilities[x] == class'AbilityShieldHealing')
			{
			    // give them the shieldblast
			    giveArtifact(other, class'ArtifactShieldBlast', AbilityLevel);
			}
			if (StatsInv.Data.Abilities[x] == class'AbilityLoadedHealing' && StatsInv.Data.AbilityLevels[x] >= 2)
			{
			    // give them the healingblast
			    giveArtifact(other, class'ArtifactHealingBlast', AbilityLevel);
			}
		}
	}

	// I'm guessing that NextItem is here to ensure players don't start with
	// no item selected.  So the if should stop wierd artifact scrambles.
		if(Other.SelectedItem == None)
			Other.NextItem();
}

static function giveArtifact(Pawn other, class<RPGArtifact> ArtifactClass, int AbilityLevel)
{
	local RPGArtifact Artifact;

	if(Other.IsA('Monster'))
		return;
	if(Other.findInventoryType(ArtifactClass) != None)
		return; //they already have one
		
	Artifact = Other.spawn(ArtifactClass, Other,,, rot(0,0,0));
	if(Artifact != None)
	{
		Artifact.giveTo(Other);
	}
}

static function Enhance(Pawn other, int AbilityLevel)
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
	if (AbilityLevel >= 3)
	{
		if (ASI != None)
		{
			ASI.CostPerSec -= (default.CostPerSecReduction);
			ASI.AdrenalineRequired -= (default.SphereCostReduction);
			if (ASI.AdrenalineRequired < 20)
				ASI.AdrenalineRequired = 20;
		}
		if (ASD != None)
		{
			ASD.CostPerSec -= (default.CostPerSecReduction);
			ASD.AdrenalineRequired -= (default.SphereCostReduction);
			if (ASD.AdrenalineRequired < 20)
				ASD.AdrenalineRequired = 20;
		}
		if (ARD != None)
		{
			ARD.AdrenalineRequired -= (default.AdrenDecreasePerLevel);
		}
		if (ARI != None)
		{
			ARI.AdrenalineRequired -= (default.AdrenDecreasePerLevel);
		}
		if (ARM != None)
		{
			ARM.AdrenalineRequired -= (default.AdrenDecreasePerLevel);
		}
		if (ARA != None)
		{
			ARA.AdrenalineRequired -= (default.AdrenDecreasePerLevel);
		}
		if (DAMMW != None)
		{
			DAMMW.AdrenalineRequired -= (default.AdrenDecreasePerLevel);
		}
		if (DMM != None)
		{
			DMM.AdrenalineRequired -= (default.AdrenDecreasePerLevel);
		}
		if (DDM != None)
		{
			DDM.CostPerSec -= (default.CostPerSecReduction);
		}
	}
}

static function GenuineDeath(Pawn Killed, Controller Killer, class<DamageType> DamageType, vector HitLocation, int AbilityLevel)
{
	Local Inventory inv;

// If we end up with some wierdness here, it would be because we haven't
// ejected the player.  However, we shouldn't have to worry about that
// any more; it should be handled elsewhere, if needed.
	if(Killed.isA('Vehicle'))
	{
		Killed = Vehicle(Killed).Driver;
	}
// Wierdness - looks like sometimes PD called twice, particularly in VINV?
// Killed can become "None" somewhere along the line.
	if(Killed == None)
	{
		return;
	}

	for (inv=Killed.Inventory ; inv != None ; inv=inv.Inventory)
	{
		if(ClassIsChildOf(inv.class, class'UT2004RPG.RPGArtifact'))
		{
// Important note: *NO* artifact currently in possession will get dropped!
			inv.PickupClass = None;
		}
	}

	return;
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(bOwnedByInstigator)
		return; //if the instigator is doing the damage, ignore this.
	if(Damage > 0)
	{
		Damage *= (1-(AbilityLevel * default.ProtectionMultiplier));
	}
}

static function bool OverridePickupQuery(Pawn Other, Pickup item, out byte bAllowPickup, int AbilityLevel)
{
	if (ClassIsChildOf(item.InventoryType, class'EnhancedRPGArtifact') || ClassIsChildOf(item.InventoryType, class'DruidArtifactMakeMagicWeapon'))
	{
		if(Other.findInventoryType(item.InventoryType) != None)
		{
			bAllowPickup = 0;	// not allowed
			return true; 		//they already have one, and ours is probably enhanced already
		}
	}
	return false;		// don't know, so let someone else decide
}

defaultproperties
{
     Level1Artifact(0)=Class'DEKRPG208.DruidArtifactMakeMagicWeapon'
     Level1Artifact(1)=Class'DEKRPG208.DruidMaxModifier'
     Level1Artifact(2)=Class'DEKRPG208.ArtifactPlusAddon'
     Level2Artifact(0)=Class'DEKRPG208.DruidDoubleModifier'
     Level2Artifact(1)=Class'DEKRPG208.DruidPlusOneModifier'
     Level2Artifact(2)=Class'DEKRPG208.ArtifactRemoteMax'
     Level2Artifact(3)=Class'DEKRPG208.ArtifactRemoteDamage'
     Level2Artifact(4)=Class'DEKRPG208.ArtifactRemoteInvulnerability'
     Level2Artifact(5)=Class'DEKRPG208.ArtifactRemoteAmplifier'
     Level3Artifact(0)=Class'DEKRPG208.ArtifactSphereInvulnerability'
     Level3Artifact(1)=Class'DEKRPG208.ArtifactSphereDamage'
     Level3Artifact(2)=Class'DEKRPG208.ArtifactMakeInfinity'
     Level3Artifact(3)=Class'DEKRPG208.ArtifactMakeLucky'
     Level3Artifact(4)=Class'DEKRPG208.ArtifactMakeMatrix'
     Level3Artifact(5)=Class'DEKRPG208.ArtifactMakeGorgon'
     Level3Artifact(6)=Class'DEKRPG208.ArtifactMakeHeavyGuard'
	 AdrenDecreasePerLevel=50
	 CostPerSecReduction=5
	 SphereCostReduction=20
     ProtectionMultiplier=-0.100000
     AbilityName="Loaded Craftsman"
     Description="Learn to craft magic weapons at a lower adrenaline cost, and support your allies with more efficient remote and sphere artifacts. When you spawn:|Level 1: You are granted the Magic Weapon Maker, Max Modifier, and Plus Addon artifacts.|Level 2: You are granted the Double Modifier and remote artifacts, and breakable artifacts are made unbreakable.|Level 3: You get the Sphere artifacts and Enchanter artifacts, and the adrenaline cost on all artifacts from this ability is reduced.|Each level of this ability decreases your damage reduction by 10%.|Note: You need Magic Vault if you are going to use the Enchanter artifacts. Cost (per level): 7,14,21"
     StartingCost=7
     CostAddPerLevel=7
     MaxLevel=3
}
