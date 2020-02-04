class SpecialistInv extends Inventory;

var Pawn PawnOwner;
var Weapon SelectedWeapon;

var transient DruidsRPGKeysInteraction InteractionOwner;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		SelectedWeapon;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if(Other == None)
	{
		destroy();
		return;
	}
	if (Other != None)
		PawnOwner = Other;
	Super.GiveTo(Other);
}

simulated function destroyed()
{
 	if( InteractionOwner != None )
 	{
 		InteractionOwner.SpInv = None;
 		InteractionOwner = None;
 	}
	super.destroyed();
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
