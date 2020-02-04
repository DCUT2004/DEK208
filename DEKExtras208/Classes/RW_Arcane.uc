class RW_Arcane extends OneDropRPGWeapon
	HideDropDown
	CacheExempt;
	
var RPGRules RPGRules;
//var config int PoisonLifespan;
//var config int HeatLifespan;
//var config int MinimumHealth;
//var config float VampireAmount;
//var Sound KnockbackSound;
//var Sound FreezeSound;

function PostBeginPlay()
{
	Local GameRules G;
	super.PostBeginPlay();
	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			RPGRules = RPGRules(G);
			break;
		}
	}

	if(RPGRules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	local ArcaneInv Inv;
	local MagicShieldInv MInv;
	local Pawn P;
	
	P = Pawn(Victim);
	
	if (P != None && Instigator != None && Instigator.Health > 0 && Instigator.Controller != None)
	{
		MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
		if (MInv != None)
			return;
		else if (MInv == None)
		{
			Inv = ArcaneInv(Instigator.FindInventoryType(class'ArcaneInv'));
			if (Inv != None)
			{
				if(damage > 0)
				{
					if (Damage < (OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent)) 
						Damage = OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent;
					if (Inv.bKnockback)
					{
						Super(RW_Knockback).NewAdjustTargetDamage(Damage, OriginalDamage, P, HitLocation, Momentum, DamageType);
					}
					else if (Inv.bLoot)
					{
						Super(RW_Loot).NewAdjustTargetDamage(Damage, OriginalDamage, P, HitLocation, Momentum, DamageType);
					}
					else if (Inv.bNull)
					{
						Super(RW_NullEntropy).NewAdjustTargetDamage(Damage, OriginalDamage, P, HitLocation, Momentum, DamageType);
					}
					else if (Inv.bRage)
					{
						Super(RW_Rage).NewAdjustTargetDamage(Damage, OriginalDamage, P, HitLocation, Momentum, DamageType);
					}
				}
			}
		}
	}
}

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local ArcaneInv Inv;
	local Pawn P;
	local MagicShieldInv MInv;
	
	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	P = Pawn(Victim);
	
	if (P != None && Instigator != None && Instigator.Health > 0 && Instigator.Controller != None)
	{
		MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
		if (MInv != None)
			return;
		else if (MInv == None)
		{
			Inv = ArcaneInv(Instigator.FindInventoryType(class'ArcaneInv'));
			if (Inv != None)
			{
				if(damage > 0)
				{
					if (Inv.bPoison)
					{
						Super(RW_EnhancedPoison).AdjustTargetDamage(Damage, P, HitLocation, Momentum, DamageType);
					}
					else if (Inv.bVampire)
					{
						Super(RW_Vampire).AdjustTargetDamage(Damage, P, HitLocation, Momentum, DamageType);
					}
					else if (Inv.bFreeze)
					{
						Super(RW_EnhancedFreeze).AdjustTargetDamage(Damage, P, HitLocation, Momentum, DamageType);
					}
					else if (Inv.bHeat)
					{
						Super(RW_SuperHeat).AdjustTargetDamage(Damage, P, HitLocation, Momentum, DamageType);
					}
					else if (Inv.bEnergy)
					{
						Super(RW_EnhancedEnergy).AdjustTargetDamage(Damage, P, HitLocation, Momentum, DamageType);
					}
				}
			}
		}
	}
}

simulated function int MaxAmmo(int mode)
{
	if (bNoAmmoInstances && HolderStatsInv != None)
		return (ModifiedWeapon.MaxAmmo(mode) * (1.0 + 0.01 * HolderStatsInv.Data.AmmoMax));

	return ModifiedWeapon.MaxAmmo(mode);
}

simulated function WeaponTick(float dt)
{
	local ArcaneInv Inv;
	
	if (Instigator != None && Instigator.Health > 0)
	{
		Inv = ArcaneInv(Instigator.FindInventoryType(class'ArcaneInv'));
		if (Inv == None)
		{
			Inv = Instigator.Spawn(class'ArcaneInv', Instigator);
			Inv.GiveTo(Instigator);
		}
	}

	Super.WeaponTick(dt);
}

defaultproperties
{
	 ModifierOverlay=Shader'VMWeaponsTX.ManualBaseGun.manGunROTeffectSHAD'
     PrefixPos="Arcane "
     PrefixNeg="Arcane "
     MinModifier=1
     MaxModifier=10
}
