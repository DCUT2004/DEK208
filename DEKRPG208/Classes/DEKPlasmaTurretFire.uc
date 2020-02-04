class DEKPlasmaTurretFire extends FM_BallTurret_Fire;

#exec  AUDIO IMPORT NAME="PlasmaTurretFire" FILE="C:\UT2004\Sounds\PlasmaTurretFire.WAV" GROUP="TurretSounds"

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

	p = Weapon.Spawn(class'DEKPlasmaTurretProj', Instigator, , Start, Dir);
    if ( p == None )
        return None;

    p.Damage *= DamageAtten;
    return p;
}

defaultproperties
{
     TeamProjectileClasses(0)=Class'DEKRPG208.DEKPlasmaTurretProj'
     TeamProjectileClasses(1)=Class'DEKRPG208.DEKPlasmaTurretProj'
     FireSound=Sound'DEKRPG208.TurretSounds.PlasmaTurretFire'
     FireRate=0.300000
}
