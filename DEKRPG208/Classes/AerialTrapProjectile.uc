class AerialTrapProjectile extends Projectile
	config(DEKWeapons);

#exec OBJ LOAD FILE=..\Sounds\MenuSounds.uax

var bool bMinePlanted, bCanDetonate;
var bool bCanHitOwner;
var xEmitter Trail;
var() float DampenFactor, DampenFactorParallel;
var class<xEmitter> HitEffectClass;
var float LastSparkTime;
var Actor IgnoreActor; //don't stick to this actor
var byte Team;
var Emitter Beacon;
var config float StrikeInterval;
var class<DamageType> MiniboltDamageType;
var int MiniboltDamage;
var int MiniboltRadius;

replication
{
	reliable if (bNetDirty && Role == ROLE_Authority)
		IgnoreActor, Team, bCanDetonate;
}

simulated function Destroyed()
{
    if ( Trail != None )
        Trail.mRegen = false; // stop the emitter from regenerating
    if (Role == ROLE_Authority && bScriptInitialized && AerialTrap(Owner) != None)
    	AerialTrap(Owner).CurrentMines--;
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
	SetPhysics(PHYS_Hovering);
    Velocity = vect(0,0,0);
	bCanDetonate = True;
	SetTimer(StrikeInterval, True);
}

simulated function PostNetBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		Beacon = spawn(class'AerialTrapBeacon', self);

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
	if (P != None && P.Health > 0)
	{
		if (P.Controller.SameTeamAs(InstigatorController))
			return;
		if (InstigatorController != None && P.Controller != None && InstigatorController.SameTeamAs(P.Controller))
			return;
		if (!P.IsA('Monster'))
			return;
		if (P.PlayerReplicationInfo != None && !P.PlayerReplicationInfo.bBot)
			return;
	}
		
	if (Base != None && P != None && P != Instigator && P.Health > 0 && P.IsA('Monster') && P.PlayerReplicationInfo.bBot && !P.Controller.SameTeamAs(InstigatorController) && Inv == None && Vehicle == None && !P.IsA('HealerNali') && bCanDetonate)
	{
		if (!P.Controller.SameTeamAs(InstigatorController) && !InstigatorController.SameTeamAs(P.Controller))
		{
			if (P.Physics == PHYS_Flying)
			{
				Explode(Location, vect(0,0,1));
				bCanDetonate = False;
				if (Beacon != None)
						Beacon.Destroy();
			}
			else
				return;
		}
		else
			return;
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
	if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, 50000, Location);
		BoomSound();
	}
}

function BoomSound()
{
	self.PlaySound(sound'WeaponSounds.BExplosion3',,500.00);
}

simulated function Timer()
{
	local Pawn P;
    local Actor Victim;
    local vector Direction;
    local float Distance;
    local vector HitLocation;
    local vector Momentum;
    local AerialTrapBolt Bolt;

    // Zap all nearby targets.
    foreach VisibleCollidingActors(class'Actor', Victim, MiniboltRadius, Location)
    {
		P = Pawn(Victim);
        if(Victim.Role == ROLE_Authority && Victim != self && Victim != None && P != None && P.Controller != None && ( Victim != Instigator || P != Instigator || P != Instigator.Controller) && (Victim.IsA('Monster') || Victim.IsA('ONSPowerCore') || Victim.IsA('DestroyableObjective')) && P.Health > 0 && !P.Controller.SameTeamAs(Instigator.Controller))
        {
			if (P.Physics == PHYS_Flying)
			{
				Direction = Victim.Location - HitLocation;
				Distance = FMax(1, VSize(Direction));
				Direction = Direction / Distance;
				HitLocation = Victim.Location - Direction * 0.5 * (Victim.CollisionHeight + Victim.CollisionRadius);
				Momentum = Direction * MomentumTransfer;

				Bolt = Spawn(class'AerialTrapBolt',,, Location, rotator(P.Location - Location));
				if (Bolt != None)
				{
					Bolt.mSpawnVecA = P.Location;
				}
				// Attach the bolt to the ball and to the target?
				//Bolt.SetBase(self);

				// Deal damage.
				P.TakeDamage(MiniboltDamage, Instigator, HitLocation, Momentum, MiniboltDamageType);
			}
        }
    }
	if (Beacon == None)
	{
		Beacon = spawn(class'AerialTrapBeacon', self);
		Beacon.SetBase(self);
	}
	
	bCanDetonate = True;
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
     DampenFactor=0.500000
     DampenFactorParallel=0.800000
     HitEffectClass=Class'XEffects.WallSparks'
     StrikeInterval=5.000000
     MiniboltDamageType=Class'DEKRPG208.DamTypeAerialTrapBolt'
     MiniboltDamage=100
     MiniboltRadius=700
     TossZ=0.000000
     bSwitchToZeroCollision=True
     Damage=50.000000
     DamageRadius=200.000000
     MomentumTransfer=50000.000000
     MyDamageType=Class'DEKRPG208.DamTypeAerialTrap'
     ImpactSound=Sound'MenuSounds.select3'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DEKStaticsMaster207P.Meshes.AerialTrap'
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
