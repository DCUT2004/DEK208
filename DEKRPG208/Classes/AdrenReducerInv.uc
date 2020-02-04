class AdrenReducerInv extends Inventory;

var int AbilityLevel;
var float AdrenReductionPerLevel;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if(Other == None)
	{
		destroy();
		return;
	}
	if (Other != None)
	{
		Other.Controller.AdrenalineMax -= (AbilityLevel * AdrenReductionPerLevel);
	}
	Super.GiveTo(Other);
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
