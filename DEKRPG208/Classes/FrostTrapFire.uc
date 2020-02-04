class FrostTrapFire extends BioFire;

simulated function bool AllowFire()
{
	if (FrostTrap(Weapon).CurrentMines >= FrostTrap(Weapon).MaxMines)
		return false;

	return Super.AllowFire();
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local FrostTrapProjectile G;

	G = FrostTrapProjectile(Super.SpawnProjectile(Start, Dir));
	if (G != None && FrostTrap(Weapon) != None)
	{
		G.SetOwner(Weapon);
		FrostTrap(Weapon).Mines[FrostTrap(Weapon).Mines.length] = G;
		FrostTrap(Weapon).CurrentMines++;
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
     AmmoClass=Class'DEKRPG208.FrostTrapAmmo'
     AmmoPerFire=0
     ProjectileClass=Class'DEKRPG208.FrostTrapProjectile'
     FlashEmitterClass=None
}
