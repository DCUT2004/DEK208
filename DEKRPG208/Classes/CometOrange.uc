class CometOrange extends CometRed;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if (SmokeTrail != None)
		SmokeTrail.Destroy();
	
	if (Corona != None)
		Corona.Destroy();

	RealSmokeTrail = Spawn(class'CometOrangeFX',self);
	RealCorona = Spawn(class'CometOrangeCorona',self);
	if (RealCorona != None)
		RealCorona.SetBase(Self);
	Dir = vector(Rotation);
	Velocity = speed * Dir;
    SetTimer(0.1, true);
}

simulated function Timer()
{
    local vector ForceDir;
    local float VelMag;
    local float SeekingDistance;

    if ( InitialDir == vect(0,0,0) )
        InitialDir = Normal(Velocity);

	Acceleration = vect(0,0,0);
	// Do normal guidance to target.
	
	if (Seeking == None)
	{
		return;
		Destroy();
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
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local Actor A;

	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
    	A = Spawn(class'CometOrangeHitEffect',,,HitLocation + HitNormal*20,rotator(HitNormal));
		if (A != None)
			A.RemoteRole = ROLE_SimulatedProxy;
    }
	BlowUp(HitLocation);
	Destroy();
}

simulated function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
	Super.HurtRadius(DamageAmount, DamageRadius, MyDamageType, Momentum, HitLocation);
}

simulated function Destroyed()
{
	if (RealSmokeTrail != None)
	{
		RealSmokeTrail.mRegen=False;
		RealSmokeTrail.LifeSpan=0.650000; //Just in case the trail isn't destroyed
	}
	if (RealCorona != None)
		RealCorona.Destroy();
	Super.Destroyed();
}

defaultproperties
{
	 Skins(0)=FinalBlend'D-E-K-HoloGramFX.NonWireframe.FunkyStuff_3'
	 LightHue=30
}
