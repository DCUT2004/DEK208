class DroneProj extends Projectile;

var Emitter projEffect;

replication
{
	reliable if(Role==ROLE_Authority)
		projEffect;
}

simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();

	Velocity = Speed * vector(Rotation);
	Acceleration = Velocity;
	if(Level.NetMode != NM_DedicatedServer)
	{
		projEffect = Spawn(class'DroneProjEffect',self,,Location,Rotation);
		if(projEffect != None)
			projEffect.SetBase(self);
	}
	
}

simulated function Destroyed()
{
	if(projEffect != None)
		projEffect.Destroy();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if ( !Other.IsA('Projectile') || Other.bProjTarget )
	{
		if ( Role == ROLE_Authority )
		{
			Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
		}
		Explode(HitLocation, vect(0,0,1));
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    PlaySound(Sound'WeaponSounds.BioRifle.BioRifleGoo2');
	Destroy();
}

defaultproperties
{
     Speed=1800.000000
     MaxSpeed=2400.000000
     Damage=20.000000
     MomentumTransfer=1600.000000
     MyDamageType=Class'DEKRPG208.DamTypeDronePlasma'
     DrawType=DT_None
     bNetTemporary=False
     AmbientSound=Sound'WeaponSounds.LinkGun.LinkGunProjectile'
     LifeSpan=3.000000
     SoundVolume=255
     SoundRadius=50.000000
     ForceType=FT_Constant
     ForceRadius=30.000000
     ForceScale=5.000000
}
