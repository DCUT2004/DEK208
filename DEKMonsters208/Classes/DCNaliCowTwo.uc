class DCNaliCowTwo extends DCNaliCow;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.Class == class'DCNaliCowTwo' || P.Class == class'DCNaliCow' || P.Class == class'DCNali' || P.Class == class'DCNaliFighter');
}

function RangedAttack(Actor A)
{
	local float Dist;
	
	Super.RangedAttack(A);
	
	if ( bShotAnim )
	{
		return;
	}
		
	Dist = VSize(A.Location - Location);
	if ( Dist > MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		return;
	}
	bShotAnim = true;
		
	MeleeDamageTarget(12, (15000.0 * Normal(A.Location - Location)));
	PlaySound(sound'mn_hit10', SLOT_Talk); 
	SetAnimAction('Swish');
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
}

function PlayVictory()
{
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
	PlayAnim('Poop', 1.0, 0.1);
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');
}

defaultproperties
{
     bMeleeFighter=True
     bAmbientCreature=False
     MeleeRange=40.000000
     GroundSpeed=340.000000
     WaterSpeed=169.000000
     AirSpeed=338.000000
     JumpZ=261.000000
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
