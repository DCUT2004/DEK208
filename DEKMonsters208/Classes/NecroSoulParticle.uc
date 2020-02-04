class NecroSoulParticle extends UntargetedSeekerProjectile;

var XEmitter RealSmokeTrail;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if (SmokeTrail != None)
		SmokeTrail.Destroy();
	
	if (Corona != None)
		Corona.Destroy();

	RealSmokeTrail = Spawn(class'NecroSoulParticleFX',self);
	Dir = vector(Rotation);
	Velocity = speed * Dir;
	SetCollision(False,False,False);
    SetTimer(0.1, true);
}

simulated function Timer()
{
    local vector ForceDir;
    local float VelMag;
    local float SeekingDistance;
	//local NecroSoulChargeEmitter Charge;

    if ( InitialDir == vect(0,0,0) )
        InitialDir = Normal(Velocity);

	Acceleration = vect(0,0,0);
	// Do normal guidance to target.
	
	if (Seeking == None)
	{
		return;
		Destroy();
		if (RealSmokeTrail != None)
		{
			RealSmokeTrail.mRegen = false;
			RealSmokeTrail.Destroy();
		}
	}
	ForceDir = Normal(Seeking.Location - Location);
	
	VelMag = VSize(Velocity);

	ForceDir = Normal(ForceDir * 0.5 * VelMag + Velocity);
	Velocity =  VelMag * ForceDir;
	Acceleration += 5 * ForceDir;

	// Update rocket so it faces in the direction its going.
	SetRotation(rotator(Velocity));

	if (Seeking != None)
	{
		SeekingDistance = VSize(Seeking.Location - Location);
		if(SeekingDistance < 50)
		{
			Destroy(); // Destroy the particle if it is within range of the seeking target
			//Charge = Spawn(class'NecroSoulChargeEmitter',,,Seeking.Location);
			//Charge.SetBase(Seeking);
		}
	}
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if (Other == Instigator)
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	else
		return;
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	Destroy();
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

event Touch (Actor Other)
{
	if(Other == Instigator)
		Destroy();
}

defaultproperties
{
     Speed=800.000000
     MaxSpeed=800.000000
     LightSaturation=255
     LightBrightness=10.000000
     DrawType=DT_Sprite
     Texture=Texture'XEffectMat.Shock.shock_core'
     DrawScale=0.080000
     CollisionRadius=5.000000
     CollisionHeight=5.000000
     bCollideWorld=False
}
