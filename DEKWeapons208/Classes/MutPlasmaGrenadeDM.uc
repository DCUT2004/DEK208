class MutPlasmaGrenadeDM extends Mutator;

function bool CheckReplacement( Actor Other, out byte bSuperRelevant )
{
	local int i;
	local WeaponLocker L;

	bSuperRelevant = 0;
    if ( xWeaponBase(Other) != None )
    {
		if ( xWeaponBase(Other).WeaponType == class'XWeapons.BioRifle' )
			xWeaponBase(Other).WeaponType = class'PlasmaGrenadeLauncher';
	}
	else if ( BioRiflePickup(Other) != None )
		ReplaceWith( Other, "PlasmaGrenadePickup");
	else if ( BioAmmoPickup(Other) != None )
		ReplaceWith( Other, "PlasmaGrenadeAmmoPickup");
	else if ( WeaponLocker(Other) != None )
	{
		L = WeaponLocker(Other);
		for (i = 0; i < L.Weapons.Length; i++)
			if (L.Weapons[i].WeaponClass == class'XWeapons.BioRifle')
				L.Weapons[i].WeaponClass = class'PlasmaGrenadeLauncher';
		return true;
	}
	else
		return true;
	return false;
}

defaultproperties
{
     GroupName="DEK UCMP AGGL (DM CTF)"
     FriendlyName="-DEKWeapons1.1- AGGL (DM and CTF)"
     Description="Replaces Bio Rifle with the D-E-K Anti Gravity Grenade Launcher(Best for Deathmatch, CTF, Bombing Run, ext)."
}
