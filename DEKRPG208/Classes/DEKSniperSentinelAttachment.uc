class DEKSniperSentinelAttachment extends xWeaponAttachment;

var NewMinigunMFlash			MuzFlash;
var class<NewMinigunMFlash>	MuzzleFlashClass;

simulated function vector GetFireStart()
{
	local vector	X, Y, Z, VehicleProjSpawnOffset;

	if ( Instigator != None && ASVehicle(Instigator) != None )
		VehicleProjSpawnOffset = ASVehicle(Instigator).VehicleProjSpawnOffset;

	GetAxes( Instigator.Rotation, X, Y, Z );
    return Instigator.Location + X*VehicleProjSpawnOffset.X + Y*VehicleProjSpawnOffset.Y + Z*VehicleProjSpawnOffset.Z;
}

simulated function Destroyed()
{
    if ( MuzFlash != None )
        MuzFlash.Destroy();

    super.Destroyed();
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
        }

		// have pawn play firing anim
		if ( Instigator != None && FiringMode == 0 && FlashCount > 0 )
		{
			Instigator.PlayFiring(1.0, '0');
		}
    }

    super.ThirdPersonEffects();
}

simulated function Vector GetTipLocation()
{
    return Location -  vector(Rotation) * 100;
}

defaultproperties
{
     MuzzleFlashClass=Class'XEffects.NewMinigunMFlash'
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
