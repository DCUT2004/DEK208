class AbilityEarthShield extends CostRPGAbility
	config(UT2004RPG) 
	abstract;


var config float ProtectionMultiplier;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(bOwnedByInstigator)
		return; //if the instigator is doing the damage, ignore this.
		
	if((DamageType == class'DamTypeBruteRocket' ||
		DamageType == class'DamTypeWarlordRocket' ||
		DamageType == class'SMPDamTypeMerceRocket' ||
		DamageType == class'SMPDamTypeTitanRock' ||
		DamageType == class'DamTypeBehemothRocket' ||
		DamageType == class'DamTypeDCBruteRocket' ||
		DamageType == class'DamTypeDCWarlordRocket' ||
		DamageType == class'DamTypeShellGasbag' ||
		DamageType == class'DamTypeEliteMercenaryAmmo' ||
		DamageType == class'DamTypeEliteMercenaryRocket' ||
		DamageType == class'DamTypeMercenaryAmmo' ||
		DamageType == class'DamTypeMercenaryRocket' ||
		Damagetype == class'DamTypeTitanRock' ||
		DamageType == class'MeleeDamage' ||
		DamageType == class'DamTypeRazorfly' ||
		DamageType == class'DamTypePupae' ||
		DamageType == class'DamTypeGiantRazorFly' ||
		DamageType == class'DamTypeNullWarlord' ||
		DamageType == class'DamTypeShellGasbag' ||
		DamageType == class'DamTypeAssaultBullet' ||
		DamageType == class'DamTypeAssaultGrenade' ||
		DamageType == class'DamTypeFlakChunk' ||
		DamageType == class'DamTypeFlakShell' ||
		DamageType == class'DamTypeMinigunAlt' ||
		DamageType == class'DamTypeMinigunBullet' ||
		DamageType == class'DamTypeRedeemer' ||
		DamageType == class'DamTypeRocket' ||
		DamageType == class'DamTypeRocketHoming' ||
		DamageType == class'DamTypeONSChainGun' ||
		DamageType == class'DamTypeONSGrenade' ||
		DamageType == class'DamTypeONSMine' ||
		DamageType == class'DamTypeTankShell' ||
		DamageType == class'DamTypeNecroSkeleton' ||
		DamageType == class'DamTypeNecroSkull' ||
		DamageType == class'DamTypeTechBehemothRocket' ||
		DamageType == class'DamTypeTechPupae' ||
		DamageType == class'DamTypeTechQueen' ||
		DamageType == class'DamTypeTechRazorfly' ||
		DamageType == class'DamTypeTechSkaarj' ||
		DamageType == class'DamTypeTechSlithMine' ||
		DamageType == class'DamTypeTechSlug' ||
		DamageType == class'DamTypeTechTitanRock' ||
		DamageType == class'DamTypeTechTitanMine' ||
		DamageType == class'DamTypeTechWarlord' ||
		DamageType == class'DamTypeUltima') && Damage > 0)
	{
		Damage *= (abs(1-(AbilityLevel * default.ProtectionMultiplier)));
		if (Damage == 0)
			Damage = 1;
	}
}

defaultproperties
{
     ProtectionMultiplier=0.050000
     ExcludingAbilities(0)=Class'DEKExtras208.AbilityTwinCoreShield'
     ExcludingAbilities(1)=Class'DEKExtras208.AbilityPlasmaShield'
     AbilityName="Earth Shield"
     Description="Reduces damage from normal rocket, bullet, tech, rock-type, melee, ultima and redeemer attacks by 5% per level (including normal Titans, Gnats, Techs, and Ultima Bunnies). You can not have more than one type of shield at a time.|Cost (per level): 5,10,15,20..."
     StartingCost=5
     CostAddPerLevel=5
     MaxLevel=10
}
