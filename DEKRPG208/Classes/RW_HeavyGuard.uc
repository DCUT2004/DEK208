//Heavy Guard combines protection, sturdy, and reflection. Reflection chance reduced by a pinch.

class RW_HeavyGuard extends RW_Reflection;

var Pawn PawnOwner;
var config int HealthCap;
var config float ProtectionRepeatLifespan;

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	local int x;
	local RPGStatsInv StatsInv;

	if ( Weapon.default.FireModeClass[0] != None && Weapon.default.FireModeClass[0].default.AmmoClass != None
	          && class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[0].default.AmmoClass) )
		return false;
	
	if ( ClassIsChildOf(Weapon, class'TransLauncher') )
        return false;
	
	if ( ClassIsChildOf(Weapon, class'ShieldGun') )
        return false;

	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		if (StatsInv.Data.Abilities[x] == class'AbilityMagicVault' && StatsInv.Data.AbilityLevels[x] >= 2)
		return true;

	return false;


}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	PawnOwner = Other;
	enable('tick');
	super.GiveTo(Other, Pickup);
}


simulated function Tick(Float deltaTime)
{
	if(PawnOwner != None)
	{
		if(PawnOwner.Weapon != None && PawnOwner.Weapon == self)
		{
			PawnOwner.Mass=20000.000000;
		}
		else
		{
			if(PawnOwner != None)
				PawnOwner.Mass=PawnOwner.default.Mass;
		}
	}
	super.Tick(deltaTime);
}

function AdjustPlayerDamage(out int Damage, Pawn InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	Local ProtectionInv inv;
	local Actor A;
	
	if (!bIdentified)
		Identify();

	Damage -= Damage * (0.1 * Modifier);

	Super.AdjustPlayerDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);

	if(Modifier > 0 && Damage >= Instigator.Health && Instigator.Health > HealthCap)
	{
		inv = ProtectionInv(Instigator.FindInventoryType(class'ProtectionInv'));
		if(Inv == None)
		{
			Damage = Instigator.Health - 1; //help protect them for the first shot Damage reduction still applies though.
			inv = spawn(class'ProtectionInv', Instigator,,, rot(0,0,0));
			inv.Lifespan = (ProtectionRepeatLifespan / float(Modifier));
			if(inv != None)
				inv.giveTo(Instigator);
		}
	}
	
	if (InstigatedBy != None && Instigator != None && Damage > 0 && Modifier > 0 && !InstigatedBy.Controller.SameTeamAs(Instigator.Controller) && InstigatedBy != Instigator )
	{
		A = Spawn(Class'DEKEffectHeavyGuard',,,Owner.Location,rotator(Normal(HitLocation - Location)));
			if ( A != None )
			{
				A.RemoteRole = ROLE_SimulatedProxy;
				A.PlaySound(Sound'BShieldReflection',,1.0 * instigatedBy.TransientSoundVolume,,instigatedBy.TransientSoundRadius);
			}
		PlaySound(Sound'BShieldReflection',,1.0 * instigatedBy.TransientSoundVolume,,instigatedBy.TransientSoundRadius);
	}
	if (!bIdentified)
		Identify();
	Momentum = vect(0,0,0);
	Super.AdjustPlayerDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
}

defaultproperties
{
     HealthCap=20
     ProtectionRepeatLifespan=3.000000
     DamageBonus=0.050000
     BaseChance=25.000000
     ModifierOverlay=TexEnvMap'PickupSkins.Shaders.TexEnvMap2'
     MaxModifier=4
     AIRatingBonus=0.100000
     PrefixPos=" "
     PostfixPos=" of Heavy Guard"
}
