//From the original ONSAVRILRocket CODE with modification

class INAttackCraftMissleA extends Projectile;

var Emitter		TrailEmitter;
var class<Emitter>	TrailClass;

var float AccelRate;
var bool bLockedOn;
var pawn HomingTarget;
var float LeadTargetDelay; //don't lead target until missle has been flying for this many seconds
var float LeadTargetStartTime;
var vector InitialDir;

replication
{
	reliable if (bNetInitial && Role==ROLE_Authority)
		HomingTarget,bLockedOn;
}

simulated function Destroyed()
{
	if ( TrailEmitter != None )
		TrailEmitter.Destroy();

	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	

	InitialDir = vector(Rotation);
	Velocity = InitialDir * Speed;

	if ( PhysicsVolume.bWaterVolume )
		Velocity = 0.7 * Velocity;

	if (Level.NetMode != NM_DedicatedServer)
	{
		TrailEmitter = Spawn(TrailClass, self,, Location - 15 * InitialDir);
		TrailEmitter.SetBase(self);
	}
	
	SetTimer(0.1, true);
	LeadTargetStartTime = Level.TimeSeconds + LeadTargetDelay;
	super.PostBeginPlay();
}

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();

	Acceleration = Normal(Velocity) * AccelRate;
}

// no notification for monsters only for vehicles
function SetHomingTarget(pawn NewTarget)
{
	if (HomingTarget != None && vehicle(HomingTarget) != None)
		vehicle(HomingTarget).NotifyEnemyLostLock();

	HomingTarget = NewTarget;
	if (HomingTarget != None && vehicle(HomingTarget) != None)
		vehicle(HomingTarget).NotifyEnemyLockedOn();
}

simulated function Timer()
{
    local vector Dir, ForceDir;
    local float VelMag, LowestDesiredZ;
    local bool bLastLockedOn;
    local AIController C;

    if (Role == ROLE_Authority)
    {
	if (Instigator != None && Instigator.Controller != None && INAttackCraftGunA(Owner) != None)
	{
		bLastLockedOn = bLockedOn;
		bLockedOn = INAttackCraftGunA(Owner).bLockedOn;
		HomingTarget = INAttackCraftGunA(Owner).HomingTarget;
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

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) )
		Explode(HitLocation,Vect(0,0,1));
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController PC;

	PlaySound(sound'WeaponSounds.BExplosion3',, 2.5*TransientSoundVolume);

	if ( TrailEmitter != None )
	{
		TrailEmitter.Kill();
		TrailEmitter = None;
	}

    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'NewExplosionA',,,HitLocation + HitNormal*16,rotator(HitNormal));
		PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5000 )
			Spawn(class'ExplosionCrap',,, HitLocation, rotator(HitNormal));

		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
    }

	BlowUp(HitLocation+HitNormal*2.f);
	Destroy();
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location );
	MakeNoise(1.0);
}

defaultproperties
{
     TrailClass=Class'Onslaught.ONSAvrilSmokeTrail'
     AccelRate=3000.000000
     LeadTargetDelay=0.500000
     Speed=5000.000000
     MaxSpeed=7000.000000
     Damage=115.000000
     DamageRadius=225.000000
     MomentumTransfer=50000.000000
     MyDamageType=Class'DEKRPG208.DamTypeINAttackCraftMissleA'
     ExplosionDecal=Class'Onslaught.ONSRocketScorch'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.RocketProj'
     bNetTemporary=False
     bUpdateSimulatedPosition=True
     AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
     LifeSpan=11.000000
     DrawScale=0.500000
     AmbientGlow=32
     SoundVolume=255
     SoundRadius=100.000000
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}
