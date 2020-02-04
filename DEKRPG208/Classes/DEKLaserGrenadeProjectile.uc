class DEKLaserGrenadeProjectile extends Projectile;

var xEmitter ProjBeam;
var float mineTraceRange, LaserDamage;
var bool bMinePlanted, bUseRealisticGrenade;
var bool bCanHitOwner;
var xEmitter Trail;
var() float DampenFactor, DampenFactorParallel;
var class<xEmitter> HitEffectClass;
var float LastSparkTime;
var Actor IgnoreActor; //don't stick to this actor
var byte Team;
var Emitter Beacon;

replication
{
	reliable if (bNetDirty && Role == ROLE_Authority)
		IgnoreActor, Team;
}

simulated function Destroyed()
{
    if ( Trail != None )
        Trail.mRegen = false; // stop the emitter from regenerating
    if ( DEKLaserGrenadeLauncher(Owner) != None)
    	DEKLaserGrenadeLauncher(Owner).CurrentMines--;
	if ( Beacon != None )
		Beacon.Destroy();
    if ( ProjBeam != None )
		ProjBeam.Destroy();
    if ( !bNoFX )
    {
		return;
	}

    Super.Destroyed();
}

simulated function PostBeginPlay()
{
	local PlayerController PC;
	local float InstigatorPitch;
	local vector OwnerVelocity;

	Super(Projectile).PostBeginPlay();

	    if ( Level.NetMode != NM_DedicatedServer)
	    {
			PC = Level.GetLocalPlayerController();
			if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5500 )
			Trail = Spawn(class'GrenadeSmokeTrail', self,, Location, Rotation);
	    }

	    Velocity = Speed * Vector(Rotation);
	//    RandSpin(25000);
	    if (PhysicsVolume.bWaterVolume)
		Velocity = 0.6*Velocity;

	    if (Role == ROLE_Authority && Instigator != None)
		Team = Instigator.GetTeamNum();

	if ( Role==Role_Authority )
	{
	   if ( Instigator != None )
	       OwnerVelocity=Instigator.Velocity;

	   If ( Instigator.IsHumanControlled() && Instigator != None )
	   {
	       InstigatorPitch=Instigator.Controller.Rotation.Pitch;
	    
	       if ( InstigatorPitch > 49152 && InstigatorPitch < 65536 )
	          InstigatorPitch = 65536 - InstigatorPitch;

               else
	          InstigatorPitch=0;
	    
	       if ( bUseRealisticGrenade )
	       {
	            Velocity.X += OwnerVelocity.X * 0.5;
	            Velocity.Y += OwnerVelocity.Y * 0.5;
	            Velocity.Z +=  0.9 * (( Sin ( pi * InstigatorPitch/16384 + 3*pi/2) + 1) * 0.5 )  * OwnerVelocity.Z;
               }
	      
	   }
        
	}

    
}

simulated function PostNetBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		if (Team == 1)
			Beacon = spawn(class'ONSGrenadeBeaconBlue', self);
		else
			Beacon = spawn(class'ONSGrenadeBeaconRed', self);

		if (Beacon != None)
			Beacon.SetBase(self);
	}
	Super.PostNetBeginPlay();
}

simulated function Landed( vector HitNormal )
{
  if ( bMinePlanted )
	Explode(Location,vector(rotation));//  HitWall( HitNormal, None );
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
    if (!bMinePlanted && !bPendingDelete && Base == None && Other != IgnoreActor && (!Other.bWorldGeometry && Other.Class != Class && (Other != Instigator || bCanHitOwner)))
	Stick(Other, HitLocation);
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    local PlayerController PC;
    local Actor HitActor;
    local Vector BeamHitLocation,BeamHitNormal;
    local Vector EndTrace;

    if (Vehicle(Wall) != None && !bMinePlanted)
    {
        Touch(Wall);
        return;
    }

    else if ( !bMinePlanted )
    {
	PlaySound(Sound'MenuSounds.Select3',,2.5*TransientSoundVolume);
	bBounce = False;
	SetPhysics(PHYS_None);
	bCollideWorld = False;
	SetRotation(rotator(HitNormal));
    
	EndTrace = Location + vector(Rotation) * mineTraceRange;
	HitActor=Instigator.Trace(BeamHitLocation,BeamHitNormal,EndTrace,Location,false);
	//log ("HitActor "$HitActor);
	if ( HitActor != None )
	{
		if ( Level.NetMode != NM_DedicatedServer )
		{
			if (Instigator.GetTeamNum() == 1)
				ProjBeam = spawn(class'DEKLaserGrenadeProjBeamEffectBlue', self);
    
			else
				ProjBeam = spawn(class'DEKLaserGrenadeProjBeamEffectRed', self);

			ProjBeam.mSpawnVecA = BeamHitLocation;
		}
		bMinePlanted = true;
	}

    }
    //else
	//
    
    

    
    if ( Trail != None )
          Trail.mRegen = false; // stop the emitter from regenerating

    else
    {
		if ( (Level.NetMode != NM_DedicatedServer) && (Speed > 250) )
			PlaySound(ImpactSound, SLOT_Misc );
        if ( !Level.bDropDetail && (Level.DetailMode != DM_Low) && (Level.TimeSeconds - LastSparkTime > 0.5) && EffectIsRelevant(Location,false) )
        {
			PC = Level.GetLocalPlayerController();
			if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 2000 )
				Spawn(HitEffectClass,,, Location, Rotator(HitNormal));
            LastSparkTime = Level.TimeSeconds;
        }
    }
}

simulated function tick ( float DeltaTime)
{
    local Actor HitActor, A;
    local Vector BeamHitLocation,BeamHitNormal;
    local Vector EndTrace;
	local Pawn P;
	local Monster M;
	local FriendlyMonsterInv Inv;
	local Vehicle V;

    if ( Role == Role_Authority )
	{
		if ( bMinePlanted )
		{
		    EndTrace = Location + vector(Rotation) * mineTraceRange;
		    HitActor=Trace(BeamHitLocation,BeamHitNormal,EndTrace,Location,true);
			P = Pawn(HitActor);
			V = InstigatorController.Pawn.DrivenVehicle;
			if (P != None && P.Health > 0 && P.IsA('Monster'))
				Inv = FriendlyMonsterInv(P.FindInventoryType(class'FriendlyMonsterInv'));
			
		    //log ("HitActor "$HitActor);
		    
		    if ( Instigator != None && P != Instigator && P != None && P.Controller != None && P.Health > 0 && !P.Controller.SameTeamAs(InstigatorController) && Inv == None && V == None && !P.IsA('HealerNali'))
		    {
				P.TakeDamage(LaserDamage, Instigator, M.Location, vect(100,100,100), class'DamTypeLaserGrenadeLaser');
				if (Instigator.GetTeamNum() == 1)
				{
					A = M.spawn(class'DEKLaserGrenadeBlueLaserHit', M,, M.Location, M.Rotation);
				}
				else
				{
					A = M.spawn(class'DEKLaserGrenadeRedLaserHit', M,, M.Location, M.Rotation);
				}
				if (A != None)
				{
					A.RemoteRole = ROLE_SimulatedProxy;
				}
			}
		   }
	}

	if ( Level.NetMode != NM_DedicatedServer && ProjBeam != None )
		ProjBeam.SetLocation(Location);
		
	super.tick(DeltaTime);
}

simulated function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	return; // do nothing.
}

simulated function Stick(actor HitActor, vector HitLocation)
{
    if ( Trail != None )
        Trail.mRegen = false; // stop the emitter from regenerating

    bBounce = False;
    LastTouched = HitActor;
    SetPhysics(PHYS_None);
    SetBase(HitActor);
    if (Base == None)
    {
    	UnStick();
    	return;
    }
    bCollideWorld = False;
    bProjTarget = true;

	PlaySound(Sound'MenuSounds.Select3',,2.5*TransientSoundVolume);
}

simulated function UnStick()
{
	Velocity = vect(0,0,0);
	IgnoreActor = Base;
	SetBase(None);
	SetPhysics(PHYS_Falling);
	bCollideWorld = true;
	bProjTarget = false;
	LastTouched = None;
}

simulated function BaseChange()
{
	if (!bPendingDelete && Physics == PHYS_None && Base == None)
		UnStick();
}

simulated function PawnBaseDied()
{
	Explode(Location, vect(0,0,1));
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    LastTouched = Base;
    BlowUp(HitLocation);
    Destroy();
}

defaultproperties
{
     mineTraceRange=30000.000000
     LaserDamage=1.000000
     Speed=2000.000000
     TossZ=0.000000
     bSwitchToZeroCollision=True
     Damage=50.000000
     DamageRadius=87.500000
     MomentumTransfer=30000.000000
     MyDamageType=Class'DEKRPG208.DamTypeLaserGrenadeExplosion'
     ImpactSound=Sound'MenuSounds.select3'
     ExplosionDecal=Class'Onslaught.ONSRocketScorch'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'VMWeaponsSM.PlayerWeaponsGroup.VMGrenade'
     CullDistance=5000.000000
     bNetTemporary=False
     bOnlyDirtyReplication=True
     Physics=PHYS_Falling
     LifeSpan=0.000000
     DrawScale=0.037500
     AmbientGlow=100
     bHardAttach=True
     CollisionRadius=0.500000
     CollisionHeight=0.500000
     bProjTarget=True
     bUseCollisionStaticMesh=True
     bBounce=True
     bFixedRotationDir=True
     DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
}
