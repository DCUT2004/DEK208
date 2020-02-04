class TechChildPupae extends TechPupae;

var TechQueen ParentQueen;

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'DCPupae' || P.class == class'DCChildPupae' || P.class == class'DCQueen' || P.class == class'TechPupae' || P.class == class'TechQueen');
}

simulated function PreBeginPlay()
{
//	Log(Owner);
	ParentQueen=TechQueen(Owner);
	if(ParentQueen==none)
		Destroy();
	Super.PreBeginPlay();
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

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	return;
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
