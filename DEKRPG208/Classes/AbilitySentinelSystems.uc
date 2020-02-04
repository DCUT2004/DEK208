class AbilitySentinelSystems extends EngineerAbility
	config(UT2004RPG)
	abstract;
	
var config float RangeMultiplier;

static simulated function ModifyConstruction(Pawn Other, int AbilityLevel)
{
	local DruidSentinelController DSC;
	local DEKRocketSentinelController DRSC;
	local DEKMercuryController DMC;
	local DEKMachineGunSentinelController DMGSC;
	local DEKHellfireSentinelController DHSC;
	local DEKSniperSentinelController DSSC;
	
	DSC = DruidSentinelController(Other.Controller);
	DRSC = DEKRocketSentinelController(Other.Controller);
	DMC = DEKMercuryController(Other.Controller);
	DMGSC = DEKMachineGunSentinelController(Other.Controller);
	DHSC = DEKHellfireSentinelController(Other.Controller);
	DSSC = DEKSniperSentinelController(Other.Controller);
	
	if (DruidSentinel(Other) != None || DruidCeilingSentinel(Other) != None)
	{
		if (DSC != None)
			DSC.TargetRange *= (1 + (AbilityLevel * default.RangeMultiplier));
	}
	if (DEKRocketSentinel(Other) != None || DEKCeilingRocketSentinel(Other) != None)
	{
		if (DRSC != None)
			DRSC.TargetRange *= (1 + (AbilityLevel * default.RangeMultiplier));
	}
	if (DEKMercurySentinel(Other) != None || DEKCeilingMercurySentinel(Other) != None)
	{
		if (DMC != None)
			DMC.TargetRange *= (1 + (AbilityLevel * default.RangeMultiplier));
	}
	if (DEKMachineGunSentinel(Other) != None || DEKCeilingMachineGunSentinel(Other) != None)
	{
		if (DMGSC != None)
			DMGSC.TargetRange *= (1 + (AbilityLevel * default.RangeMultiplier));
	}
	if (DEKHellfireSentinel(Other) != None || DEKHellfireSentinel(Other) != None)
	{
		if (DHSC != None)
			DHSC.TargetRange *= (1 + (AbilityLevel * default.RangeMultiplier));
	}
	if (DEKSniperSentinel(Other) != None || DEKCeilingSniperSentinel(Other) != None)
	{
		if (DSSC != None)
			DSSC.TargetRange *= (1 + (AbilityLevel * default.RangeMultiplier));
	}
}

defaultproperties
{
     RangeMultiplier=0.030000
     AbilityName="Sentinel Systems"
     Description="Increases the range of most offensive sentinels by 3% per level.|Cost (per level): 5,10,15,20,25,30,35,40,45,50"
     StartingCost=5
     CostAddPerLevel=5
     MaxLevel=20
}
