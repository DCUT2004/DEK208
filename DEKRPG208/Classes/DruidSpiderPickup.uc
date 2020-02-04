class DruidSpiderPickup extends RPGArtifactPickup;

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
     MaxDesireability=0.000000
     InventoryType=Class'DEKRPG208.DruidArtifactSpider'
     PickupMessage="You got the Electro-Magnet!"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XGame_rc.BallMesh'
     DrawScale=1.500000
     AmbientGlow=128
}
