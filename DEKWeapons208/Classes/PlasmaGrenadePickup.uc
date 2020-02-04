//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PlasmaGrenadePickup extends UTWeaponPickup;

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheMaterial(Texture'EpicParticles.Flares.SoftFlare');
	L.AddPrecacheMaterial(Texture'AW-2004Particles.Energy.EclipseCircle');
      L.AddPrecacheMaterial(Texture'AW-2004Particles.Energy.ElecPanelsP');
	L.AddPrecacheStaticMesh(StaticMesh'AW-2004Particles.Weapons.PlasmaSphere');
	L.AddPrecacheStaticMesh(default.StaticMesh);
}

simulated function UpdatePrecacheMaterials()
{
      Level.AddPrecacheMaterial(Texture'EpicParticles.Flares.SoftFlare');
	Level.AddPrecacheMaterial(Texture'AW-2004Particles.Energy.EclipseCircle');
      Level.AddPrecacheMaterial(Texture'AW-2004Particles.Energy.ElecPanelsP');

	super.UpdatePrecacheMaterials();
}

defaultproperties
{
     MaxDesireability=0.750000
     InventoryType=Class'DEKWeapons208.PlasmaGrenadeLauncher'
     PickupMessage="You got an Anti-Gravity Grenade Launcher."
     PickupSound=Sound'PickupSounds.FlakCannonPickup'
     PickupForce="ONSGrenadePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UCMP-PCRGun.Weapon.PCR-low'
     DrawScale=0.600000
     PrePivot=(Z=6.500000)
     CollisionHeight=8.000000
}
