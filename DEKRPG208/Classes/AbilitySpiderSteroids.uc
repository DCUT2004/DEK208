class AbilitySpiderSteroids extends EngineerAbility
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

static simulated function ModifyConstruction(Pawn Other, int AbilityLevel)
{
	if (DEKExplosivesSentinel(Other) != None)
	    DEKExplosivesSentinel(Other).SpiderBoostLevel = AbilityLevel * default.LevMultiplier;
}

defaultproperties
{
     LevMultiplier=0.100000
     AbilityName="Explosives Boost"
     Description="Allows the Explosives Sentinel to boost non-plasma, explosives-based projectiles including rockets, flak shells, mines, grenades, traps, and even redeemer warheads. Also allows the Engineer Link Gun to boost spider mines and bomb traps. Each level of this ability increases the maximum boost by 10%.||Cost(per level): 10,20,30,40,50..."
     StartingCost=10
     CostAddPerLevel=10
     MaxLevel=20
}
