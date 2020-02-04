class DruidArtifactMakeMagicWeaponPickup extends RPGArtifactPickup;

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
     InventoryType=Class'DEKRPG208.DruidArtifactMakeMagicWeapon'
     PickupMessage="You got the artifact to make magic weapons!"
     PickupSound=Sound'PickupSounds.ShieldPack'
     PickupForce="ShieldPack"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XPickups_rc.UDamagePack'
     bAcceptsProjectors=False
     DrawScale=0.075000
     Skins(0)=FinalBlend'D-E-K-HoloGramFX.FullFB.HoloMaterial_1'
     AmbientGlow=255
}
