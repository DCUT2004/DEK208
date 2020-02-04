class ShroudInv extends Inventory;

var int NumPlayers;

replication
{
	reliable if (Role == ROLE_Authority)
		NumPlayers;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	NumPlayers = 0;
	SetTimer(5.0, True);
	Super.GiveTo(Other);
}

function Timer()
{
	local Controller C;
	local int Counter;
	local NecroInv NInv;
	local PhantomDeathGhostInv PInv;
	
	for ( C = Level.ControllerList; C != None; C = C.NextController )
	{
		if (C != None && C.Pawn != None && C.SameTeamAs(Instigator.Controller))
		{
			NInv = NecroInv(C.Pawn.FindInventoryType(class'NecroInv'));
			PInv = PhantomDeathGhostInv(C.Pawn.FindInventoryType(class'PhantomDeathGhostInv'));
		}
		if (C != None && C.PlayerReplicationInfo != None && C.SameTeamAs(Instigator.Controller) && C != Instigator && !C.PlayerReplicationInfo.bOnlySpectator &&
			(C.PlayerReplicationInfo.bOutOfLives ||	//dead
			(!C.PlayerReplicationInfo.bOutOfLives && NInv != None) ||	//or currently resurrected
			(!C.PlayerReplicationInfo.bOutOfLives && PInv != None)))	//or currently a  phantom
				Counter++;
	}
	NumPlayers = Counter;
	Counter = 0;	//reset
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
