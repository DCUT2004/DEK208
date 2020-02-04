class DEKGoldChildPupae extends DEKGoldSkaarjPupae;
var DEKGoldQueen ParentQueen;


simulated function PreBeginPlay()
{
//	Log(Owner);
	ParentQueen=DEKGoldQueen(Owner);
	if(ParentQueen==none)
		Destroy();
	Super.PreBeginPlay();
}
function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	if(EventInstigator.IsA('GoldQueen'))
		Destroy();
	super.TakeDamage( Damage,EventInstigator,HitLocation, Momentum, DamageType);
}

function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	if(ParentQueen==none || ParentQueen.Controller==none || ParentQueen.Controller.Enemy==self)
	{
		Destroy();
		return;
	}
	if(ParentQueen.Controller!=none && Controller!=none && Health>=0)
	{
		Controller.Enemy=ParentQueen.Controller.Enemy;
		Controller.Target=ParentQueen.Controller.Target;
	}
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	Destroy();
}
function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local vector HitLocation, HitNormal;
	local actor HitActor;
	if(ParentQueen==none)
		return false;
	// check if still in melee range
	If ( (Controller.target != None) && (VSize(Controller.Target.Location - Location) <= MeleeRange * 1.4 + Controller.Target.CollisionRadius + CollisionRadius)
		&& ((Physics == PHYS_Flying) || (Physics == PHYS_Swimming) || (Abs(Location.Z - Controller.Target.Location.Z)
			<= FMax(CollisionHeight, Controller.Target.CollisionHeight) + 0.5 * FMin(CollisionHeight, Controller.Target.CollisionHeight))) )
	{
		HitActor = Trace(HitLocation, HitNormal, Controller.Target.Location, Location, false);
		if ( HitActor != None )
			return false;
		Controller.Target.TakeDamage(hitdamage, ParentQueen,HitLocation, pushdir, class'MeleeDamage');
		return true;
	}
	return false;
}

function Destroyed()
{
	if ( ParentQueen != None )
		ParentQueen.numChildren--;
	Super.Destroyed();
}

function bool SameSpeciesAs(Pawn P)
{
	return false;
}

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int Damage )
{
	RefNormal=normal(HitLocation-Location);
	if(Frand()>0.2)
		return true;
	else
		return false;
}

defaultproperties
{
     ScoringValue=1
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
