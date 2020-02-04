//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PlasmaGrenadeAmmoPickup extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=20
     InventoryType=Class'DEKWeapons208.PlasmaGrenadeAmmo'
     PickupMessage="Hey! Plasma Grenades!"
     PickupSound=Sound'PickupSounds.LinkAmmoPickup'
     PickupForce="LinkAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UCMP-PCRGun.Weapon.DLgun-AmmoPickup-final'
     DrawScale=1.500000
}
