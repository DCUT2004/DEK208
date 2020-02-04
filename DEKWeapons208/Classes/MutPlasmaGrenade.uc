class MutPlasmaGrenade extends Mutator;

function bool CheckReplacement( Actor Other, out byte bSuperRelevant )
{
	local int i;
	local WeaponLocker L;

	bSuperRelevant = 0;
    if ( xWeaponBase(Other) != None )
    {
		if ( xWeaponBase(Other).WeaponType == class'Onslaught.ONSGrenadeLauncher' )
			xWeaponBase(Other).WeaponType = class'PlasmaGrenadeLauncher';
	}
	else if ( ONSGrenadePickup(Other) != None )
		ReplaceWith( Other, "PlasmaGrenadePickup");
	else if ( ONSGrenadeAmmoPickup(Other) != None )
		ReplaceWith( Other, "PlasmaGrenadeAmmoPickup");
	else if ( WeaponLocker(Other) != None )
	{
		L = WeaponLocker(Other);
		for (i = 0; i < L.Weapons.Length; i++)
			if (L.Weapons[i].WeaponClass == class'Onslaught.ONSGrenadeLauncher')
				L.Weapons[i].WeaponClass = class'PlasmaGrenadeLauncher';
		return true;
	}
	else
		return true;
	return false;
}

defaultproperties
{
     GroupName="UCMP AGL (ONS) - DEK"
     FriendlyName="-DEKWeapons1.1- AGGL (ONS)"
     Description="Replaces Grenade Launcher with the D-E-K Anti Gravity Grenade Launcher (Best for Onslaught)."
}
