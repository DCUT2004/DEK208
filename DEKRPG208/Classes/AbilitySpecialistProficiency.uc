class AbilitySpecialistProficiency extends CostRPGAbility
	config(UT2004RPG) 
	abstract;
	
var config float DamageMultiplier;
var config int AdrenReductionPerLevel;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ArtifactSpecialize AS;
	local SpecialistInv Inv;
	local AdrenReducerInv AInv;
	
	AS = ArtifactSpecialize(Other.FindInventoryType(class'ArtifactSpecialize'));
	if (AS == None)
	{
		AS = Other.spawn(class'ArtifactSpecialize');		
		AS.giveTo(Other);
	}
	Inv = SpecialistInv(Other.FindInventoryType(class'SpecialistInv'));
	if (Inv == None)
	{
		Inv = Other.spawn(class'SpecialistInv');		
		Inv.giveTo(Other);
	}
	AInv = AdrenReducerInv(Other.FindInventoryType(class'AdrenReducerInv'));
	if (AInv == None)
	{
		AInv = Other.spawn(class'AdrenReducerInv');		
		AInv.AbilityLevel = AbilityLevel;
		AInv.AdrenReductionPerLevel = default.AdrenReductionPerLevel;
		AInv.giveTo(Other);
	}
	if(Other.SelectedItem == None)
		Other.NextItem();
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local SpecialistInv Inv;
	local Weapon W;
	local float incPerc;
	
	if (!bOwnedByInstigator)
		return;
	if (bOwnedByInstigator)
	{
		if (RPGWeapon(Instigator.Weapon) != None)
			W = RPGWeapon(Instigator.Weapon).ModifiedWeapon;
		else
			W = Instigator.Weapon;
		Inv = SpecialistInv(Instigator.FindInventoryType(class'SpecialistInv'));
		if (Inv != None)
		{
			if (Inv.SelectedWeapon != None)
			{
				if (Inv.SelectedWeapon == W)
				{
					if (!class'AbilityWeaponsProficiency'.static.KillsMaxed(incPerc))
					{
						if ((class'AbilityWeaponsProficiency'.static.GetIncPerc(incPerc) + (AbilityLevel*default.DamageMultiplier)) < class'AbilityWeaponsProficiency'.static.GetMaxIncrease())
							Damage *= 1 + (AbilityLevel*default.DamageMultiplier);	//WP damage + Specialist damage < than max, continue to supply additional damage
						else if (class'AbilityWeaponsProficiency'.static.GetIncPerc(incPerc) + (AbilityLevel*default.DamageMultiplier) >= class'AbilityWeaponsProficiency'.static.GetMaxIncrease() && class'AbilityWeaponsProficiency'.static.GetMaxIncrease() > class'AbilityWeaponsProficiency'.static.GetIncPerc(incPerc))
							Damage *= (1 + (class'AbilityWeaponsProficiency'.static.GetMaxIncrease() - class'AbilityWeaponsProficiency'.static.GetIncPerc(incPerc)));	//WP damage + Specialist damage >= max, supply only the differential damage
					}
					else
						return;		//weapon prof cap maxed, don't supply any damage
				}
			}
		}
	}
}

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local float incPerc;
	local int intPerc, SpecialistIntPerc;
	local Weapon W;
	local SpecialistInv Inv;
	local int x, y;
	local RPGStatsInv StatsInv;
	
	if (Weapon == None || Weapon.Owner == None || Pawn(Weapon.Owner) == None || Pawn(Weapon.Owner).PlayerReplicationInfo == None || PlayerController(Pawn(Weapon.Owner).Controller) == None)
		return;
	if (Weapon.Role != ROLE_Authority)
		return;
		
	StatsInv = RPGStatsInv(Pawn(Weapon.Owner).FindInventoryType(class'RPGStatsInv'));

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		if (StatsInv.Data.Abilities[x] == class'AbilityWeaponsProficiency')
			y = StatsInv.Data.AbilityLevels[x];
		
	if (RPGWeapon(Weapon) != None)
		W = RPGWeapon(Weapon).ModifiedWeapon;
	else
		W = Weapon;
		
	if (Pawn(Weapon.Owner) != None && Pawn(Weapon.Owner).Health > 0)
	Inv = SpecialistInv(Pawn(Weapon.Owner).FindInventoryType(class'SpecialistInv'));

	if(instr(caps(string(W)), "AVRIL") > -1)//hack for vinv avril
		class'AbilityWeaponsProficiency'.static.GetNumKillsForWeapon(incPerc, class'INAVRiL', TeamPlayerReplicationInfo(Pawn(Weapon.Owner).PlayerReplicationInfo), y);
	else
		class'AbilityWeaponsProficiency'.static.GetNumKillsForWeapon(incPerc, W.Class, TeamPlayerReplicationInfo(Pawn(Weapon.Owner).PlayerReplicationInfo), y);
			
	intPerc = 100 * incPerc;
	SpecialistIntPerc = (100 * incPerc)+(100 * AbilityLevel * default.DamageMultiplier);
	if (SpecialistIntPerc > (class'AbilityWeaponsProficiency'.static.GetMaxIncrease()*100))
		SpecialistIntPerc = (class'AbilityWeaponsProficiency'.static.GetMaxIncrease()*100);
	if (Inv != None)
	{
		if (Inv.SelectedWeapon == W)
		{
			PlayerController(Pawn(Weapon.Owner).Controller).ReceiveLocalizedMessage(Class'ProficiencyMessage', SpecialistIntPerc,,,W);
		}
		else if (Inv.SelectedWeapon != W)
			PlayerController(Pawn(Weapon.Owner).Controller).ReceiveLocalizedMessage(Class'ProficiencyMessage', intPerc,,,W);
	}
	else
		PlayerController(Pawn(Weapon.Owner).Controller).ReceiveLocalizedMessage(Class'ProficiencyMessage', intPerc,,,W);
}

defaultproperties
{
	 AdrenReductionPerLevel=10
	 DamageMultiplier=0.0500000
     PlayerLevelReqd(1)=180
	 RequiredAbilities(0)=Class'DEKRPG208.AbilityWeaponsProficiency'
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityDualityProficiency'
     AbilityName="Niche: Specialist"
     Description="You are granted the Weapon Specialize artifact. Use this artifact to select one weapon to specialize in. This weapon receives an extra 5% damage bonus per level, and will stack with weapons proficiency. In exchange, your max adrenaline is reduced by 10 per level.|You must have Weapons Proficiency before purchasing this ability. You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
