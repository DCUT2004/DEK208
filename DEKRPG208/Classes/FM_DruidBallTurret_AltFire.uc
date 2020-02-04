class FM_DruidBallTurret_AltFire extends FM_BallTurret_Fire;

#exec  AUDIO IMPORT NAME="PlasmaTurretAltFire" FILE="C:\UT2004\Sounds\PlasmaTurretAltFire.WAV" GROUP="TurretSounds"

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

	p = Weapon.Spawn(class'PROJ_DruidBallTurretBAll', Instigator, , Start, Dir);
    if ( p == None )
        return None;
		
	Instigator.PlaySound(Sound'DEKRPG208.TurretSounds.PlasmaTurretAltFire',,150.000);

    p.Damage *= DamageAtten;
    return p;
}

defaultproperties
{
     TeamProjectileClasses(0)=Class'DEKRPG208.PROJ_DruidBallTurretBall'
     TeamProjectileClasses(1)=Class'DEKRPG208.PROJ_DruidBallTurretBall'
     FireSound=None
     FireRate=1.500000
}
