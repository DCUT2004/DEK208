class DEKLightningTurretProjFire extends FM_BallTurret_Fire;

#exec  AUDIO IMPORT NAME="LightningTurretFire" FILE="C:\UT2004\Sounds\LightningTurretFire.WAV" GROUP="TurretSounds"

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

	p = Weapon.Spawn(class'DEKLightningTurretProj', Instigator, , Start, Dir);
    if ( p == None )
		return None;
	
	p.Damage *= DamageAtten;
	return p;
}

defaultproperties
{
     TeamProjectileClasses(0)=Class'DEKRPG208.DEKLightningTurretProj'
     TeamProjectileClasses(1)=Class'DEKRPG208.DEKLightningTurretProj'
     FireAnimRate=6.000000
     FireSound=Sound'DEKRPG208.TurretSounds.LightningTurretFire'
     FireRate=0.500000
     ProjectileClass=Class'DEKRPG208.DEKLightningTurretProj'
}
