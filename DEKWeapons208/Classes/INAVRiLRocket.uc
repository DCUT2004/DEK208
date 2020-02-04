// from the original class

class INAVRiLRocket extends Projectile;

#exec OBJ LOAD File=XGameShadersB.utx

var	Emitter SmokeTrail;
var Effects Corona;
var float AccelerationAddPerSec;
var bool bLockedOn;
var float LeadTargetDelay; //don't lead target until missle has been flying for this many seconds
var float LeadTargetStartTime;
var pawn HomingTarget;

replication
{
	reliable if (bNetDirty && Role == ROLE_Authority)
		HomingTarget, bLockedOn;
}

simulated function Destroyed()
{
	// Turn of smoke emitters. Emitter should then destroy itself when all particles fade out.
	if ( SmokeTrail != None )  
		SmokeTrail.Kill();

	if ( Corona != None )
		Corona.Destroy();

	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
	if (!bNoFX && EffectIsRelevant(Location, false))
		spawn(class'ONSAVRiLRocketExplosion',,, Location, rotator(vect(0,0,1)));
	if (Instigator != None && Instigator.IsLocallyControlled() && Instigator.Weapon != None && !Instigator.Weapon.HasAmmo())
		Instigator.Weapon.DoAutoSwitch();
	//hack for crappy weapon firing sound
	if (INAVRiL(Owner) != None)
		INAVRiL(Owner).PlaySound(sound'WeaponSounds.BExplosion3', SLOT_Interact, 0.01,, TransientSoundRadius);

	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	local vector Dir;

	Dir = vector(Rotation);
	
	if ( Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrail = Spawn(class'INAvrilSmokeTrail',,,Location - 3 * Dir);
		SmokeTrail.Setbase(self);

		Corona = Spawn(class'RocketCorona',self);
	}

	Velocity = speed * Dir;
	Acceleration = Dir;	//really small accel just to give it a direction for use later
	if (PhysicsVolume.bWaterVolume)
		Velocity=0.6*Velocity;
	if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}

	SetTimer(0.1, true);
	LeadTargetStartTime = Level.TimeSeconds + LeadTargetDelay;

	Super.PostBeginPlay();
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	BlowUp(HitLocation);
	Destroy();
}

simulated function Timer()
{
    local vector Dir, ForceDir;
    local float VelMag, LowestDesiredZ;
    local bool bLastLockedOn;
    local AIController C;

    if (Role == ROLE_Authority)
    {
	if (Instigator != None && Instigator.Controller != None && INAVRiL(Owner) != None)
	{
		bLastLockedOn = bLockedOn;
		bLockedOn = INAVRiL(Owner).bLockedOn;
		HomingTarget = INAVRiL(Owner).HomingTarget;
		if (!bLastLockedOn && bLockedOn)
		{
			if (HomingTarget != None && HomingTarget.Controller != None)
				HomingTarget.Controller.ReceiveProjectileWarning(self);
		}
	}
	else
		bLockedOn = false;

	if (HomingTarget != None)
    	{
    		//Monsters with nothing else to shoot at may attempt to shoot down incoming missles
    		C = AIController(HomingTarget.Controller);
    		if (C != None && C.Skill >= 3.0 && (C.Enemy == None || !C.LineOfSightTo(C.Enemy)))
    		{
    				C.Focus = self;
    				C.FireWeaponAt(self);
    		}
    	}
    }

    if (bLockedOn && HomingTarget != None)
    {
    	// Do normal guidance to target.
    	Dir = HomingTarget.Location - Location;
    	VelMag = VSize(Velocity);

	if (Level.TimeSeconds >= LeadTargetStartTime)
	{
	    	ForceDir = Dir + HomingTarget.Velocity * VSize(Dir) / (VelMag * 2);
	    	if (Instigator != None)
			LowestDesiredZ = FMin(Instigator.Location.Z, HomingTarget.Location.Z); //missle should avoid going any lower than this
		else
			LowestDesiredZ = HomingTarget.Location.Z;
	    	if (ForceDir.Z + Location.Z < LowestDesiredZ)
	    		ForceDir.Z += LowestDesiredZ - (ForceDir.Z + Location.Z);
	    	ForceDir = Normal(ForceDir);
	}
	else
		ForceDir = Dir;

    	ForceDir = Normal(ForceDir * 0.8 * VelMag + Velocity);
    	Velocity =  VelMag * ForceDir;
    	Acceleration += 5 * ForceDir;

    	// Update rocket so it faces in the direction its going.
    	SetRotation(rotator(Velocity));
    }
}

simulated function Tick(float deltaTime)
{
	if (VSize(Velocity) >= MaxSpeed)
	{
		Acceleration = vect(0,0,0);
		disable('Tick');
	}
	else
		Acceleration += Normal(Velocity) * (AccelerationAddPerSec * deltaTime);
}

function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	if ( Damage > 0 && !InstigatedBy.Controller.SameTeamAs(Instigator.Controller) )
		BlowUp(Location);
}

defaultproperties
{
     AccelerationAddPerSec=1500.000000
     LeadTargetDelay=0.850000
     Speed=550.000000
     MaxSpeed=8000.000000
     Damage=125.000000
     DamageRadius=150.000000
     MomentumTransfer=50000.000000
     MyDamageType=Class'DEKWeapons208.DamTypeDEKAVRiLRocket'
     ExplosionDecal=Class'Onslaught.ONSRocketScorch'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'VMWeaponsSM.AVRiLGroup.AVRiLprojectileSM'
     bNetTemporary=False
     bUpdateSimulatedPosition=True
     bIgnoreVehicles=True
     LifeSpan=7.000000
     DrawScale=0.200000
     AmbientGlow=96
     bProjTarget=True
     bUseCylinderCollision=False
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}
