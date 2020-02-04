class PlasmaGrenadeProjectile extends Projectile;

var bool bCanHitOwner;
var xEmitter Trail;
var() float DampenFactor, DampenFactorParallel;
var class<xEmitter> HitEffectClass;
var float LastSparkTime;
//var float ExplodeTimer;
var()   float   DetectionTimer; // check target every this many seconds
var bool bTimerSet;
var() float TouchDetonationDelay;
var() float SearchRange;
var     Pawn    TargetPawn;
var     int     TeamNum;


var PlasmaBall PlasmaBallEffect;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        TargetPawn;
}

auto state Flying
{
    simulated function Landed( vector HitNormal )
    {
        HitWall( HitNormal, None );
    }

    simulated function HitWall( vector HitNormal, Actor Wall )
    {
    if ( (Pawn(Wall) != None) || (GameObjective(Wall) != None) )
	{
		Explode(Location, HitNormal);
		return;
	}

     GotoState('Floating');
     }

    simulated function BeginState()
    {
    	SetPhysics(PHYS_Projectile);
    }
}

simulated state Floating
{
    simulated function Timer()
    {
        if (Role < ROLE_Authority)
        {
            if (TargetPawn != None)
               Explode(Location, vect(0,0,1));
            return;
        }

        if (Instigator == None)
            BlowUp(Location);

    	AcquireTarget();

        if (TargetPawn != None)
            {
            Explode(Location, vect(0,0,1));
            return;
            }
    }

    simulated function BeginState()
    {
    	SetPhysics(PHYS_Hovering);
    	Velocity = vect(0,0,0);
        SetTimer(DetectionTimer, True);
        Timer();
    }

    simulated function EndState()
    {
        SetTimer(0, False);
    }

    Begin:
        bRotateToDesired = False;
        sleep(0.4);
}



simulated function Destroyed()
{
    if (PlasmaBallEffect != None)
    {
		if ( bNoFX )
			PlasmaBallEffect.Destroy();
		else
			PlasmaBallEffect.Kill();
	}    

    //explosion

    BlowUp(Location);
    PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(class'PlasmaExplosion',,, Location, rotator(vect(0,0,1)));
    }

    if ( !bNoFX )
    {
	   PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
	}
    if ( PlasmaGrenadeLauncher(Owner) != None)
    	   PlasmaGrenadeLauncher(Owner).CurrentGrenades--;

    Super.Destroyed();
}

simulated function PostBeginPlay()
{
	local PlayerController PC;

    Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer)
    {
		PC = Level.GetLocalPlayerController();
	      PlasmaBallEffect = Spawn(class'PlasmaBall', self);
            PlasmaBallEffect.SetBase(self);
    }

    Velocity = Speed * Vector(Rotation);
    RandSpin(25000);
    if (PhysicsVolume.bWaterVolume)
        Velocity = 0.6*Velocity;

    }

simulated function PostNetBeginPlay()
{
      if (Role < ROLE_Authority && Physics == PHYS_None)
    {
        bProjTarget = true;
        GotoState('OnGround');
    }
}

simulated function Landed( vector HitNormal )
{
    HitWall( HitNormal, None );
}


simulated function ProcessTouch( actor Other, vector HitLocation )
{
	local Pawn P;
	
	P = Pawn(Other);
	
	if (Other == None || Other.bWorldGeometry || P == None || P.Health <= 0 || P == Instigator || P.Controller.SameTeamAs(Instigator.Controller) || PlasmaGrenadeProjectile(Other) != None)
		return;
	else
		Explode(HitLocation, Normal(HitLocation-Other.Location));
}


simulated function BlowUp(vector HitLocation)
{
	DelayedHurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	if ( Role == ROLE_Authority )
		MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    Destroy();
}

simulated function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
    if (Damage > 0 && EventInstigator != None && (EventInstigator.GetTeamNum() != Instigator.GetTeamNum()))
	{
		if (DamageType.default.bDetonatesGoop && DamageType != MyDamageType)
		{
			Explode(Location, vect(0,0,1));
        }
    }
}

function AcquireTarget()
{
	local Pawn A;
	local float Dist, BestDist;

    TargetPawn = None;

    foreach VisibleCollidingActors(class'Pawn', A, SearchRange)
    {
        if ( A != Instigator && A.Health > 0 && (!A.Controller.SameTeamAs(Instigator.Controller) || (A.Controller.GetTeamNum() != Instigator.Controller.GetTeamNum())))
	    {
	    	Dist = VSize(A.Location - Location);
			TargetPawn = A;
			if (Dist < BestDist)
			{
				BestDist = Dist;
			}	
        }
	}
}

defaultproperties
{
     DampenFactor=0.500000
     DampenFactorParallel=0.800000
     HitEffectClass=Class'XEffects.WallSparks'
     DetectionTimer=0.005000
     TouchDetonationDelay=0.010000
     SearchRange=110.000000
     Speed=625.000000
     MaxSpeed=700.000000
     TossZ=0.000000
     bSwitchToZeroCollision=True
     Damage=45.000000
     MomentumTransfer=15000.000000
     MyDamageType=Class'DEKWeapons208.DamTypePlasmaGrenade'
     ImpactSound=ProceduralSound'WeaponSounds.PGrenFloor1.P1GrenFloor1'
     ExplosionDecal=Class'XEffects.RocketMark'
     DrawType=DT_StaticMesh
     CullDistance=5000.000000
     bNetTemporary=False
     bOnlyDirtyReplication=True
     LifeSpan=10.000000
     DrawScale=0.075000
     AmbientGlow=100
     bHardAttach=True
     CollisionRadius=14.000000
     CollisionHeight=14.000000
     bProjTarget=True
     bBounce=True
     bFixedRotationDir=True
     DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
}
