class UpgradeBioChargedFire extends BioChargedFire;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local UpgradeBioGlob Glob;

    GotoState('');

    if (GoopLoad == 0) return None;

    Glob = Weapon.Spawn(class'UpgradeBioGlob',,, Start, Dir);
    if ( Glob != None )
    {
		Glob.Damage *= DamageAtten;
		Glob.SetGoopLevel(GoopLoad);
		Glob.AdjustSpeed();
    }
    GoopLoad = 0;
    if ( Weapon.AmmoAmount(ThisModeNum) <= 0 )
        Weapon.OutOfAmmo();
    return Glob;
}

defaultproperties
{
     MaxGoopLoad=15
     ProjectileClass=Class'DEKWeapons208.UpgradeBioGlob'
}
