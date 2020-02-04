class TechChildRazorfly extends TechRazorfly;

var TechQueen ParentQueen;

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'DCRazorfly' || P.class == class'TechQueen' || P.class == class'TechRazorfly');
}

simulated function PreBeginPlay()
{
//	Log(Owner);
	ParentQueen=TechQueen(Owner);
	if(ParentQueen==none)
		Destroy();
	Super.PreBeginPlay();
}

simulated function Tick(float DeltaTime) ////////
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

function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local int OldHealth, HealthTaken, TakePercent;
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

	// increase damage if a block or vehicle
	If ( (Controller.target != None) && Pawn(Controller.target) != None  && Pawn(Controller.target).Health > 0)
	{
	    OldHealth = Pawn(Controller.target).Health;
        TakePercent = 0;
	    if (DruidBlock(Controller.target) != None)
	    {
            hitdamage *= 50;        // if invasion damage to block will get reduced to 40%
            TakePercent = 30;
		}
		else if (vehicle(Controller.target) != None)
		{
            hitdamage *= 50;
            TakePercent = 15;
		}
	}

	if (super.MeleeDamageTarget(hitdamage, pushdir))
	{
	    // hit it
	    if (Controller.target == None || Pawn(Controller.target).Health <= 0)
	        HealthTaken = OldHealth;
		else
		    HealthTaken = OldHealth - Pawn(Controller.target).Health;
		if (HealthTaken < 0)
		    HealthTaken = 0;
		// now take some health back
		if (HealthTaken > 0)
		{
			HealthTaken = max((HealthTaken * TakePercent)/100.0, 1);
			GiveHealth(HealthTaken, HealthMax);
		}

		return true;
	}

	return false;
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	// Can't hurt it!
}

simulated function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	Spawn(class'ONSPlasmaHitPurple');
	Destroy();
}

simulated function Destroyed()
{
	if ( ParentQueen != None )
		ParentQueen.numChildren--;
	Super.Destroyed();
	Spawn(class'ONSPlasmaHitPurple');
}

defaultproperties
{
     GoopIntervalTime=0.500000
     ScoringValue=0
     Health=50
}
