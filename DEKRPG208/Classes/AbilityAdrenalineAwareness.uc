class AbilityAdrenalineAwareness extends CostRPGAbility
	abstract;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local AdrenalineAwarenessInv Inv;

	if (Other.Role != ROLE_Authority)
		return;

	Inv = AdrenalineAwarenessInv(Other.FindInventoryType(class'AdrenalineAwarenessInv'));
	if (Inv == None)
	{
		Inv = Other.spawn(class'AdrenalineAwarenessInv', Other,,,rot(0,0,0));
		Inv.GiveTo(Other);
		Inv.SetTimer(1, True);
	}
}

defaultproperties
{
     AbilityName="Adrenaline Awareness"
     Description="Notifies you of your adrenaline in the upper left corner of your screen.||This ability will only apply to Assault or Monster Assault.||Cost: 1"
     StartingCost=1
     MaxLevel=1
}
