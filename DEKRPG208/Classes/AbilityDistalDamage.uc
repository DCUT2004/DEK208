class AbilityDistalDamage extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float LevMultiplier;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if (DamageType == class'DamTypeRetaliation' || Injured == None || Instigator == None || Injured == Instigator || Damage <= 0)
		return;

	if(!bOwnedByInstigator)
		return;
	if(bOwnedByInstigator)
	{
		if(DamageType == class'DamTypeSniperShot' || DamageType == class'DamTypeSniperHeadShot' || DamageType == class'DamTypeDEKRailGunShot' || DamageType == class'DamTypeDEKRailGunHeadShot' || DamageType == class'DamTypeShockBeam' || DamageType == class'DamTypeShockBall' || DamageType == class'DamTypeShockCombo' || DamageType == class'DamTypeClassicSniper' || DamageType == class'DamTypeClassicHeadShot' || DamageType == class'DamTypeMercuryAirHeadHit' || DamageType == class'DamTypeMercuryAirHit' || DamageType == class'DamTypeMercuryAirPunchThrough' || DamageType == class'DamTypeMercuryAirPunchThroughHead' || DamageType == class'DamTypeCryoarithmetic')
		{
			Damage *= (1 + (AbilityLevel * default.LevMultiplier));
		}
	}
}

defaultproperties
{
     LevMultiplier=0.150000
     MinPlayerLevel=60
     PlayerLevelStep=2
     AbilityName="Distal Damage"
     Description="Increases your cumulative damage bonus by 15% per level for sniper-type weapons including the Sniper Rifle, Lightning Gun, Shock Rifle beam, Rail Gun, Mercury Missile, and Cryoarithmetic Equalizer.|Cost (per level): 10. You must be level 60 to purchase the first level of this ability, level 62 to purchase the second level, and so on."
     StartingCost=10
     MaxLevel=20
}
