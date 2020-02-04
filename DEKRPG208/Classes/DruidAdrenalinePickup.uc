// DruidAdrenalinePickup
// version of AdrenalinePickup that can be picked up whilst falling

class DruidAdrenalinePickup extends AdrenalinePickup;

function InitDroppedPickupFor(Inventory Inv)
{
	SetPhysics(PHYS_Falling);
	//GotoState('FallingPickup');
	GotoState('Pickup','Begin');
	Inventory = Inv;
	bAlwaysRelevant = false;
	bOnlyReplicateHidden = false;
	bUpdateSimulatedPosition = true;
	bDropped = true;
	LifeSpan = 16;
	bIgnoreEncroachers = false; // handles case of dropping stuff on lifts etc
	NetUpdateFrequency = 8;
}

defaultproperties
{
     AdrenalineAmount=25.000000
     PickupMessage="A gift of 25 Adrenaline"
     Skins(0)=Texture'DEKRPGTexturesMaster207P.Skins.DG-PowerAdrenalineD'
     Skins(1)=TexPanner'XGameTextures.SuperPickups.AdrenalineInnerP'
}
