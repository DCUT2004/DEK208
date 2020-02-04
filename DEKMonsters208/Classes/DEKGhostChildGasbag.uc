class DEKGhostChildGasbag extends DEKGhostGasbag;

var DEKGhostGiantGasBag ParentBag;

var() byte
	PunchDamage,	// Basic damage done by each punch.
	PoundDamage;	// Basic damage done by pound.

simulated function PreBeginPlay()
{
//	Log(Owner);
	ParentBag=DEKGhostGiantGasBag(Owner);
	if(ParentBag==none)
		Destroy();
	Super.PreBeginPlay();
}
function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	if(ParentBag==none || ParentBag.Controller==none || ParentBag.Controller.Enemy==self)
	{
		Destroy();
		return;
	}
	if(ParentBag.Controller!=none && Controller!=none && Health>=0)
	{
		Controller.Enemy=ParentBag.Controller.Enemy;
		Controller.Target=ParentBag.Controller.Target;
	}
}
function PunchDamageTarget()
{
	if(Controller==none || Controller.Target==none) return;
	if (MeleeDamageTarget(PunchDamage, (39000 * Normal(Controller.Target.Location - Location))))
		PlaySound(sound'Hit1g', SLOT_Interact);
}

function PoundDamageTarget()
{
	if(Controller==none || Controller.Target==none) return;
	if (MeleeDamageTarget(PoundDamage, (24000 * Normal(Controller.Target.Location - Location))))
		PlaySound(sound'Hit1g', SLOT_Interact);
}
function Destroyed()
{
	if ( ParentBag != None )
		ParentBag.numChildren--;
	Super.Destroyed();
}
function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local vector HitLocation, HitNormal;
	local actor HitActor;
	if(ParentBag==none)
		return false;
	// check if still in melee range
	If ( (Controller.target != None) && (VSize(Controller.Target.Location - Location) <= MeleeRange * 1.4 + Controller.Target.CollisionRadius + CollisionRadius)
		&& ((Physics == PHYS_Flying) || (Physics == PHYS_Swimming) || (Abs(Location.Z - Controller.Target.Location.Z)
			<= FMax(CollisionHeight, Controller.Target.CollisionHeight) + 0.5 * FMin(CollisionHeight, Controller.Target.CollisionHeight))) )
	{
		HitActor = Trace(HitLocation, HitNormal, Controller.Target.Location, Location, false);
		if ( HitActor != None )
			return false;
		Controller.Target.TakeDamage(hitdamage, ParentBag,HitLocation, pushdir, class'MeleeDamage');
		return true;
	}
	return false;
}
simulated function SpawnGiblet( class<Gib> GibClass, Vector Location, Rotator Rotation, float GibPerterbation )
{
    local Gib Giblet;
    local Vector Direction, Dummy;

    if( (GibClass == None) || class'GameInfo'.static.UseLowGore() )
        return;

	Instigator = self;
    Giblet = Spawn( GibClass,,, Location, Rotation );

    if( Giblet == None )
        return;

	Giblet.SetDrawScale(Giblet.DrawScale * (CollisionRadius+CollisionHeight)/69); // 69 = 25 + 44
    GibPerterbation *= 32768.0;
    Rotation.Pitch += ( FRand() * 2.0 * GibPerterbation ) - GibPerterbation;
    Rotation.Yaw += ( FRand() * 2.0 * GibPerterbation ) - GibPerterbation;
    Rotation.Roll += ( FRand() * 2.0 * GibPerterbation ) - GibPerterbation;

    GetAxes( Rotation, Dummy, Dummy, Direction );

    Giblet.Velocity = Velocity + Normal(Direction) * 512.0;
}
function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	Destroy();
}

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

simulated function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType)
{
	Momentum = vect(0,0,0);		// its a ghost - you can't knock it back
	Super.TakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, damageType);
}

defaultproperties
{
     PunchDamage=25
     PoundDamage=35
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
