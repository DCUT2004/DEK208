class AbilityDEKLoadedHealing extends CostRPGAbility
	config(UT2004RPG)
	abstract;

var config int Lev2Cap;
var config int Lev3Cap;
var config int Lev4Cap;
var config int Lev5Cap;
var config int Lev6Cap;
var config int Lev7Cap;
var config int Lev8Cap;
var config int Lev9Cap;
var config int Lev10Cap;

var config bool enableSpheres;

var config float WeaponDamage;
var config float Lev2HealingDamage;
var config float Lev3HealingDamage;
var config float AdrenalineUsage;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ArtifactMakeSuperHealer AMSH;
	local ArtifactHealingBlast AHB;
	local ArtifactSphereHealing ASpH;
	local ArtifactRemoteBooster ARB;
	local ArtifactPoisonBlast APB;
	local RPGStatsInv StatsInv;
	local int x;

	if(Monster(Other) != None)
		return; //Not for pets

	AMSH = ArtifactMakeSuperHealer(Other.FindInventoryType(class'ArtifactMakeSuperHealer'));

	if(AMSH != None)
	{
		if(AMSH.AbilityLevel == AbilityLevel)
			return;
	}
	else
	{
		AMSH = Other.spawn(class'ArtifactMakeSuperHealer', Other,,, rot(0,0,0));
		if(AMSH == None)
			return; //get em next pass I guess?

		AMSH.giveTo(Other);
		// I'm guessing that NextItem is here to ensure players don't start with
		// no item selected.  So the if should stop wierd artifact scrambles.
		if(Other.SelectedItem == None)
			Other.NextItem();
	}
	AMSH.AbilityLevel = AbilityLevel;
	if(AbilityLevel == 2)
	{
		AMSH.MaxHealth = Default.Lev2Cap;

		// check if we have LA, in which case we get the blast anyway
		StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

		for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		{
			if (StatsInv.Data.Abilities[x] == class'DruidArtifactLoaded')
			{
			    if (StatsInv.Data.AbilityLevels[x] >= 1)
			    {
					AHB = ArtifactHealingBlast(Other.FindInventoryType(class'ArtifactHealingBlast'));
					if(AHB == None)
					{
						AHB = Other.spawn(class'ArtifactHealingBlast', Other,,, rot(0,0,0));
						if(AHB == None)
							return; //get em next pass I guess?

						AHB.giveTo(Other);
						// I'm guessing that NextItem is here to ensure players don't start with
						// no item selected.  So the if should stop weird artifact scrambles.
						if(Other.SelectedItem == None)
							Other.NextItem();
					}
			    }
			}
		}
 	}
	if(AbilityLevel >= 3)
	{
		AMSH.MaxHealth = Default.Lev3Cap;
	}
	if (AbilityLevel >= 4)
	{
		AMSH.MaxHealth = Default.Lev4Cap;
	}
	if (AbilityLevel >= 5)
	{
		AMSH.MaxHealth = Default.Lev5Cap;
		AMSH.HealingDamage = default.Lev2HealingDamage;
		if(default.enableSpheres)
		{
			// ok let's give them some artifacts
			ASpH = ArtifactSphereHealing(Other.FindInventoryType(class'ArtifactSphereHealing'));
			if(ASpH == None)
			{
				ASpH = Other.spawn(class'ArtifactSphereHealing', Other,,, rot(0,0,0));
				if(ASpH == None)
					return; //get em next pass I guess?

				if (AbilityLevel >= 8)
					ASpH.EnhanceArtifact(default.AdrenalineUsage);
				ASpH.giveTo(Other);
				// I'm guessing that NextItem is here to ensure players don't start with
				// no item selected.  So the if should stop weird artifact scrambles.
				if(Other.SelectedItem == None)
					Other.NextItem();
			}
			AHB = ArtifactHealingBlast(Other.FindInventoryType(class'ArtifactHealingBlast'));
			if(AHB == None)
			{
				AHB = Other.spawn(class'ArtifactHealingBlast', Other,,, rot(0,0,0));
				if(AHB == None)
					return; //get em next pass I guess?

				if (AbilityLevel >= 8)
					AHB.EnhanceArtifact(default.AdrenalineUsage);
				AHB.giveTo(Other);
				// I'm guessing that NextItem is here to ensure players don't start with
				// no item selected.  So the if should stop weird artifact scrambles.
				if(Other.SelectedItem == None)
					Other.NextItem();
			}
		}
	}
	if (AbilityLevel >= 6)
	{
		AMSH.HealingDamage = default.Lev2HealingDamage;
		AMSH.MaxHealth = Default.Lev6Cap;
	}
	if (AbilityLevel >= 7)
	{
		AMSH.HealingDamage = default.Lev2HealingDamage;
		AMSH.MaxHealth = Default.Lev7Cap;
	}	
	if (AbilityLevel >= 8)
	{
		AMSH.HealingDamage = default.Lev3HealingDamage;
		AMSH.MaxHealth = Default.Lev8Cap;
		APB = ArtifactPoisonBlast(Other.FindInventoryType(class'ArtifactPoisonBlast'));
		if(APB == None)
		{
			APB = Other.spawn(class'ArtifactPoisonBlast', Other,,, rot(0,0,0));
			if(APB == None)
				return; //get em next pass I guess?

			if (AbilityLevel >= 8)
				APB.EnhanceArtifact(default.AdrenalineUsage);
			APB.giveTo(Other);
			// I'm guessing that NextItem is here to ensure players don't start with
			// no item selected.  So the if should stop weird artifact scrambles.
			if(Other.SelectedItem == None)
				Other.NextItem();
		}
	}
	if (AbilityLevel >= 9)
	{
		AMSH.HealingDamage = default.Lev3HealingDamage;
		AMSH.MaxHealth = Default.Lev9Cap;
	}
	if (AbilityLevel >= 10)
	{
		AMSH.HealingDamage = default.Lev3HealingDamage;
		AMSH.MaxHealth = Default.Lev10Cap;
		// and a remote booster artifact
		ARB = ArtifactRemoteBooster(Other.FindInventoryType(class'ArtifactRemoteBooster'));
		if(ARB == None)
		{
			ARB = Other.spawn(class'ArtifactRemoteBooster', Other,,, rot(0,0,0));
			if(ARB == None)
				return; //get em next pass I guess?
	
			ARB.giveTo(Other);
			// I'm guessing that NextItem is here to ensure players don't start with
			// no item selected.  So the if should stop weird artifact scrambles.
			if(Other.SelectedItem == None)
				Other.NextItem();
		}		
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0 && AbilityLevel >= 8)
	{
		// half weapon damage
		if (ClassIsChildOf(DamageType, class'WeaponDamageType') || ClassIsChildOf(DamageType, class'VehicleDamageType'))
			Damage *= default.WeaponDamage;
	}
}

defaultproperties
{
     Lev2Cap=40
     Lev3Cap=60
     Lev4Cap=80
     Lev5Cap=100
     Lev6Cap=120
     Lev7Cap=150
     Lev8Cap=160
     Lev9Cap=180
     Lev10Cap=200
     WeaponDamage=0.500000
     Lev2HealingDamage=2.000000
     Lev3HealingDamage=3.000000
     AdrenalineUsage=0.500000
     AbilityName="Loaded Medic"
     Description="Gives you bonuses towards healing.|Level 1 gives you a Medic Weapon Maker.|Each level of Loaded Healing thereafter allows you to use the Medic Gun to heal teammates +20 beyond their max health. |Level 5 grants you the Healing Sphere and Healing Blast artifacts, and your healing output is doubled.|Level 8, for the Healer subclass, triples your healing output and reduces adrenaline for healing artifacts, but also reduces weapon damage.|Level 10 grants the Remote Booster artifact.|Cost (per level): 7"
     StartingCost=7
     BotChance=7
     MaxLevel=10
}
