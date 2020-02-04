class UpgradeAssaultGrenade extends AssaultGrenade;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Grenade g;
    local vector X, Y, Z;
    local float pawnSpeed;

    g = Weapon.Spawn(class'UpgradeGrenade', instigator,, Start, Dir);
    if (g != None)
    {
        Weapon.GetViewAxes(X,Y,Z);
        pawnSpeed = X dot Instigator.Velocity;

		if ( Bot(Instigator.Controller) != None )
			g.Speed = mHoldSpeedMax;
		else
			g.Speed = mHoldSpeedMin + HoldTime*mHoldSpeedGainPerSec;
		g.Speed = FClamp(g.Speed, mHoldSpeedMin, mHoldSpeedMax);
        g.Speed = pawnSpeed + g.Speed;
        g.Velocity = g.Speed * Vector(Dir);

        g.Damage *= DamageAtten;
    }
    return g;
}

defaultproperties
{
     ProjectileClass=Class'DEKWeapons208.UpgradeGrenade'
}
