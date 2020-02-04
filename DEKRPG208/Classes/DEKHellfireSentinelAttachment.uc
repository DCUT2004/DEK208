class DEKHellfireSentinelAttachment extends xWeaponAttachment;

var class<Emitter>      mMuzFlashClass;
var Emitter             mMuzFlash3rd;

var byte				OldSpawnHitCount;

var vector	mOldHitLocation;

simulated function vector GetFireStart()
{
	local vector	X, Y, Z, VehicleProjSpawnOffset;

	if ( Instigator != None && ASVehicle(Instigator) != None )
		VehicleProjSpawnOffset = ASVehicle(Instigator).VehicleProjSpawnOffset;

	GetAxes( Instigator.Rotation, X, Y, Z );
    return Instigator.Location + X*VehicleProjSpawnOffset.X + Y*VehicleProjSpawnOffset.Y + Z*VehicleProjSpawnOffset.Z;
}

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

			if ( mMuzFlash3rd == None )
			{
				// Spawn Team colored Muzzle Flash effect
				mMuzFlash3rd = Spawn(mMuzFlashClass,,, Start, Instigator.Rotation);

				if ( mMuzFlash3rd != None )
				{
					mMuzFlash3rd.SetBase( Instigator );
				}
			}
			else
			{
				// Revive dead particles...
				mMuzFlash3rd.Emitters[0].SpawnParticle( 3 );
			}
        }

		// have pawn play firing anim
		if ( Instigator != None && FiringMode == 0 && FlashCount > 0 )
		{
			Instigator.PlayFiring(1.0, '0');
		}
    }
    super.ThirdPersonEffects();
}

function Destroyed()
{
    if (mMuzFlash3rd != None)
        mMuzFlash3rd.Destroy();

	Super.Destroyed();
}

defaultproperties
{
     mMuzFlashClass=Class'Onslaught.ONSTankFireEffect'
     bHeavy=True
     LightType=LT_Pulse
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=150
     LightBrightness=255.000000
     LightRadius=5.000000
     LightPeriod=3
     CullDistance=5000.000000
     bHidden=True
     Mesh=SkeletalMesh'Weapons.Minigun_3rd'
}
