class AbilityLinkUpBuilder extends EngineerAbility
	config(UT2004RPG);
	
var config float RangeMultiplier;
var config int AdditionalHealPerLevel;
var config float AdditionalLinkDamagePerLevel;
var config float VehicleDamage;

static function ModifyConstruction(Pawn Other, int AbilityLevel)
{
	local DruidLinkSentinelController DLSC;
	local DruidLinkSentinel DLS;
	
	DLS = DruidLinkSentinel(Other);
	if (DLS != None)
		DLSC = DruidLinkSentinelController(DLS.Controller);
	
	if (DLSC != None)
	{
		DLSC.LinkRadius *= (1 + (AbilityLevel * default.RangeMultiplier));
		DLSC.VehicleHealPerShot += (AbilityLevel * default.AdditionalHealPerLevel);
	}
}

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local RW_EngineerLink Link;
	local int i;
	
	Link = RW_EngineerLink(Weapon);

	if (Link != None && !Link.LinkUpBoost)
	{
		for (i = 0; i < Link.DamageBonusFromLinks.Length; i++)
		{
			Link.DamageBonusFromLinks[i] += (AbilityLevel * default.AdditionalLinkDamagePerLevel);
		}
		Link.LinkUpBoost = True;
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local Vehicle V;
	
	if(!bOwnedByInstigator)
		return;
		
	if(Damage > 0)
	{
		if (ClassIsChildOf(DamageType, class'VehicleDamageType'))
		{
			Damage *= default.VehicleDamage;
		}
		else
		{
			if (ClassIsChildOf(DamageType, class'WeaponDamageType'))
			{
				// ok, using a weapon. But are we in a turret or vehicle?
				V = Vehicle(Instigator);
				if (V != None )
				{
					Damage *= default.VehicleDamage;
				}
			}
		}
	}
}

defaultproperties
{
	 AdditionalLinkDamagePerLevel=0.02000
	 VehicleDamage=0.50000
	 RangeMultiplier=0.100
	 AdditionalHealPerLevel=2
     PlayerLevelReqd(1)=180
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityMannedBuilder'
     AbilityName="Niche: Linked"
     Description="Extends the range of your link sentinel by 10% per level as well as the amount of healing per level. Also increases turret boosting damage with the Engineer Link Gun by 2% per level. Reduces operated turret and vehicle damage.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.||Cost(per level): 50"
     StartingCost=50
     MaxLevel=5
}
