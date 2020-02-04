class FrostTrapProjectile extends Projectile
	config(DEKWeapons);

#exec OBJ LOAD FILE=..\Sounds\MenuSounds.uax
var sound FreezeSound;

var bool bMinePlanted, bCanDetonate;
var bool bCanHitOwner;
var xEmitter Trail;
var() float DampenFactor, DampenFactorParallel;
var class<xEmitter> HitEffectClass;
var float LastSparkTime;
var Actor IgnoreActor; //don't stick to this actor
var byte Team;
var Emitter Beacon;
var config float DetonationInterval;

replication
{
	reliable if (bNetDirty && Role == ROLE_Authority)
		IgnoreActor, Team, bCanDetonate;
}

simulated function Destroyed()
{
    if ( Trail != None )
        Trail.mRegen = false; // stop the emitter from regenerating
    if ( FrostTrap(Owner) != None)
    	FrostTrap(Owner).CurrentMines--;
	if ( Beacon != None )
		Beacon.Destroy();

    Super.Destroyed();
}

simulated function PostBeginPlay()
{
    local Rotator r;

	Super(Projectile).PostBeginPlay();
	
    if ( Trail != None )
	{
        Trail.mRegen = false;
	}
	    Velocity = Speed * Vector(Rotation);
	//    RandSpin(25000);
	    if (PhysicsVolume.bWaterVolume)
		Velocity = 0.6*Velocity;

	    if (Role == ROLE_Authority && Instigator != None)
		Team = Instigator.GetTeamNum();

	if ( Role==Role_Authority )
	{
		R = Rotation;
        Velocity = Speed * Vector(R);
        R.Yaw = Rotation.Yaw;
        R.Pitch = 0;
        R.Roll = 0;
        SetRotation(R);
        bCanHitOwner = false;
	}
	bCanDetonate = True;
}

simulated function PostNetBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		Beacon = spawn(class'FrostTrapBeacon', self);

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
	local Pawn P;
	local Projectile Proj;
	local FriendlyMonsterInv Inv;
	local Vehicle Vehicle;
	
	P = Pawn(Other);
	if (P != None)
		Inv = FriendlyMonsterInv(P.FindInventoryType(class'FriendlyMonsterInv'));
	if (Inv != None)
		return;		//This is a pet.
	Proj = Projectile(Other);
	if (InstigatorController != None)
		Vehicle = InstigatorController.Pawn.DrivenVehicle;
	
	if (Proj != None)
		return;
	
    if (!bMinePlanted && !bPendingDelete && Base == None && Other != IgnoreActor && (!Other.bWorldGeometry && Other.Class != Class && (Other != Instigator || bCanHitOwner)))
	{
		if (P != None)
			return;
		else
			Stick(Other, HitLocation);
	}
	
	if (Vehicle != None)
		return;		//To keep traps from exploding on friendly players and pets when user is in turret/vehicle. Oh well.
	if (P != None && !P.IsA('Monster'))
		return;
		
	if (Base != None && P != None && P != Instigator && P.Health > 0 && P.IsA('Monster') && InstigatorController != None && !P.Controller.SameTeamAs(InstigatorController) && Inv == None && Vehicle == None && !P.IsA('HealerNali') && !P.IsA('MissionCow') && bCanDetonate)
	{
		if (!P.Controller.SameTeamAs(InstigatorController) && !InstigatorController.SameTeamAs(P.Controller))
		{
			Explode(Location, vect(0,0,1));
			bCanDetonate = False;
			if (Beacon != None)
				Beacon.Destroy();
			SetTimer(DetonationInterval, False);
		}
	}
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    local PlayerController PC;

    if (Vehicle(Wall) != None && !bMinePlanted)
    {
        Touch(Wall);
        return;
    }

    else if ( !bMinePlanted )
    {
	PlaySound(Sound'MenuSounds.Select3');
	bBounce = False;
	SetPhysics(PHYS_None);
	bCollideWorld = False;
	bMinePlanted = true;
	}

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

simulated function Undeploy()
{
    LastTouched = Base;
	Destroy();
	PlaySound(Sound'MenuSounds.selectDshort',,2.5*TransientSoundVolume);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local Actor A, B, C;

	if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, 50000, Location);
		A = Spawn(class'FrostFX',,, Location, rotator(vect(0,0,1)));
		B = Spawn(Class'BlueGoopSmokeLarge',,,Location,rotator(HitNormal));
		C = Spawn(Class'FrostSmoke',,,Location,rotator(HitNormal));
		if (A != None)
			A.RemoteRole = ROLE_SimulatedProxy;
		if (B != None)
			B.RemoteRole = ROLE_SimulatedProxy;
		if (C != None)
			C.RemoteRole = ROLE_SimulatedProxy;
		BoomSound();
	}
}

function BoomSound()
{
	self.PlaySound(FreezeSound,,500.00);
}

simulated function Timer()
{
	bCanDetonate = True;
	
	if ( Level.NetMode != NM_DedicatedServer )
	{
		Beacon = spawn(class'FrostTrapBeacon', self);

		if (Beacon != None)
			Beacon.SetBase(self);
	}
}

simulated function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	return; //do nothing. Engineer mines can't be destroyed.
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
	Destroy();
}

simulated function tick ( float DeltaTime)
{
	if (Instigator == None)
		Destroy();
	super.tick(DeltaTime);
}

defaultproperties
{
     FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
     DampenFactor=0.500000
     DampenFactorParallel=0.800000
     HitEffectClass=Class'XEffects.WallSparks'
     DetonationInterval=15.000000
     Speed=2000.000000
     TossZ=0.000000
     bSwitchToZeroCollision=True
     Damage=200.000000
     DamageRadius=300.000000
     MomentumTransfer=50000.000000
     MyDamageType=Class'DEKRPG208.DamTypeFrostTrap'
     ImpactSound=Sound'MenuSounds.select3'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DEKStaticsMaster207P.Meshes.FrostTrap'
     CullDistance=5000.000000
     bNetTemporary=False
     bOnlyDirtyReplication=True
     Physics=PHYS_Falling
     AmbientSound=Sound'CicadaSnds.Decoy.DecoyFlight'
     LifeSpan=0.000000
     DrawScale=0.590625
     AmbientGlow=100
     bHardAttach=True
     CollisionRadius=45.000000
     CollisionHeight=10.000000
     bProjTarget=True
     bUseCollisionStaticMesh=True
     bFixedRotationDir=True
     DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
}
