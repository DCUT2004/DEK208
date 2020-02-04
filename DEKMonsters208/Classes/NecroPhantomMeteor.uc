class NecroPhantomMeteor extends Projectile;

var config float LifeTime;
var vector initialDir;
#exec obj load file=GeneralAmbience.uax

simulated function PostBeginPlay()
{
	local Rotator R;

    Super.PostBeginPlay();
	Velocity = Vector(Rotation) * Speed;  
	R = Rotation;
	R.Roll = 32768;
	SetRotation(R);
	Velocity.z += TossZ; 
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
	local vector start;
    local rotator rot;
    local int i;
    local NecroPhantomMiniMeteor NewChunk;
	
	start = Location + 10 * HitNormal;	
	if ( Role == ROLE_Authority )
	{
		HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);
		for (i=0; i<6; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			NewChunk = Spawn( class 'NecroPhantomMiniMeteor',, '', Start, rot);
		}
	}
	SpawnEffects( Location, HitNormal );
    Destroy();
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	local PlayerController PC;

	PlaySound (Sound'ONSVehicleSounds-S.Explosions.VehicleExplosion02',,3*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
		PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 3000 )
		spawn(class'FlashExplosion',,,HitLocation + HitNormal*16 );
	}
}

simulated function Destroyed()
{
	Super.Destroyed();
}

defaultproperties
{
     Lifetime=2.000000
     Speed=200.000000
     MaxSpeed=200.000000
     TossZ=225.000000
     Damage=90.000000
     MyDamageType=Class'DEKMonsters208.DamTypePhantomProjectile'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'AW-2004Particles.Weapons.PlasmaSphere'
     Physics=PHYS_Flying
     AmbientSound=Sound'GeneralAmbience.texture20'
     DrawScale=0.750000
}
