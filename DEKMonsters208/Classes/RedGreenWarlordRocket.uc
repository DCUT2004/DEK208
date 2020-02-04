class RedGreenWarlordRocket extends DCWarlordRocket;

var	xEmitter HolidayTrail;

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		HolidayTrail = Spawn(class'RedGreenHolidayTrailSmoke',self);
		//Corona = Spawn(class'RocketCorona',self);
	}
	if ( SmokeTrail != None )
		SmokeTrail.mRegen = False;

	Dir = vector(Rotation);
	Velocity = speed * Dir;
	if (PhysicsVolume.bWaterVolume)
	{
		bHitWater = True;
		Velocity=0.6*Velocity;
	}
	Super.PostBeginPlay();
}

simulated function Destroyed()
{
	if ( HolidayTrail != None )
		HolidayTrail.mRegen = False;
	if ( SmokeTrail != None )
		SmokeTrail.mRegen = False;
	if ( Corona != None )
		Corona.Destroy();
	Super.Destroyed();
}

defaultproperties
{
}
