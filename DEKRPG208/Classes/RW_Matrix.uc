// A port of Titan RPG's matrix weapon

class RW_Matrix extends OneDropRPGWeapon
	CacheExempt
	config(UT2004RPG);

var config float DamageBonus;	
var config float MatrixRadius;
var config float Multiplier;

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	local int x;
	local RPGStatsInv StatsInv;

	if ( Weapon.default.FireModeClass[0] != None && Weapon.default.FireModeClass[0].default.AmmoClass != None
	          && class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[0].default.AmmoClass) )
		return false;

	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		if (StatsInv.Data.Abilities[x] == class'AbilityMagicVault' && StatsInv.Data.AbilityLevels[x] >= 1)
		return true;

	return false;

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
	if (!bIdentified)
		Identify();

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	if(damage > 0)
	{
		Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
		Momentum *= 1.0 + DamageBonus * Modifier;
	}
	super.AdjustTargetDamage(Damage, Victim, HitLocation, Momentum, DamageType);
}

simulated function int MaxAmmo(int mode)
{
	if (bNoAmmoInstances && HolderStatsInv != None)
		return (ModifiedWeapon.MaxAmmo(mode) * (1.0 + 0.01 * HolderStatsInv.Data.AmmoMax));

	return ModifiedWeapon.MaxAmmo(mode);
}

simulated event WeaponTick(float dt)
{
	local Projectile P;
	local SyncMatrix Sync;
	local float SpeedToMultiply;

	Super.WeaponTick(dt);
	
	SpeedToMultiply = (1 - (Modifier * default.Multiplier));
	if (SpeedToMultiply < 0.1)
		SpeedToMultiply = 0.1;	//don't allow full stop, can cause some problems (AVRiL).
	
	if(Role == ROLE_Authority && Instigator.Controller != None)
	{
		foreach Instigator.VisibleCollidingActors(class'Projectile', P, MatrixRadius)
		{
			if(P.Tag != 'Matrix' && P.InstigatorController != None && P.InstigatorController != Instigator.Controller && TranslocatorBeacon(P) == None && BombTrapProjectile(P) == None && AerialTrapProjectile(P) == None && ShockTrapProjectile(P) == None && FrostTrapProjectile(P) == None && WildfireTrapProjectile(P) == None && (P.Instigator == None || P.Instigator.Controller == None || !P.InstigatorController.SameTeamAs(Instigator.Controller)))
			{
 				Identify();
 				
  				P.Tag = 'Matrix';
 				P.Speed *= 0;
 				P.MaxSpeed *= 0;
 				P.Velocity *= 0;
				
				//Tell clients
				if(Level.NetMode == NM_DedicatedServer)
				{
					Sync = P.Instigator.Spawn(class'SyncMatrix');
					Sync.Proj = P;
					Sync.ProjClass = P.class;
 					Sync.ProcessedTag = 'Matrix';
					Sync.SpeedMultiplier = 0;
					Sync.ProjVelocity *= 0;
					Sync.ProjLocation = P.Location;
				}
			}
		}
	}
}

//ModifierOverlay=Shader'D-E-K-HoloGramFX.PlayerPictureEffect.Pic_2'
//ModifierOverlay=Shader'D-E-K-HoloGramFX.Wire.wireshader_2' -Green VampLeech

defaultproperties
{
     DamageBonus=0.050000
     MatrixRadius=80.000000
     Multiplier=0.100000
     ModifierOverlay=FinalBlend'DEKWeaponsMaster206.fX.Matrix'
     MinModifier=1
     MaxModifier=5
     AIRatingBonus=0.025000
     PrefixPos="Bullet Time "
}
