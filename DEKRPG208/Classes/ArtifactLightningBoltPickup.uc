class ArtifactLightningBoltPickup extends RPGArtifactPickup;

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
     InventoryType=Class'DEKRPG208.ArtifactLightningBolt'
     PickupMessage="You got the Lightning Bolt!"
     PickupSound=Sound'PickupSounds.SniperRiflePickup'
     PickupForce="SniperRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DEKStaticsMaster207P.Artifacts.LightningBolt'
     DrawScale=0.250000
     Skins(0)=Shader'DEKRPGTexturesMaster207P.Artifacts.LBolt'
     AmbientGlow=128
}
