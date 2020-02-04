class DCChildPupae extends SMPChildPupae;

var DCQueen ParentQueenE;

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'DCPupae' || P.class == class'DCChildPupae' || P.class == class'DCQueen');
}

singular function Bump(actor Other)
{
	local name Anim;
	local float frame,rate;
	
	if ( bShotAnim && bLunging )
	{
		bLunging = false;
		GetAnimParams(0, Anim,frame,rate);
		if ( Controller != None && Controller.Target != None && Anim == 'Lunge' )
			MeleeDamageTarget(12, (20000.0 * Normal(Controller.Target.Location - Location)));
	}		
	Super.Bump(Other);
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	if(EventInstigator.IsA('DCQueen'))
		Destroy();
	super.TakeDamage( Damage,EventInstigator,HitLocation, Momentum, DamageType);		
}

simulated function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	Spawn(class'RocketSmokeRing');
	Destroy();
}

simulated function Destroyed()
{
	if ( ParentQueenE != None )
		ParentQueenE.numChildren--;
	Super.Destroyed();
	Spawn(class'RocketSmokeRing');
}

defaultproperties
{
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
