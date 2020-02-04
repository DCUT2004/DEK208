class UpgradeShockProjFire extends ShockProjFire;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

    p = Super.SpawnProjectile(Start,Dir);
	if ( (UpgradeShockRifle(Instigator.Weapon) != None) && (p != None) )
		UpgradeShockRifle(Instigator.Weapon).SetComboTarget(UpgradeShockProjectile(P));
	return p;
}

defaultproperties
{
     ProjectileClass=Class'DEKWeapons208.UpgradeShockProjectile'
}
