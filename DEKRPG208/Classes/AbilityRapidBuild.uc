class AbilityRapidBuild extends EngineerAbility
	abstract;

var float ReduceRate;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local EngineerPointsInv EInv;

	EInv = class'AbilityLoadedEngineer'.static.GetEngInv(Other);
	if (EInv != None)
		EInv.FastBuildPercent = 1.0 - (AbilityLevel*Default.ReduceRate);

}

defaultproperties
{
     ReduceRate=0.050000
     AbilityName="Rapid Build"
     Description="Reduces the delay before you can build a new engineer construction. Each level takes 5% off your recovery time. |Cost (per level): 1,3,5,7,9,11,13,15..."
     StartingCost=1
     CostAddPerLevel=2
     MaxLevel=20
}
