//Vampiric Leech includes Vampirism and Energy. Both Vampire and Energy amount is reduced, but damage bonus is a bit higher.

class RW_VampiricLeech extends RW_EnhancedEnergy;

var config float VampireAmount;

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
   if ( ClassIsChildOf(Weapon, class'TransLauncher') )
      return false;

   return true;
}

function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	if(damage > 0)
	{
		if (Damage < (OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent))
			Damage = OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent;
	}

	Super.NewAdjustTargetDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);
}

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Actor A;
	local float AdrenalineBonus;
	local MagicShieldInv MInv;

	if (Pawn(Victim) == None)
		return;
	  
	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	Class'DruidVampire'.static.LocalHandleDamage(Damage, Pawn(Victim), Instigator, Momentum, DamageType, true, Float(Modifier) * VampireAmount);

	if (!bIdentified)
		Identify();

	if (Damage > Pawn(Victim).Health)
		AdrenalineBonus = Pawn(Victim).Health;
	else
		AdrenalineBonus = Damage;
	AdrenalineBonus *= 0.009 * Modifier;
	
	MInv = MagicShieldInv(Pawn(Victim).FindInventoryType(class'MagicShieldInv'));
	if (MInv == None)
	{
		if ( UnrealPlayer(Instigator.Controller) != None && Instigator.Controller.Adrenaline < Instigator.Controller.AdrenalineMax
			&& Instigator.Controller.Adrenaline + AdrenalineBonus >= Instigator.Controller.AdrenalineMax && !Instigator.InCurrentCombo() )
			UnrealPlayer(Instigator.Controller).ClientDelayedAnnouncementNamed('Adrenalin', 15);
		Instigator.Controller.Adrenaline = FMin(Instigator.Controller.Adrenaline + AdrenalineBonus, Instigator.Controller.AdrenalineMax);
		A = Spawn(Class'DEKEffectVampiricLeech',,,Owner.Location,rotator(Normal(HitLocation - Location)));
		if ( A != None )
		{
			A.RemoteRole = ROLE_SimulatedProxy;
			A.PlaySound(Sound'MenuSounds.MS_ListChangeUp',,1.5 * Owner.TransientSoundVolume,,Owner.TransientSoundRadius);
		}
	}
	else
		return;
}


//ModifierOverlay=FinalBlend'D-E-K-HoloGramFX.FullFB.HoloMaterial_0'

defaultproperties
{
     VampireAmount=0.250000
     DamageBonus=0.050000
     ModifierOverlay=Shader'D-E-K-HoloGramFX.Wire.wireshader_0'
     MaxModifier=5
     PostfixPos=" of Vampiric Leech"
     PrefixNeg="Sapping "
}
