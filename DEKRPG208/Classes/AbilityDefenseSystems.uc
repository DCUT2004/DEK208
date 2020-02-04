class AbilityDefenseSystems extends EngineerAbility
	config(UT2004RPG)
	abstract;
	
var config float RangeMultiplier;
var config float XPMultiplier;

static simulated function ModifyConstruction(Pawn Other, int AbilityLevel)
{
	local DruidDefenseSentinelController DDSC;
	local DruidDefenseSentinelControllerCrimbo DDSCC;
	
	DDSC = DruidDefenseSentinelController(Other.Controller);
	DDSCC = DruidDefenseSentinelControllerCrimbo(Other.Controller);
	
	if (DruidDefenseSentinel(Other) != None || DruidCeilingDefenseSentinel(Other) != None)
	{
		if (DDSC != None)
			DDSC.TargetRadius *= (1 + (AbilityLevel * default.RangeMultiplier));
	}
	if (DruidDefenseSentinelCrimbo(Other) != None || DruidCeilingDefenseSentinelCrimbo(Other) != None)
	{
		if (DDSCC != None)
			DDSCC.TargetRadius *= (1 + (AbilityLevel * default.RangeMultiplier));
	}
}

defaultproperties
{
     RangeMultiplier=0.020000
     XPMultiplier=0.030000
     AbilityName="Defense Systems"
     Description="Increases the range of your defense sentinels by 2% per level.|Cost (per level): 5,10,15,20,25,30,35,40,45,50"
     StartingCost=5
     CostAddPerLevel=5
     MaxLevel=20
}
