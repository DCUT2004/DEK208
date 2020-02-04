class ArtifactSummonSkeletonPickup extends ArtifactMonsterSummonPickup;

function float BotDesireability(Pawn Bot)
{
		return 0;
}

auto state Pickup
{
	function bool ValidTouch(Actor Other)
	{
		local Pawn P;
		
		P = Pawn(Other);
		if (P != None && P.PlayerReplicationInfo != None && P.PlayerReplicationInfo.bBot)
			return false;
		if (!Super.ValidTouch(Other))
			return false;

		return CanPickupArtifact(Pawn(Other));
	}
}

defaultproperties
{
     PickupMessage="You got a Skeleton Summoning Charm"
     MaxDesireability=0.000000
     InventoryType=Class'DEKRPG208.ArtifactSummonSkeleton'
     AmbientGlow=255
}
