class MutProAssArena extends Mutator;

function bool CheckReplacement( Actor Other, out byte bSuperRelevant )
{
	local WeaponLocker L;

	bSuperRelevant = 0;
    if ( xWeaponBase(Other) != None )
    {
		if ( xWeaponBase(Other).WeaponType != None )
			xWeaponBase(Other).WeaponType = class'UTClassic.ClassicSniperRifle';
	}
	else if ( WeaponPickup(Other) != None && ProAssPickup(Other) == None )
		{
                return false;
                }
	else if ( Ammo(Other) != None &&  ProAssAmmoPickup(Other) == None)
		{
                return false;
                }
	else if ( WeaponLocker(Other) != None )
	{
		L = WeaponLocker(Other);
		L.gotostate('disabled');

	}
	else if (Other.IsA('assaultrifle'))
        {
                return false;
        }

        else if (Other.IsA('Shieldgun'))
        {
                return false;
        }

        Else
	return true;

	return false;
}

defaultproperties
{
     DefaultWeapon=Class'DEKWeapons208.ProAss'
     GroupName="Arena"
     FriendlyName="-DEKWeapons1.1- ProAssault Arena"
     Description="DEK Pro Assault Weapon Arena: Eliminates all weapons and ammo and gives each player the DEK Pro Assault Rifle"
     bNetTemporary=True
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
