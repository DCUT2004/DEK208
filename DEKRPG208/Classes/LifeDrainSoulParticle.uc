class LifeDrainSoulParticle extends SeekingRocketProj;

var XEmitter RealSmokeTrail;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if (SmokeTrail != None)
		SmokeTrail.Destroy();
	
	if (Corona != None)
		Corona.Destroy();

	RealSmokeTrail = Spawn(class'LifeDrainSoulParticleFX',self);
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
	local DecayHealGlow FX;

    if ( InitialDir == vect(0,0,0) )
        InitialDir = Normal(Velocity);

	Acceleration = vect(0,0,0);
	// Do normal guidance to target.
	
	if (Seeking == None)
		return;

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
		if(SeekingDistance <= 150)
		{
			FX = Seeking.Spawn(class'DecayHealGlow', Seeking, , Seeking.Location, Seeking.Rotation);
			if (FX != None)
				FX.SetBase(Seeking);
			Destroy(); // Destroy the particle if it is within range of the seeking target
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
     LightHue=0
     LightSaturation=45
     LightBrightness=127.000000
     LightRadius=2.000000
	 bDynamicLight=False
     DrawType=DT_Sprite
     Texture=Texture'XEffects.PainterDecalMark'
     DrawScale=0.080000
     SoundVolume=128
     CollisionRadius=5.000000
     CollisionHeight=5.000000
     bCollideWorld=False
}
