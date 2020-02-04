class FireChildSkaarjPupae extends FireSkaarjPupae;

var FireQueen ParentQueen;

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'DCPupae' || P.class == class'DCChildPupae' || P.class == class'FireSkaarjPupae' || P.Class == class'FireQueen');
}

simulated function PreBeginPlay()
{
//	Log(Owner);
	ParentQueen=FireQueen(Owner);
	if(ParentQueen==none)
		Destroy();
	Super.PreBeginPlay();
}
function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	if(EventInstigator.IsA('FireQueen'))
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

simulated function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	Spawn(class'RocketSmokeRing');
	Destroy();
}

simulated function Destroyed()
{
	if ( ParentQueen != None )
		ParentQueen.numChildren--;
	Super.Destroyed();
	Spawn(class'RocketSmokeRing');
}

defaultproperties
{
}
