class AbilityTwinCoreShield extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float ProtectionMultiplier;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if ((DamageType == class'DamTypeFireTitan' ||
		DamageType == class'DamTypeSuperHeat'||
		DamageType == class'DamTypeLavaBioSkaarjGlob' ||
		DamageType == class'DamTypeFireBrute' ||
		DamageType == class'DamTypeFireGasbag' ||
		DamageType == class'DamTypeFireGiantGasbag' ||
		DamageType == class'DamTypeFireKrall' ||
		DamageType == class'DamTypeFireLord' ||
		DamageType == class'DamTypeFireMercenary' ||
		DamageType == class'DamTypeFireQueen' ||
		DamageType == class'DamTypeFireSkaarjSuperHeat' ||
		DamageType == class'DamTypeFireSlith' ||
		DamageType == class'DamTypeFireSlug' ||
		DamageType == class'DamTypeFireTentacle' ||
		DamageType == class'DamTypeFireTitanSuperHeat' ||
	    DamageType == class'DamTypeIceKrall' ||
		DamageType == class'DamTypeArcticBioSkaarjGlob' ||
		DamageType == class'DamTypeIceBrute' ||
		DamageType == class'DamTypeIceGasbag' ||
		DamageType == class'DamTypeIceGiantGasbag' ||
		DamageType == class'DamTypeIceMercenary' ||
		DamageType == class'DamTypeIceQueen' ||
		DamageType == class'DamTypeIceSkaarjFreezing' ||
		DamageType == class'DamTypeIceSlith' ||
		DamageType == class'DamTypeIceSlug' ||
		DamageType == class'DamTypeIceTitan' ||
		DamageType == Class'DamTypeIceTentacle' ||
		DamageType == class'DamTypeIceWarlord') && Damage > 0)
	{
		Damage *= (abs(1-(AbilityLevel * default.ProtectionMultiplier)));
		if (Damage == 0)
			Damage = 1;
	}
}

defaultproperties
{
     ProtectionMultiplier=0.050000
     ExcludingAbilities(0)=Class'DEKExtras208.AbilityEarthShield'
     ExcludingAbilities(1)=Class'DEKExtras208.AbilityPlasmaShield'
     AbilityName="Twin Core Shield"
     Description="Reduces damage from all fire and ice type attacks by 5% per level (including Lava and Arctic Bio Skaarjs). Does not protect against burn or freeze effects. You can not have more than one type of elemental shield at a time.|Cost (per level): 5,10,15,20..."
     StartingCost=5
     CostAddPerLevel=5
     MaxLevel=10
}
