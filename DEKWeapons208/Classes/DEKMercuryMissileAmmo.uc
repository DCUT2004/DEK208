//=============================================================================
// MercuryMissileAmmo
// Copyright 2003-2010 by Wormbo <wormbo@online.de>
//
// Ammo for Mercury Missile Launcher.
//=============================================================================


class DEKMercuryMissileAmmo extends Ammunition;


//=============================================================================
// Default properties
//=============================================================================

defaultproperties
{
     MaxAmmo=50
     InitialAmount=20
     bTryHeadShot=True
     ProjectileClass=Class'DEKWeapons208.DEKMercuryMissile'
     IconFlashMaterial=FinalBlend'MercuryMissiles2.HUD.MercuryAmmoIconFlash'
     PickupClass=Class'DEKWeapons208.DEKMercuryAmmoPickup'
     IconMaterial=Texture'MercuryMissiles2.HUD.MercuryAmmoIcon'
     IconCoords=(X2=100,Y2=74)
     ItemName="Mercury Missiles"
}
