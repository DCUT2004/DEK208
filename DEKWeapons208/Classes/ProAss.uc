//Original version 'Pro Assaut Rifle' by ghouck at http://www.craptasticvoyage.com
//DEK version modded by Jefe
class ProAss extends AssaultRifle;

var float reloadrate;
Var Float timing;

Function tick (Float DT)
{
     Timing = Timing + DT;
     If (Timing >= reloadrate)
     {
     addammo(1,0);
     Timing = 0;
     }
}

function bool HandlePickupQuery( pickup Item )
{
	if ( Item.InventoryType == Class )
		return true;
	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

defaultproperties
{
     reloadrate=0.480000
     FireModeClass(0)=Class'DEKWeapons208.ProAssFire'
     FireModeClass(1)=Class'DEKWeapons208.ProAssGrenade'
     AIRating=0.420000
     CurrentRating=0.420000
     OldPickup="ProAssPickup"
     Description="DEKWeapons208 Version. DEK Utility Rifle: This is a small caliber submachine gun. It has a high rate of fire, and has ammo that automatically regenerates, although at a slower rate than the firing rate. Original version 'Pro Assault Rifle' from Craptastic Voyage by ghouck."
     Priority=251
     HudColor=(B=160,G=200,R=160)
     InventoryGroup=1
     PickupClass=Class'DEKWeapons208.ProAssPickup'
     ItemName="Utility Rifle"
}
