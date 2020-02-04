class AerialTrapFire extends BioFire;

simulated function bool AllowFire()
{
	if (AerialTrap(Weapon).CurrentMines >= AerialTrap(Weapon).MaxMines)
		return false;

	return Super.AllowFire();
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local AerialTrapProjectile G;

	G = AerialTrapProjectile(Super.SpawnProjectile(Start, Dir));
	if (G != None && AerialTrap(Weapon) != None)
	{
		G.SetOwner(Weapon);
		AerialTrap(Weapon).Mines[AerialTrap(Weapon).Mines.length] = G;
		AerialTrap(Weapon).CurrentMines++;
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
     AmmoClass=Class'DEKRPG208.AerialTrapAmmo'
     AmmoPerFire=0
     ProjectileClass=Class'DEKRPG208.AerialTrapProjectile'
     FlashEmitterClass=None
}
