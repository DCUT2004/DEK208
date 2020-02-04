class AbilityMeleeBerserker extends CostRPGAbility
	config(UT2004RPG) 
	abstract;
	
var config float DamageMultiplier;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{		
	if (bOwnedByInstigator) //If damage done by me..
	{
		if(DamageType == class'DamTypeShieldImpact') //And it's a shield gun..
		{
			Damage *= (1 + (AbilityLevel * default.DamageMultiplier)); //Do extra damage..
		}
		else //If not a shield gun..
			Damage *= abs((AbilityLevel * default.DamageMultiplier)-1); //Reduce damage..
	}
	else //Otherwise, if damage is done to me..
	if (!bOwnedByInstigator && DamageType != class'DamTypeShieldImpact') //cuts out most things so players can still self-boost themselves.
		Momentum = vect(0,0,0); //No knockback.
}

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local WeaponFire FireMode[2];
	
	if (Weapon == None || Weapon.Owner == None || Pawn(Weapon.Owner) == None || Pawn(Weapon.Owner).PlayerReplicationInfo == None || PlayerController(Pawn(Weapon.Owner).Controller) == None)
		return;
	if (Weapon.Role != ROLE_Authority)
		return;
		
	FireMode[0] = Weapon.GetFireMode(0);
		
	if (ShieldFire(FireMode[0]) != None)
	{
		ShieldFire(FireMode[0]).SelfDamageScale=0.00;
		ShieldFire(FireMode[0]).SelfForceScale=3.000000;
		ShieldFire(FireMode[0]).MaxDamage=250.000000;
	}
}

//static function bool OverridePickupQuery(Pawn Other, Pickup item, out byte bAllowPickup, int AbilityLevel)
//{
//	local class<Weapon> NewWeaponClass;
//	
//	if (UTAmmoPickup(item) != None)
//	{
//		bAllowPickup = 0;	// not allowed
//		return true;
//	}
//	
//	if (WeaponPickup(item) != None && WeaponPickup(item).InventoryType != None)
//	{
//		NewWeaponClass = class<Weapon>(WeaponPickup(item).InventoryType);
//		if (NewWeaponClass != None && NewWeaponClass != class'ShieldGun')
//		{
//			bAllowPickup = 0;	// not allowed
//			return true;
//		}
//	}
//	else if (WeaponLocker(item) != None && WeaponLocker(item).InventoryType != None)
//	{
//		NewWeaponClass = class<Weapon>(WeaponLocker(item).InventoryType);
//		if (NewWeaponClass != None && NewWeaponClass != class'ShieldGun')
//		{
//			bAllowPickup = 0;	// not allowed
//			return true;
//		}
//	}
//	return false;			// don't know, so let someone else decide
//}

defaultproperties
{
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityNimbleBerserker'
     RequiredAbilities(0)=Class'DEKRPG208.DEKLoadedClassicShield'
     DamageMultiplier=0.050000
     AbilityName="Niche: Melee"
     Description="Increases the Shield Gun's damage by 5% per level, but reduces all other weapon damage by 5% per level. Also reduces self damage with the Shield Gun, and increases Shield Gun jump boosting.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
