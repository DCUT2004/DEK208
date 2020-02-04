class GenomeVialCosmic extends Inventory;

var MissionMultiplayerInv MMPI;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if(Other == None)
	{
		destroy();
		return;
	}
	SetTimer(1, True);

	Super.GiveTo(Other);
}

simulated function Timer()
{
	local Translauncher Trans;
	
	Trans = Translauncher(Instigator.Weapon);
	
	MMPI = MissionMultiplayerInv(Instigator.FindInventoryType(class'MissionMultiplayerInv'));
	Instigator.ReceiveLocalizedMessage(class'MissionGenomeProjectReturnMessage', 0);
	if (MMPI != None && (MMPI.Stopped || !MMPI.GenomeProjectActive))
		Destroy();
	if (Trans != None)
		Dropped();
}

simulated function Dropped()
{
	Instigator.ReceiveLocalizedMessage(class'MissionGenomeProjectDroppedMessage', 0);
	Destroy();
}

defaultproperties
{
	 PickupClass=Class'DEKRPG208.GenomeVialCosmicPickup'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
