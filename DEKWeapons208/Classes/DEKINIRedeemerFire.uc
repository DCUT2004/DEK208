class DEKINIRedeemerFire extends RedeemerFire;

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

    p = Super.SpawnProjectile(Start,Dir);
    if ( p == None )
        p = Super.SpawnProjectile(Instigator.Location,Dir);
    if ( p == None )
    {
	 	Weapon.Spawn(class'SmallRedeemerExplosion');
		Weapon.HurtRadius(500, 400, class'DEKDamTypeINIRedeemer', 100000, Instigator.Location);
	}
    return p;
}

defaultproperties
{
     ProjectileClass=Class'DEKWeapons208.DEKINIRedeemerProj'
}
