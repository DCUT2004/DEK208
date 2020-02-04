class BombTrapFire extends BioFire;

simulated function bool AllowFire()
{
	if (BombTrap(Weapon).CurrentMines >= BombTrap(Weapon).MaxMines)
		return false;

	return Super.AllowFire();
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local BombTrapProjectile G;

	G = BombTrapProjectile(Super.SpawnProjectile(Start, Dir));
	if (G != None && BombTrap(Weapon) != None)
	{
		G.SetOwner(Weapon);
		BombTrap(Weapon).Mines[BombTrap(Weapon).Mines.length] = G;
		BombTrap(Weapon).CurrentMines++;
	}

	return G;
}

function DrawMuzzleFlash(Canvas Canvas)
{
	return;
}

defaultproperties
{
     bSplashDamage=False
     bRecommendSplashDamage=False
     FireRate=0.650000
     AmmoClass=Class'DEKRPG208.BombTrapAmmo'
     AmmoPerFire=0
     ProjectileClass=Class'DEKRPG208.BombTrapProjectile'
     FlashEmitterClass=None
}
