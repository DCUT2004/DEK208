class HealthReducerInv extends Inventory;

var int AbilityLevel;
var float HealthReductionPerLevel;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if(Other == None)
	{
		destroy();
		return;
	}
	if (Other != None)
	{
		Other.HealthMax -= (AbilityLevel * HealthReductionPerLevel);
	}
	Super.GiveTo(Other);
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
