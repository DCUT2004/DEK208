class RW_Loot extends OneDropRPGWeapon
	HideDropDown
	CacheExempt
	config(UT2004RPG);

var config float DamageBonus;

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	if ( Weapon.default.FireModeClass[0] != None && Weapon.default.FireModeClass[0].default.AmmoClass != None
	          && class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[0].default.AmmoClass) )
		return false;

	return true;
}

function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	local LootInv Inv;
	
	P = Pawn(Victim);
	
	if (P != None && P.Health > 0)
		Inv = LootInv(P.FindInventoryType(class'LootInv'));
	
	if (!bIdentified)
		Identify();

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	if(damage > 0)
	{
		if (Damage < (OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent))
			Damage = OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent;

		Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
		Momentum *= 1.0 +DamageBonus * Modifier;
	}

	if (Instigator != None && Instigator.Controller != None && P != None && P.Controller != None && P.Health > 0 && P != Instigator && !P.Controller.SameTeamAs(Instigator.Controller))
	{
		if (Inv == None)
		{
			Inv = spawn(class'LootInv', P,,, rot(0,0,0));
			Inv.LetterDropChance = (Modifier*0.8);
			Inv.ArtifactDropChance = Modifier*1.3;
			Inv.GemDropChance = Modifier*1.8;
			Inv.GiveTo(P);
		}
	}
}

defaultproperties
{
     DamageBonus=0.020000
     ModifierOverlay=FinalBlend'XEffectMat.Shock.ShockCoilFB'
     MinModifier=1
     MaxModifier=4
     PostfixPos=" of Loot"
}
