class WildfireTrapFire extends BioFire;

simulated function bool AllowFire()
{
	if (WildfireTrap(Weapon).CurrentMines >= WildfireTrap(Weapon).MaxMines)
		return false;

	return Super.AllowFire();
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local WildfireTrapProjectile G;

	G = WildfireTrapProjectile(Super.SpawnProjectile(Start, Dir));
	if (G != None && WildfireTrap(Weapon) != None)
	{
		G.SetOwner(Weapon);
		WildfireTrap(Weapon).Mines[WildfireTrap(Weapon).Mines.length] = G;
		WildfireTrap(Weapon).CurrentMines++;
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
     AmmoClass=Class'DEKRPG208.WildfireTrapAmmo'
     AmmoPerFire=0
     ProjectileClass=Class'DEKRPG208.WildfireTrapProjectile'
     FlashEmitterClass=None
}
