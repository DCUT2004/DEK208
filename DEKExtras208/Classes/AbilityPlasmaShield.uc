class AbilityPlasmaShield extends CostRPGAbility
	config(UT2004RPG) 
	abstract;


var config float ProtectionMultiplier;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(bOwnedByInstigator)
		return; //if the instigator is doing the damage, ignore this.
		
	if((DamageType == class'DamTypeCosmicBrute' ||
		DamageType == class'DamTypeCosmicKrall' ||
		DamageType == class'DamTypeCosmicSkaarj' ||
		DamageType == class'DamTypeCosmicWarlord' ||
		DamageType == class'DamTypeCosmicNali' ||
		DamageType == class'DamTypeCosmicTitan' ||
		DamageType == class'DamTypeONSWeb' ||
		DamageType == class'DamTypeAdrenWraithBlackHole' ||
		DamageType == class'DamTypeAdrenWraithLightning' ||
		DamageType == class'DamTypeBeamWarlord' ||
		DamageType == class'DamTypeBlastKrallPlasma' ||
		DamageType == class'DamTypeDCEliteKrallBolt' ||
		DamageType == class'DamTypeGasbag' ||
		DamageType == class'DamTypeGiantGasbag' ||
		DamageType == class'DamTypeKrall' ||
		DamageType == class'DamTypeMetalSkaarj' ||
		DamageType == class'DamTypePhantomProjectile' ||
		DamageType == class'DamTypePoisonSlug' ||
		DamageType == class'DamTypeSkaarj' ||
		DamageType == class'DamTypeSkaarjSniper' ||
		DamageType == class'DamTypeSkaarjTrooper' ||
		DamageType == class'DamTypeIceSkaarj' ||
		DamageType == class'DamTypeFireSkaarj' ||
		DamageType == class'DamTypeIonBlast' ||
		DamageType == class'DamTypeLinkPlasma' ||
		DamageType == class'DamTypeLinkShaft' ||
		DamageType == class'DamTypeShockBall' ||
		DamageType == class'DamTypeShockBeam' ||
		DamageType == class'DamTypeShockCombo' ||
		DamageType == class'DamTypeSniperShot' ||
		DamageType == class'DamTypeAttackCraftPlasma' ||
		DamageType == class'DamTypeChargingBeam' ||
		DamageType == class'DamTypeHoverBikePlasma' ||
		DamageType == class'DamTypeSkyMine' ||
		DamageType == class'DamTypeSorcererLightning' ||
		DamageType == class'DamTypeTentacle' ||
		DamageType == class'DamTypeTurretBeam') && Damage > 0)
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
     ExcludingAbilities(1)=Class'DEKExtras208.AbilityEarthShield'
     AbilityName="Plasma Shield"
     Description="Reduces damage from all plasma-based attacks including Cosmics, Skaarj, Queen, Necro, Link, Shock, Ion and Lightning. Also reduces damage from Raptor, Manta, and Scorpion plasma attacks that certain monsters use. Plasma attacks under other elements (ie Fire and Ice Krall) are not included.|You can not have more than one type of elemental shield at a time. Cost (per level): 5,10,15,20..."
     StartingCost=5
     CostAddPerLevel=5
     MaxLevel=10
}
