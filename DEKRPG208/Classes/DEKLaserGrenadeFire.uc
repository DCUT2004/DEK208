class DEKLaserGrenadeFire extends BioFire;

simulated function bool AllowFire()
{
	if (DEKLaserGrenadeLauncher(Weapon).CurrentMines >= DEKLaserGrenadeLauncher(Weapon).MaxMines)
		return false;

	return Super.AllowFire();
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local DEKLaserGrenadeProjectile G;

	G = DEKLaserGrenadeProjectile(Super(BioFire).SpawnProjectile(Start, Dir));
	if (G != None && DEKLaserGrenadeLauncher(Weapon) != None)
	{
		G.SetOwner(Weapon);
		DEKLaserGrenadeLauncher(Weapon).Mines[DEKLaserGrenadeLauncher(Weapon).Mines.length] = G;
		DEKLaserGrenadeLauncher(Weapon).CurrentMines++;
	}

	return G;
}

defaultproperties
{
     bSplashDamage=False
     bRecommendSplashDamage=False
     FireRate=0.650000
     AmmoClass=Class'DEKRPG208.DEKLaserGrenadeAmmo'
     ProjectileClass=Class'DEKRPG208.DEKLaserGrenadeProjectile'
}
