class AbilityTrapDamage extends CostRPGAbility
	config(UT2004RPG) 
	abstract;
	
var config float LevMultiplier;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local Inventory OInv;
	local RW_EngineerLink EGun;

	EGun = None;
	// Now let's see if they have an EngineerLinkGun
	for (OInv=Other.Inventory; OInv != None; OInv = OInv.Inventory)
	{
		if(ClassIsChildOf(OInv.Class,class'RW_EngineerLink'))
		{
			EGun = RW_EngineerLink(OInv);
			break;
		}
	}
	if (EGun != None)
	{	// ok, they already have the EngineerLink. Let's set their SpiderBoost level. If not, it will be set when they add the link
		// code duplicated in AbilityLoadedEngineer.SetSpiderBoostLevel
		EGun.SpiderBoost = AbilityLevel * default.LevMultiplier;
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0)
	{
		if (DamageType == class'DamTypeAerialTrap' || DamageType == class'DamTypeBombTrap' || DamageType == class'DamTypeFrostTrap' || DamageType == class'DamTypeShockTrap' || DamageType == class'DamTypeWildfireTrap' || DamageType == class'DamTypeAerialTrapBolt' || DamageType == class'DamTypeShockTrapShock' || DamageType == class'DamTypeLaserGrenadeLaser')
			Damage *= (1 + (AbilityLevel * default.LevMultiplier));
	}
}

defaultproperties
{
     LevMultiplier=0.050000
     AbilityName="Trap Damage"
     Description="Increases your cumulative damage bonus with the Trap and Laser Mine Deployer weapons by 5% per level.||Cost(per level): 5,10,15,20,25,30..."
     StartingCost=5
     CostAddPerLevel=5
     MaxLevel=20
}
