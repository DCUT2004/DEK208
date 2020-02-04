class TechTitanProjectile extends TechSkaarjProjectile;

#exec obj load file=GeneralAmbience.uax

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
    local rotator Dir;
    local int i;
    local TechTitanMine p;

      	start = Location + 10 * HitNormal;
	if ( Role == ROLE_Authority )
	{

		HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);	
		for (i=0; i<3; i++)
		{
			Dir = Rotation;
			Dir.yaw += FRand()*32000-16000;
			Dir.pitch += FRand()*32000-16000;
			Dir.roll += FRand()*32000-16000;
			p = Spawn( class 'TechTitanMine',, '', Start, Dir);
		}
        }
    Destroy();
}

defaultproperties
{
     MiniboltInterval=2.000000
     MiniboltDamage=75
     MiniboltRadius=2500.000000
     Speed=900.000000
     MaxSpeed=900.000000
     Damage=150.000000
     MyDamageType=Class'DEKMonsters208.DamTypeTechTitanRock'
     DrawScale=16.000000
}
