class ShockTrapProjectileNuclear extends ShockTrapProjectile
	config(DEKWeapons);
	
simulated function Explode(vector HitLocation, vector HitNormal)
{
	if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, 50000, Location);
		Spawn(class'ShockTrapShockProjNuclear',self,,Location);
		BoomSound();
	}
}

defaultproperties
{
     DetonationInterval=21.000000
}
