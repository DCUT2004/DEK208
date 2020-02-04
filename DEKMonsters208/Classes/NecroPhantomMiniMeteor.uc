class NecroPhantomMiniMeteor extends Projectile;

var config float LifeTime;
var vector initialDir;
var XEmitter RealSmokeTrail;

simulated function PostBeginPlay()
{
	local Rotator R;

    Super.PostBeginPlay();
	RealSmokeTrail = Spawn(class'NecroPhantomMiniMeteorFX',self);
	Velocity = Vector(Rotation) * Speed;  
	R = Rotation;
	R.Roll = 32768;
	SetRotation(R);
	initialDir = Velocity;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other != Instigator )
	{
		SpawnEffects(HitLocation, -1 * Normal(Velocity) );
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}

simulated function Landed( vector HitNormal )
{
	SpawnEffects( Location, HitNormal );
	Explode(Location,HitNormal);
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	Landed(HitNormal);
}


simulated function Explode(vector HitLocation, vector HitNormal)
{
	if ( Role == ROLE_Authority )
	{
		HurtRadius(damage, 500, MyDamageType, MomentumTransfer, HitLocation);	
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
		spawn(class'NecroGhostPoltergeistVanishFX',,,HitLocation + HitNormal*16 );
	}
}
simulated function Destroyed()
{
	if (RealSmokeTrail != None)
	{
		RealSmokeTrail.mRegen=False;
		RealSmokeTrail.LifeSpan=0.650000; //Just in case the trail isn't destroyed
	}

	Super.Destroyed();
}

defaultproperties
{
     Speed=600.000000
     MaxSpeed=600.000000
     TossZ=0.000000
     Damage=40.000000
     MyDamageType=Class'DEKMonsters208.DamTypePhantomProjectile'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.RocketProj'
     Physics=PHYS_Falling
     AmbientSound=Sound'GeneralAmbience.firefx11'
     LifeSpan=6.000000
     DrawScale=0.500000
}
