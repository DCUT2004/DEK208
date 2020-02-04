class CometRed extends SeekingRocketProj;

var xEmitter RealSmokeTrail;
var Effects RealCorona;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if (SmokeTrail != None)
		SmokeTrail.Destroy();
	
	if (Corona != None)
		Corona.Destroy();

	RealSmokeTrail = Spawn(class'CometRedFX',self);
	RealCorona = Spawn(class'CometRedCorona',self);
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

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if (Other == Instigator || ClassIsChildOf(Other.Class, class'CometRed'))
		return;
	Super(RocketProj).ProcessTouch(Other, HitLocation);
}

simulated function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
	local Actor Victims;
	local float damageScale, momentumScale, dist;
	local bool VictimPawn;

	if (bHurtEntry)
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors(class'Actor', Victims, 2 * DamageRadius, HitLocation)
	{
		if (Victims != self && Hurtwall != Victims && (Victims.Role == ROLE_Authority || Victims.bNetTemporary) && !Victims.IsA('FluidSurfaceInfo'))
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1, VSize(dir));
			dir = dir / dist;
			damageScale   = 1 - FClamp((dist - Victims.CollisionRadius) /      DamageRadius,  0, 1);
			momentumScale = 1 - FClamp((dist - Victims.CollisionRadius) / (2 * DamageRadius), 0, 1);

			if (Instigator == None || Instigator.Controller == None)
				Victims.SetDelayedDamageInstigatorController(InstigatorController);
			if (Victims == LastTouched)
				LastTouched = None;
				
			VictimPawn = false;
			if (Pawn(Victims) != None)
			{
				VictimPawn = true;
			}

			Victims.TakeDamage(FMax(0.001, damageScale * DamageAmount), Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir, momentumScale * Momentum * dir, DamageType);
			if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
			if (VictimPawn)
			{
				if (Victims == None || Pawn(Victims) == None || Pawn(Victims).Health <= 0 )
					class'ArtifactLightningBeam'.static.AddArtifactKill(Instigator, class'WeaponGlowStreak');	// assume killed
			}
		}
	}
	if (LastTouched != None && LastTouched != self && LastTouched.Role == ROLE_Authority && !LastTouched.IsA('FluidSurfaceInfo'))
	{
		Victims = LastTouched;
		LastTouched = None;
		dir = Victims.Location - HitLocation;
		dist = FMax(1, VSize(dir));
		dir = dir / dist;
		damageScale   = FMax(Victims.CollisionRadius / (Victims.CollisionRadius + Victims.CollisionHeight), 1 - FMax(0, (dist - Victims.CollisionRadius) /      DamageRadius ));
		momentumScale = FMax(Victims.CollisionRadius / (Victims.CollisionRadius + Victims.CollisionHeight), 1 - FMax(0, (dist - Victims.CollisionRadius) / (2 * DamageRadius)));

		if (Instigator == None || Instigator.Controller == None)
			Victims.SetDelayedDamageInstigatorController(InstigatorController);
		Victims.TakeDamage(damageScale * DamageAmount, Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir, momentumScale * Momentum * dir, DamageType);
		if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
			Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
	}

	bHurtEntry = false;
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local Actor A;

	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
    	A = Spawn(class'CometRedHitEffect',,,HitLocation + HitNormal*20,rotator(HitNormal));
		if (A != None)
			A.RemoteRole = ROLE_SimulatedProxy;
    }
	BlowUp(HitLocation);
	Destroy();
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
	 Damage=60.0000
     Speed=800.000000
     MaxSpeed=800.000000
	 Lifespan=13.0000
	 AmbientSound=Sound'ONSBPSounds.Artillery.ShellAmbient'
	 MyDamageType=Class'DEKRPG208.DamTypeGlowStreak'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.RocketProj'
	 Skins(0)=FinalBlend'D-E-K-HoloGramFX.NonWireframe.FunkyStuff_0'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     bDynamicLight=True
     LightSaturation=0
	 LightHue=0
     LightBrightness=10.000000
     DrawScale=0.010000
     CollisionRadius=5.000000
     CollisionHeight=5.000000
}
