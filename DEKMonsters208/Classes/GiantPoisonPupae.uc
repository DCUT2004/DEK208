class GiantPoisonPupae extends PoisonPupae; //SkaarjPupae;

function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local vector HitLocation, HitNormal;
	local actor HitActor;
	
	// check if still in melee range
	if ( (Controller.Target != None) && (VSize(Controller.Target.Location - Location) <= MeleeRange * 1.4 + Controller.Target.CollisionRadius + CollisionRadius)
		&& ((Physics == PHYS_Flying) || (Physics == PHYS_Swimming) || (Abs(Location.Z - Controller.Target.Location.Z) 
			<= FMax(CollisionHeight, Controller.Target.CollisionHeight) + 0.5 * FMin(CollisionHeight, Controller.Target.CollisionHeight))) )
	{	
		HitActor = Trace(HitLocation, HitNormal, Controller.Target.Location, Location, false);
		if ( HitActor != None )
			return false;

		// hee hee  got a hit. Poison the dude
		PoisonTarget(Controller.Target, class'MeleeDamage');

		return super.MeleeDamageTarget(hitdamage, pushdir);
	}
	return false;
}

singular function Bump(actor Other)
{
	local name Anim;
	local float frame,rate;

	if ( bShotAnim && bLunging )
	{
		bLunging = false;
		GetAnimParams(0, Anim,frame,rate);
		if ( Anim == 'Lunge' )
			MeleeDamageTarget(30, (20000.0 * Normal(Controller.Target.Location - Location)));
	}
	Super.Bump(Other);
}

function RangedAttack(Actor A)
{
	local float Dist;

	if ( bShotAnim )
		return;

	Dist = VSize(A.Location - Location);
	if ( Dist > 500 )
		return;
	bShotAnim = true;
	PlaySound(ChallengeSound[Rand(4)], SLOT_Interact);
	if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
  		if ( FRand() < 0.5 )
  			SetAnimAction('Bite');
  		else
  			SetAnimAction('Stab');
		MeleeDamageTarget(30, vect(0,0,0));
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		return;
	}

	// lunge at enemy
	bLunging = true;
	Enable('Bump');
	SetAnimAction('Lunge');
	Velocity = 500 * Normal(A.Location + A.CollisionHeight * vect(0,0,0.75) - Location);
	if ( dist > CollisionRadius + A.CollisionRadius + 35 )
		Velocity.Z += 0.7 * dist;
	SetPhysics(PHYS_Falling);
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.Class == class'GiantPoisonPupae' || P.Class == class'PoisonPupae' );
}

defaultproperties
{
     PoisonModifier=4
     ScoringValue=5
     JumpZ=400.000000
     Health=140
     DrawScale=2.200000
     CollisionRadius=60.000000
     CollisionHeight=25.000000
     Mass=200.000000
}
