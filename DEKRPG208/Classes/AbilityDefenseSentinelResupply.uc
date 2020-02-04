class AbilityDefenseSentinelResupply extends EngineerAbility
	config(UT2004RPG)
	abstract;

static simulated function ModifyConstruction(Pawn Other, int AbilityLevel)
{
	if (DruidDefenseSentinel(Other) != None)
	    DruidDefenseSentinel(Other).ResupplyLevel = AbilityLevel;
	if (DruidDefenseSentinelCrimbo(Other) != None)
	    DruidDefenseSentinelCrimbo(Other).ResupplyLevel = AbilityLevel;
	if (DEKDamageSentinel(Other) != None)
	    DEKDamageSentinel(Other).ResupplyLevel = AbilityLevel;
	if (DEKExplosivesSentinel(Other) != None)
	    DEKExplosivesSentinel(Other).ResupplyLevel = AbilityLevel;
}

defaultproperties
{
     AbilityName="DefSent Resupply"
     Description="Allows defense sentinels to grant ammo resupply when they are not busy. Also allows damage sentinels to buff team projectiles. Each level adds 1 to each healing shot, or 5% extra damage to team projectiles.|Cost (per level): 10,10,10,10,10,..."
     StartingCost=10
     MaxLevel=10
}
