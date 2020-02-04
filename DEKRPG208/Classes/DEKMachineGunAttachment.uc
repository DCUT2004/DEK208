class DEKMachineGunAttachment extends xWeaponAttachment;

var NewMinigunMFlash			MuzFlash;
var	float								MuzzleScale;
var class<NewMinigunMFlash>	MuzzleFlashClass;
var class<Emitter>      mTracerClass;
var() editinline Emitter mTracer;
var() float				mTracerInterval;
var() float				mTracerPullback;
var() float				mTracerMinDistance;
var() float				mTracerSpeed;
var float               mLastTracerTime;

var vector	mOldHitLocation;

simulated function Destroyed()
{
    if ( MuzFlash != None )
        MuzFlash.Destroy();

    super.Destroyed();
}

simulated function vector GetFireStart()
{
	local vector	X, Y, Z, VehicleProjSpawnOffset;

	if ( Instigator != None && ASVehicle(Instigator) != None )
		VehicleProjSpawnOffset = ASVehicle(Instigator).VehicleProjSpawnOffset;

	GetAxes( Instigator.Rotation, X, Y, Z );
    return Instigator.Location + X*VehicleProjSpawnOffset.X + Y*VehicleProjSpawnOffset.Y + Z*VehicleProjSpawnOffset.Z;
}

simulated function UpdateTracer()
{
    local vector SpawnLoc, SpawnDir, SpawnVel;
	local float hitDist;

    if (Level.NetMode == NM_DedicatedServer)
        return;

    if (mTracer == None)
    {
        mTracer = Spawn(mTracerClass);
        //AttachToBone(mTracer, 'tip');
    }

    if (mTracer != None && Level.TimeSeconds > mLastTracerTime + mTracerInterval)
    {
		SpawnLoc = GetTracerStart();
		mTracer.SetLocation(SpawnLoc);

		hitDist = VSize(mHitLocation - SpawnLoc) - mTracerPullback;

		// If we have a hit but the hit location has not changed
		if(mHitLocation == mOldHitLocation)
			SpawnDir = vector( Instigator.GetViewRotation() );
		else
			SpawnDir = Normal(mHitLocation - SpawnLoc);

		if(hitDist > mTracerMinDistance)
		{
			SpawnVel = SpawnDir * mTracerSpeed;
			
			mTracer.Emitters[0].StartVelocityRange.X.Min = SpawnVel.X;
			mTracer.Emitters[0].StartVelocityRange.X.Max = SpawnVel.X;
			mTracer.Emitters[0].StartVelocityRange.Y.Min = SpawnVel.Y;
			mTracer.Emitters[0].StartVelocityRange.Y.Max = SpawnVel.Y;
			mTracer.Emitters[0].StartVelocityRange.Z.Min = SpawnVel.Z;
			mTracer.Emitters[0].StartVelocityRange.Z.Max = SpawnVel.Z;

			mTracer.Emitters[0].LifetimeRange.Min = hitDist / mTracerSpeed;
			mTracer.Emitters[0].LifetimeRange.Max = mTracer.Emitters[0].LifetimeRange.Min;

			mTracer.SpawnParticle(1);
		}

		mLastTracerTime = Level.TimeSeconds;
    }

	mOldHitLocation = mHitLocation;
}

simulated function vector GetTracerStart()
{
	return GetFireStart();
}

/* UpdateHit
- used to update properties so hit effect can be spawn client side
*/
function UpdateHit(Actor HitActor, vector HitLocation, vector HitNormal)
{
    NetUpdateTime = Level.TimeSeconds - 1;
	SpawnHitCount++;
	mHitLocation = HitLocation;
	mHitActor = HitActor;
	mHitNormal = HitNormal;
}

simulated event ThirdPersonEffects()
{
	local vector	Start;

    if ( Level.NetMode != NM_DedicatedServer && Instigator != None && FlashCount > 0 )
	{
        if ( FiringMode == 0 )
        {
			// Muzzle Flash
			Start = GetFireStart();

			if ( MuzFlash == None )
			{
				// Spawn Team colored Muzzle Flash effect
				MuzFlash = Spawn(MuzzleFlashClass,,, Start, Instigator.Rotation);

				if ( MuzFlash != None )
				{
					MuzFlash.SetBase( Instigator );
				}
			}
			else
			{
				// Revive dead particles...
				MuzFlash.Emitters[0].SpawnParticle( 3 );
			}
			UpdateTracer();
        }

		// have pawn play firing anim
		if ( Instigator != None && FiringMode == 0 && FlashCount > 0 )
		{
			Instigator.PlayFiring(1.0, '0');
		}
    }

    super.ThirdPersonEffects();
}

defaultproperties
{
     MuzzleFlashClass=Class'XEffects.NewMinigunMFlash'
     mTracerClass=Class'XEffects.NewTracer'
     mTracerInterval=0.060000
     mTracerPullback=150.000000
     mTracerSpeed=15000.000000
     bHeavy=True
     bRapidFire=True
     bAltRapidFire=True
     SplashEffect=Class'XGame.BulletSplash'
     LightType=LT_Pulse
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=150
     LightBrightness=255.000000
     LightRadius=5.000000
     LightPeriod=3
     CullDistance=5000.000000
     Mesh=SkeletalMesh'ONSWeapons-A.TankMachineGun'
     DrawScale=0.650000
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
