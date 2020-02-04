//Code by Special Skaarj Packv4, based off of SSPSlug. Credit goes to its respectful owner.

class PoisonSlug extends DCSlith;

var int PoisonLifespan;
var int PoisonModifier;
var RPGRules RPGRules;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.Class == class'PoisonPupae' || P.Class == class'PoisonQueen' );
}

function PostBeginPlay()
{
	Local GameRules G;
	super.PostBeginPlay();
	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			RPGRules = RPGRules(G);
			break;
		}
	}

}

function PoisonTarget(Actor Victim, class<DamageType> DamageType)
{
	local DruidPoisonInv Inv;
	local Pawn P;
	local MagicShieldInv MInv;

	P = Pawn(Victim);
	if (P != None)
	{
		MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
		if (MInv == None)
		{
			Inv = DruidPoisonInv(P.FindInventoryType(class'DruidPoisonInv'));
			if (Inv == None)
			{
				Inv = spawn(class'DruidPoisonInv', P,,, rot(0,0,0));
				Inv.Modifier = PoisonModifier;
				Inv.LifeSpan = PoisonLifespan;
				Inv.RPGRules = RPGRules;
				Inv.GiveTo(P);
			}
			else
			{
				Inv.Modifier = max(PoisonModifier,Inv.Modifier);
				Inv.LifeSpan = max(PoisonLifespan,Inv.LifeSpan);
			}
		}
		else
			return;
	}
}

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

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	//These local variables are just for bio spawning
    local int i;
    local PoisonSlugMiniBioGlob Glob;
    local rotator rot;
    local vector start;

    AmbientSound = None;
    bCanTeleport = false;
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;

	HitDamageType = DamageType; // these are replicated to other clients
    TakeHitLocation = HitLoc;
	LifeSpan = RagdollLifeSpan;

    GotoState('Dying');

	Velocity += TearOffMomentum;
    BaseEyeHeight = Default.BaseEyeHeight;
	if(PhysicsVolume.bWaterVolume)
		PlayAnim('Dead2',1.2,0.05);
	else
	{
		SetPhysics(PHYS_Falling);
		PlayAnim('Dead1',1.2,0.05);
	}

    //When killed, Slug ejects two goops of bio.
    if ( Role == ROLE_Authority )
	{
        for (i=0; i<2; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			Glob = Spawn( class 'PoisonSlugMiniBioGlob',, '', Start, rot);
		}
	}
}

defaultproperties
{
     PoisonLifespan=4
     PoisonModifier=2
     AmmunitionClass=Class'DEKMonsters208.PoisonSlugAmmo'
     ScoringValue=9
     GroundSpeed=670.000000
     WaterSpeed=650.000000
     Health=450
     DrawScale=2.000000
     CollisionRadius=96.000000
     CollisionHeight=94.000000
     Mass=500.000000
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
