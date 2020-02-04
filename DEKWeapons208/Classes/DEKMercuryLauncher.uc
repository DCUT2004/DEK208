//=============================================================================
// MercuryLauncher
// Copyright 2003-2010 by Wormbo <wormbo@online.de>
//
// Modified rocket launcher.
//=============================================================================

class DEKMercuryLauncher extends MercuryLauncher
	config(User);

defaultproperties
{
     bInstantZoom=False
     bAutoZoomLevel=False
     MaxScanRange=15000.000000
     DesiredZoomField=1000.000000
     FireModeClass(0)=Class'DEKWeapons208.DEKMercuryFire'
     AIRating=0.630000
     CurrentRating=0.630000
     Description="DEKWeapons1.1 Version. The Mercury Missile Launcher is a modification to the Trident rocket launcher. It is capable of firing high-speed rockets and has a zoom function."
     Priority=190
     HudColor=(B=36,G=200)
     InventoryGroup=9
     PickupClass=Class'DEKWeapons208.DEKMercuryLauncherPickup'
     ItemName="Mercury Missile Launcher"
}
