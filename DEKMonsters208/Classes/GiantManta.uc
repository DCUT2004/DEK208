class GiantManta extends DCManta;

var Sound KnockbackSound;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.class == class'GiantManta' );
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;
		
	if ( Location.Z - A.Location.Z + A.CollisionHeight <= 0 )
		return;
	if ( VSize(A.Location - Location) > MeleeRange + CollisionRadius + A.CollisionRadius - FMax(0, 0.7 * A.Velocity Dot Normal(A.Location - Location)) )
		return;
	bShotAnim = true;
	Acceleration = AccelRate * Normal(A.Location - Location + vect(0,0,0.8) * A.CollisionHeight);
	AddVelocity( 300*Normal(A.Location - Location) );
	Enable('Bump');
	bStinging = true;
	if (FRand() < 0.5)
	{
		SetAnimAction('Sting');
		PlaySound(sound'whip1m', SLOT_Interact);	 		
	}
	else
	{
 		SetAnimAction('Whip');
 		PlaySound(sound'sting1m', SLOT_Interact); 
 	}	
 }
 
function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local int OldHealth, HealthTaken, TakePercent;


	// increase damage if a block or vehicle
	If ( (Controller.target != None) && Pawn(Controller.target) != None  && Pawn(Controller.target).Health > 0)
	{
	    OldHealth = Pawn(Controller.target).Health;
        TakePercent = 0;
	    if (DruidBlock(Controller.target) != None)
	    {
            hitdamage *= 16;        // if invasion damage to block will get reduced to 40%
            TakePercent = 30;
		}
		else if (vehicle(Controller.target) != None)
		{
            hitdamage *= 4;
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

singular function Bump(actor Other)
{
	local name Anim;
	local float frame,rate;
	
	if ( bShotAnim && bStinging )
	{
		bStinging = false;
		GetAnimParams(0, Anim,frame,rate);
		if ( (Anim == 'Whip') || (Anim == 'Sting') )
		{
			MeleeDamageTarget(40, (10000.0 * Normal(Controller.Target.Location - Location)));
			GiantMantaKnockBack(Controller.Target,(10000.0 * Normal(Controller.Target.Location - Location)) );
		}
		Velocity *= -0.5;
		Acceleration *= -1;
		if (Acceleration.Z < 0)
			Acceleration.Z *= -1;
	}		
	Super.Bump(Other);
}

function GiantMantaKnockBack(Actor Victim, vector Momentum)
{
	local Pawn P;
	local KnockbackInv Inv;
	Local Vector newLocation;

	P = Pawn(Victim);
	if(P == None || !class'RW_Freeze'.static.canTriggerPhysics(P))
		return;

	if (P.FindInventoryType(class'NullEntropyInv') != None)
		return;

	if(P.FindInventoryType(class'KnockbackInv') != None)
		return ;

	Inv = spawn(class'KnockbackInv', P,,, rot(0,0,0));
	if(Inv == None)
		return; //wow
	
	// if they're not walking, falling, or hovering, 
	// the momentum won't affect them correctly, so make them hover.
	// this effect will end when the KnockbackInv expires.
	if(P.Physics != PHYS_Walking && P.Physics != PHYS_Falling && P.Physics != PHYS_Hovering)
		P.SetPhysics(PHYS_Hovering);

	// if they're walking, I need to bump them up 
	// in the air a bit or they won't be knocked back 
	// on no momentum weapons.
	if(P.Physics == PHYS_Walking)
	{
		newLocation = P.Location;
		newLocation.z += 10;
		P.SetLocation(newLocation);
	}
	// The manta normally attacks from slightly above. So lets change the momentum slightly
	if (Momentum.z < 0)
		Momentum.Z = 0.0;

	if (P.Mass > 0)
		Momentum = Momentum*(100.0/P.Mass);
	P.AddVelocity( Momentum );

	Inv.LifeSpan = 2;
	Inv.Modifier = 4;
	Inv.GiveTo(P);

	// if they dont notice they are flying through the air, dont tell them - so comment out
	//if(PlayerController(P.Controller) != None)
 	//	PlayerController(P.Controller).ReceiveLocalizedMessage(class'KnockbackConditionMessage', 0); 
	P.PlaySound(KnockbackSound,,1.5 * Victim.TransientSoundVolume,,Victim.TransientSoundRadius);
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
     KnockbackSound=Sound'WeaponSounds.Misc.ballgun_launch'
     GibGroupClass=Class'DEKMonsters208.DEKTechGibGroup'
     MeleeRange=350.000000
     WaterSpeed=400.000000
     AirSpeed=800.000000
     AccelRate=500.000000
     Health=250
     ControllerClass=Class'DEKMonsters208.TechMonsterController'
     DrawScale=2.500000
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.TechMonsters.TechProjFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster206E.TechMonsters.TechProjFB'
     CollisionRadius=65.000000
     CollisionHeight=32.000000
     Mass=250.000000
     RotationRate=(Pitch=10000,Yaw=48000,Roll=10000)
}
