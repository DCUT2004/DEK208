class NecromancerBloodWeaponAltFire extends WeaponFire;

var config int BurstDamage;

simulated function bool AllowFire()
{
	local DecayInv Inv;
	
	if (Instigator != None)
		Inv = DecayInv(Instigator.FindInventoryType(class'DecayInv'));
	if (Inv != None)
	{
		if (Inv.Chained && Inv.ChainTarget != None && Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire)
			return true;
		else
			return false;
	}
	return Super.AllowFire();
}


function DoFireEffect()
{
	local DecayInv Inv;
	
	
	if (Instigator != None)
	{
		Inv = DecayInv(Instigator.FindInventoryType(class'DecayInv'));
		if (Inv != None)
		{
			if (Inv.Chained)
			{
				if (Inv.ChainTarget != None)
				{
					Inv.ChainTarget.TakeDamage(BurstDamage, Instigator, Inv.ChainTarget.Location, vect(0,0,0), class'DamTypeBloodBurst');
					
				}
				else
					return;
			}
			else
				return;
		}
		else
			return;
	}
}

defaultproperties
{
	 BurstDamage=5000
	 bModeExclusive=False
     bSplashDamage=False
     //FireSound=Sound'PickupSounds.HealthPack'
	 FireRate=0.600000
     AmmoClass=Class'DEKRPG208.NecromancerBloodWeaponAmmo'
     AmmoPerFire=80
}
