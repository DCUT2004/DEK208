class ShockTrapFire extends BioFire;

simulated function bool AllowFire()
{
	if (ShockTrap(Weapon).CurrentMines >= ShockTrap(Weapon).MaxMines)
		return false;

	return Super.AllowFire();
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local ShockTrapProjectile G;

	G = ShockTrapProjectile(Super.SpawnProjectile(Start, Dir));
	if (G != None && ShockTrap(Weapon) != None)
	{
		G.SetOwner(Weapon);
		ShockTrap(Weapon).Mines[ShockTrap(Weapon).Mines.length] = G;
		ShockTrap(Weapon).CurrentMines++;
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
     AmmoClass=Class'DEKRPG208.ShockTrapAmmo'
     AmmoPerFire=0
     ProjectileClass=Class'DEKRPG208.ShockTrapProjectile'
     FlashEmitterClass=None
}
