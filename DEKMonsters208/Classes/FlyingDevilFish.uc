class FlyingDevilFish extends DCDevilFish;

function Landed(vector HitNormal)
{
	return;
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.class == class'FlyingDevilFish' );
}

function SetMovementPhysics()
{
	bFlopping = false;
	SetPhysics(PHYS_Flying);
}

function bool CheckWater()
{
	return True;
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
		
	MeleeDamageTarget(BiteDamage, (BiteDamage * 1000.0 * Normal(Controller.Target.Location - Location)));
	SetAnimAction('Bite1');
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     MeleeRange=25.000000
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
