class AbilityDualityProficiency extends CostRPGAbility
	config(UT2004RPG) 
	abstract;
	
var config float DamageMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local DualityInv Inv;
	local ArtifactDualOne ADO;
	local ArtifactDualTwo ADT;
	local int x, y;
	local RPGStatsInv StatsInv;

	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		if (StatsInv.Data.Abilities[x] == class'AbilityWeaponsProficiency')
			y = StatsInv.Data.AbilityLevels[x];
			
	Inv = DualityInv(Other.FindInventoryType(class'DualityInv'));
	if (Inv == None)
	{
		Inv = Other.spawn(class'DualityInv');		
		Inv.giveTo(Other);
		Inv.AbilityLevel = y;
		Inv.LevMultiplier = class'AbilityWeaponsProficiency'.static.GetLevMultiplier();
		Inv.MaxIncrease = class'AbilityWeaponsProficiency'.static.GetMaxIncrease();
	}
	
	if (Inv!= None)
	{
		if (Inv.DualWeaponOne == None)
		{
			ADO = ArtifactDualOne(Other.FindInventoryType(class'ArtifactDualOne'));
			if (ADO == None)
			{
				ADO = Other.spawn(class'ArtifactDualOne');		
				ADO.giveTo(Other);
			}
		}
		if (Inv.DualWeaponTwo == None)
		{
			ADT = ArtifactDualTwo(Other.FindInventoryType(class'ArtifactDualTwo'));
			if (ADT == None)
			{
				ADT = Other.spawn(class'ArtifactDualTwo');		
				ADT.giveTo(Other);
			}
		}
	}
	if(Other.SelectedItem == None)
		Other.NextItem();
}

static function ScoreKill(Controller Killer, Controller Killed, bool bOwnedByKiller, int AbilityLevel)
{
	local DualityInv Inv;
	local Weapon W;
	
	if ( Killed == Killer || Killed == None || Killer == None || Killed.Level == None || Killed.Level.Game == None)
		return;
	
	if (Killer != None && Killer.Pawn != None && Killer.Pawn.Health > 0)
		Inv = DualityInv(Killer.Pawn.FindInventoryType(class'DualityInv'));
	if (RPGWeapon(Killer.Pawn.Weapon) != None)
		W = RPGWeapon(Killer.Pawn.Weapon).ModifiedWeapon;
	else
		W = Killer.Pawn.Weapon;
	if (bOwnedByKiller)
	{
		if (Inv != None)
		{
			if (Inv.DualWeaponOne != None || Inv.DualWeaponTwo != None)
			{
				if (W == Inv.DualWeaponOne || W == Inv.DualWeaponTwo)
				{
					Inv.AddKill(1);
				}
				else
					return;
			}
			else if (Inv.DualWeaponOne == None && Inv.DualWeaponTwo == None)
				return;
		}
		else
			return;
	}
	else
		return;
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if (bOwnedByInstigator)
		return;
	else
	{
		if (Damage > 0)
			Damage *= (1 + (AbilityLevel * default.DamageMultiplier));
	}
}


defaultproperties
{
	 DamageMultiplier=0.250000
     PlayerLevelReqd(1)=180
	 RequiredAbilities(0)=Class'DEKRPG208.AbilityWeaponsProficiency'
     ExcludingAbilities(0)=Class'DEKRPG208.AbilitySpecialistProficiency'
	 ExcludingAbilities(1)=Class'DEKRPG208.AbilityGunsmithProficiency'
     AbilityName="Niche: Duality"
     Description="You are granted the Duality artifacts. Use the artifact to select two weapons. Making kills with either weapons will increase the proficiency bonus for both weapons. If you die, your proficiency bonus will save and can be reapplied to two new weapons after respawning.|In exchange, the proficiency bonus will not apply to other weapons, and your damage reduction is lowered.|You must have Weapons Proficiency before purchasing this ability. You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost: 50."
     StartingCost=50
     MaxLevel=1
}
