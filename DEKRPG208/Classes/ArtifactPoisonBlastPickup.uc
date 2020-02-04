class ArtifactPoisonBlastPickup extends RPGArtifactPickup;

defaultproperties
{
     InventoryType=Class'DEKRPG208.ArtifactPoisonBlast'
     PickupMessage="You got the PoisonBlast!"
     PickupSound=Sound'PickupSounds.SniperRiflePickup'
     PickupForce="SniperRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'AW-2004Particles.Weapons.AcidSphere'
     Physics=PHYS_Rotating
     DrawScale=0.180000
     AmbientGlow=255
     RotationRate=(Yaw=24000)
}
