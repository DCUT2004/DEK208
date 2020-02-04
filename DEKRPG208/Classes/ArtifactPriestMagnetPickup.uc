class ArtifactPriestMagnetPickup extends RPGArtifactPickup;

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
     InventoryType=Class'DEKRPG208.ArtifactPriestMagnet'
     RespawnTime=30.000000
     PickupMessage="You got a Magnet artifact"
     PickupSound=Sound'PickupSounds.LinkAmmoPickup'
     PickupForce="AdrenelinPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'E_Pickups.BombBall.FullBomb'
     Physics=PHYS_Rotating
     DrawScale=0.750000
     Skins(0)=Texture'EpicParticles.Fire.IonBurn2'
     Skins(1)=Texture'EpicParticles.Fire.IonBurn'
     Skins(2)=FinalBlend'EpicParticles.Shaders.IonTrueFinal'
     AmbientGlow=255
     UV2Mode=UVM_Skin
     ScaleGlow=0.600000
     Style=STY_AlphaZ
     CollisionRadius=16.000000
     CollisionHeight=11.500000
     Mass=10.000000
     RotationRate=(Yaw=24000)
}
