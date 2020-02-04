//Code by Special Skaarj Packv4, based off of SSPSlug. Credit goes to its respectful owner.

class DEKGoldSlug extends PoisonSlug;

var config float HeatDamageMultiplier;

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int Damage )
{
	RefNormal=normal(HitLocation-Location);
	if(Frand()>0.2)
		return true;
	else
		return false;
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
// do nothing. No poison for gold slug.
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

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	if (DamageType == class'SMPDamTypeTitanRock' || DamageType == class'DamTypeTitanRock' || DamageType == class'DamTypeTechTitanRock' || DamageType == class'DamTypeIceTitan' || DamageType == class'DamTypeFruitCakeTitanRock' || DamageType == class'DamTypePumpkinTitan')
	{
		return;
		Momentum = vect(0,0,0);
	}
	else if (DamageType == class'DamTypeFireBall' || DamageType == class'DamTypeDEKSolarTurretBeam' || DamageType == class'DamTypeDEKSolarTurretHeatWave' || DamageType == class'DamTypeWildfireTrap' || DamageType == class'DamTypeFireBrute' || DamageType == class'DamTypeFireGasbag' || DamageType == class'DamTypeFireGiantGasbag' || DamageType == class'DamTypeFireKrall' || DamageType == class'DamTypeFireLord' || DamageType == class'DamTypeFireMercenary' || DamageType == class'DamTypeFireQueen' || DamageType == class'DamTypeFireSkaarjSuperHeat' || DamageType == class'DamTypeFireSkaarjTrooper' || DamageType == class'DamTypeFireSlith' || DamageType == class'DamTypeFireSlug' || DamageType == class'DamTypeFireTentacle' || DamageType == class'DamTypeFireTitan' || DamageType == class'DamTypeFireTitanSuperHeat')
	{
		Damage *= HeatDamageMultiplier;
	}
	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damagetype);
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
			Glob = Spawn( class 'DEKGoldSlugMiniBioGlob',, '', Start, rot);
		}
	}
}

defaultproperties
{
     HeatDamageMultiplier=1.150000
     AmmunitionClass=Class'DEKMonsters208.DEKGoldSlugAmmo'
     ScoringValue=14
     GibGroupClass=Class'DEKMonsters208.DEKGoldGibGroup'
     Health=1350
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.GoldMonsters.GoldMonFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster206E.GoldMonsters.GoldMonFB'
     Mass=800.000000
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
