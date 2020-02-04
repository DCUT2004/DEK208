class RW_Rage extends OneDropRPGWeapon
	HideDropDown
	CacheExempt
	config(UT2004RPG);

var config float DamageBonus;
var config float DamageReturn;
var config int MinimumHealth;

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	if ( Weapon.default.FireModeClass[0] != None && Weapon.default.FireModeClass[0].default.AmmoClass != None
	          && class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[0].default.AmmoClass) )
		return false;

	if (ClassIsChildOf(Weapon, class'LinkGun') || ClassIsChildOf(Weapon, class'Minigun'))
		return false;

	return true;
}

function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	local int localDamage;
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	local Pawn P;
	
	P = Pawn(Victim);
	
	if (Instigator != None)
	{
		MiInv = MissionInv(Instigator.FindInventoryType(class'MissionInv'));
		M1Inv = Mission1Inv(Instigator.FindInventoryType(class'Mission1Inv'));
		M2Inv = Mission2Inv(Instigator.FindInventoryType(class'Mission2Inv'));
		M3Inv = Mission3Inv(Instigator.FindInventoryType(class'Mission3Inv'));
	}
	
	if (!bIdentified)
		Identify();

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	if(Instigator != None && damage > 0)
	{
		if (Damage < (OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent))
			Damage = OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent;

		Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
		Momentum *= 1.0 +DamageBonus * Modifier;

		localDamage = Max(1, DamageReturn * Damage);
		if(localDamage >= Instigator.Health - MinimumHealth)
			localDamage = Instigator.Health - MinimumHealth;
		if(localDamage > 0)
			if(Instigator.Controller == None || Instigator.Controller.bGodMode == False)
				Instigator.Health -= localDamage; //ouch. Done this way to prevent damage reduction. It's dirty, but it works
	}

	if (Instigator != None && P != None && P != Instigator && MiInv != None && !MiInv.AngerManagementComplete)
	{
		if (M1Inv != None && !M1Inv.Stopped && M1Inv.AngerManagementActive)
		{
			M1Inv.MissionCount += localDamage;
		}
		if (M2Inv != None && !M2Inv.Stopped && M2Inv.AngerManagementActive)
		{
			M2Inv.MissionCount += localDamage;
		}
		if (M3Inv != None && !M3Inv.Stopped && M3Inv.AngerManagementActive)
		{
			M3Inv.MissionCount += localDamage;
		}
	}
}
//ModifierOverlay=Combiner'EpicParticles.Shaders.Combiner3'

defaultproperties
{
     DamageBonus=0.100000
     DamageReturn=0.100000
     MinimumHealth=70
     ModifierOverlay=FinalBlend'XEffectMat.Combos.RedBoltFB'
     MinModifier=6
     MaxModifier=10
     PostfixPos=" of Rage"
}
