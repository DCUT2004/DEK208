class NecroPhantomPetProjectile extends Projectile;

var config float LifeTime;
var vector initialDir;

simulated function PostBeginPlay()
{
	local Rotator R;

    Super.PostBeginPlay();
	Velocity = Vector(Rotation) * Speed;  
	R = Rotation;
	R.Roll = 32768;
	SetRotation(R);
	initialDir = Velocity;
	SetTimer(LifeTime, true);
}

simulated function PostNetBeginPlay() 
  {
  	SetTimer(LifeTime, true);
  	Super.PostNetBeginPlay();
}

simulated function Timer() 
{
	local Vector HitNormal;
	
	Poof(Location, HitNormal);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
 //do nothing. This projectile is spawned at the player; let's give them time to move away from it before the projectile explodes.
}

simulated function Poof(vector HitLocation, vector HitNormal)
{
	if ( Role == ROLE_Authority )
	{
		HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);	
	}
	SpawnEffects( Location, HitNormal );
    Destroy();
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	PlaySound (Sound'ONSVehicleSounds-S.Explosions.VehicleExplosion02',,3*TransientSoundVolume);
	spawn(class'ShockComboWiggles',,,HitLocation + HitNormal*16 );
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	Destroy();
}

simulated function Destroyed()
{
	Super.Destroyed();
}

defaultproperties
{
     Lifetime=0.100000
     MaxSpeed=0.000000
     TossZ=0.000000
     Damage=60.000000
     MyDamageType=Class'DEKMonsters208.DamTypePhantomProjectile'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'AW-2004Particles.Weapons.PlasmaSphere'
     Physics=PHYS_Flying
     AmbientSound=Sound'GeneralAmbience.firefx11'
}
