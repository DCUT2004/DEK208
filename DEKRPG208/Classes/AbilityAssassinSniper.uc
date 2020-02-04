class AbilityAssassinSniper extends CostRPGAbility
	config(UT2004RPG) 
	abstract;
	
var config float DamageMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ArtifactAssassin AA;
	local AssassinInv Inv;
	
	AA = ArtifactAssassin(Other.FindInventoryType(class'ArtifactAssassin'));
	if (AA == None)
	{
		AA = Other.spawn(class'ArtifactAssassin');		
		AA.giveTo(Other);
	}
	Inv = AssassinInv(Other.FindInventoryType(class'AssassinInv'));
	if (Inv == None)
	{
		Inv = Other.spawn(class'AssassinInv');		
		Inv.giveTo(Other);
	}
	if(Other.SelectedItem == None)
		Other.NextItem();
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local AssassinInv Inv;
	
	if (!bOwnedByInstigator)
		return;
	if (bOwnedByInstigator)
	{
		Inv = AssassinInv(Instigator.FindInventoryType(class'AssassinInv'));
		if ((DamageType == class'DamTypeSniperShot' || DamageType == class'DamTypeSniperHeadShot' || DamageType == class'DamTypeDEKRailGunShot' || DamageType == class'DamTypeDEKRailGunHeadShot' || DamageType == class'DamTypeShockBeam' || DamageType == class'DamTypeShockBall' || DamageType == class'DamTypeShockCombo' || DamageType == class'DamTypeClassicSniper' || DamageType == class'DamTypeClassicHeadShot' || DamageType == class'DamTypeMercuryAirHeadHit' || DamageType == class'DamTypeMercuryAirHit' || DamageType == class'DamTypeMercuryAirPunchThrough' || DamageType == class'DamTypeMercuryAirPunchThroughHead' || DamageType == class'DamTypeCryoarithmetic'))
		{
			if (Inv != None && Inv.Target != None)
			{
				if (Injured == Inv.Target)
					Damage *= 1 + (AbilityLevel*default.DamageMultiplier);
				else
					Damage *= 0.5;
			}
			else if (Inv == None || Inv.Target == None)
				Damage *= 0.5;
		}
	}
}

defaultproperties
{
	 DamageMultiplier=0.1000000
     PlayerLevelReqd(1)=180
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityRootedSniper'
     AbilityName="Niche: Assassin"
     Description="You are granted the Assassin Mark artifact. Use the artifact to mark a target. This target will take an extra 10% damage per level from a sniper-type weapon. Unmarked targets will receive less damage.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
