//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PlasmaGrenadeFire extends BioFire;

simulated function bool AllowFire()
{
	if (PlasmaGrenadeLauncher(Weapon).CurrentGrenades >= PlasmaGrenadeLauncher(Weapon).MaxGrenades)
		return false;

	return Super.AllowFire();
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local PlasmaGrenadeProjectile G;

	G = PlasmaGrenadeProjectile(Super.SpawnProjectile(Start, Dir));
	if (G != None && PlasmaGrenadeLauncher(Weapon) != None)
	{
		G.SetOwner(Weapon);
		PlasmaGrenadeLauncher(Weapon).Grenades[PlasmaGrenadeLauncher(Weapon).Grenades.length] = G;
		PlasmaGrenadeLauncher(Weapon).CurrentGrenades++;
	}

	return G;
}

defaultproperties
{
     bSplashDamage=False
     bRecommendSplashDamage=False
     bTossed=False
     FireSound=Sound'WeaponSounds.BaseFiringSounds.BPulseRifleAltFire'
     FireRate=0.500000
     AmmoClass=Class'DEKWeapons208.PlasmaGrenadeAmmo'
     ProjectileClass=Class'DEKWeapons208.PlasmaGrenadeProjectile'
     FlashEmitterClass=None
}
