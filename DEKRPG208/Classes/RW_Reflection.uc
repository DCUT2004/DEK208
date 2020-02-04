class RW_Reflection extends OneDropRPGWeapon
	HideDropDown
	CacheExempt
	config(UT2004RPG);

var config float DamageBonus;
var config float BaseChance;
var config float Growth;

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
	if (!bIdentified)
		Identify();

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	if(damage > 0)
	{
		Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
		Momentum *= 1.0 +DamageBonus * Modifier;
	}
}

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int Damage )
{	
	//make the call first in case the weapon actually does the reflect on it's own.
	if(super.CheckReflect(HitLocation, RefNormal, Damage))
		return true;

	if(Damage > 0)
	{
		RefNormal=normal(HitLocation-Location);
		if(rand(99) < int((Growth**float(Modifier))*BaseChance))
		{
			Instigator.SetOverlayMaterial(ModifierOverlay, 1.0, false);
			return true;
		}
	}
	if (True)
		CheckDeflectMission();
	return false;
}

simulated function CheckDeflectMission()
{
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	
	MiInv = MissionInv(Instigator.FindInventoryType(class'MissionInv'));
	M1Inv = Mission1Inv(Instigator.FindInventoryType(class'Mission1Inv'));
	M2Inv = Mission2Inv(Instigator.FindInventoryType(class'Mission2Inv'));
	M3Inv = Mission3Inv(Instigator.FindInventoryType(class'Mission3Inv'));
	
	if (Instigator != None && MiInv != None && !MiInv.DeflectorComplete)
	{
		if (M1Inv != None && !M1Inv.Stopped && M1Inv.DeflectorActive)
		{
			M1Inv.MissionCount++;
		}
		if (M2Inv != None && !M2Inv.Stopped && M2Inv.DeflectorActive)
		{
			M2Inv.MissionCount++;
		}
		if (M3Inv != None && !M3Inv.Stopped && M3Inv.DeflectorActive)
		{
			M3Inv.MissionCount++;
		}
	}
}

defaultproperties
{
     DamageBonus=0.035000
     BaseChance=30.000000
     Growth=1.210000
     ModifierOverlay=TexEnvMap'VMVehicles-TX.Environments.ReflectionEnv'
     MinModifier=1
     MaxModifier=7
     AIRatingBonus=0.060000
     PrefixPos="Reflecting "
     bCanHaveZeroModifier=True
}
