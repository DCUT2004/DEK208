class AbilityRootedSniper extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float CrouchMultiplier, RootedMultiplier, RootedCrouchMultiplier;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		Momentum = vect(0,0,0);
	if (bOwnedByInstigator)
	{
		if (DamageType == class'DamTypeSniperShot' || DamageType == class'DamTypeSniperHeadShot' || DamageType == class'DamTypeDEKRailGunShot' || DamageType == class'DamTypeDEKRailGunHeadShot' || DamageType == class'DamTypeShockBeam' || DamageType == class'DamTypeShockBall' || DamageType == class'DamTypeShockCombo' || DamageType == class'DamTypeClassicSniper' || DamageType == class'DamTypeClassicHeadShot' || DamageType == class'DamTypeMercuryAirHeadHit' || DamageType == class'DamTypeMercuryAirHit' || DamageType == class'DamTypeMercuryAirPunchThrough' || DamageType == class'DamTypeMercuryAirPunchThroughHead' || DamageType == class'DamTypeCryoarithmetic')
		{
			if (Instigator.bIsCrouched)
				Damage *= (1 + (AbilityLevel * default.CrouchMultiplier));
			if (VSize(Instigator.Velocity) ~= 0)
				Damage *= (1 + (AbilityLevel * default.RootedMultiplier));
			if (VSize(Instigator.Velocity) != 0 && !Instigator.bIsCrouched)
				Damage *= 0.3;
			if (Instigator.bIsCrouched && VSize(Instigator.Velocity) ~= 0)
				Damage *= (1 + (AbilityLevel * default.RootedCrouchMultiplier));
		}
	}
}

defaultproperties
{
     CrouchMultiplier=0.080000
	 RootedMultiplier=0.050000
	 RootedCrouchMultiplier=0.080000
     PlayerLevelReqd(1)=180
	 ExcludingAbilities(0)=Class'DEKRPG208.AbilityAssassinSniper'
     AbilityName="Niche: Rooted"
     Description="Increases your cumulative total damage bonus on sniper-type weapons by 5% while remaining stationary, and 8% while crouched or while both stationary and crouched. Damage is reduced if not crouching or stationary.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
