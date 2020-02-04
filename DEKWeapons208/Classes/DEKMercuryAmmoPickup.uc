//=============================================================================
// MercuryAmmoPickup
// Copyright 2003-2010 by Wormbo <wormbo@online.de>
//
// Pickup class for Mercury Missile ammo.
//=============================================================================


class DEKMercuryAmmoPickup extends UTAmmoPickup;


//=============================================================================
// Default properties
//=============================================================================

defaultproperties
{
     AmmoAmount=20
     MaxDesireability=0.300000
     InventoryType=Class'DEKWeapons208.DEKMercuryMissileAmmo'
     PickupMessage="A Mercury Missile pack. For You."
     PickupSound=Sound'PickupSounds.RocketAmmoPickup'
     PickupForce="RocketAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.RocketAmmoPickup'
     Skins(0)=Texture'MercuryMissiles2.Skins.MercuryAmmoTex'
     CollisionHeight=13.500000
}
