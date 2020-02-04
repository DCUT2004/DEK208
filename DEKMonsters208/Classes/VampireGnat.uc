class VampireGnat extends RazorFly
	config(DEKMonstersTexturesMaster206E);

// increases in size as it sucks blood
// starts half size of normal razorfly. Max size increase fivefold
// at more than 5 fold size, with split into 2 VampireGnats.

var config int MaxSplits;		// maximum number of descendants that can be spawned
var config int SplitHealthLoss;		// health lost during the splitting process
var config float VampirePercent;	// percentage of damage done that gets used by the gnat for growing

var config float DamagePercent, RandomDamagePercent;
var config int MinDamage, MaxDamage;
var config float MaxGrowth;

var int NumKills;
var bool SummonedMonster;		// flag to say if this is a gnat we created. If so, special rules for killing.

function PostNetBeginPlay()
{
	Instigator = self;
	CheckController();
	Super.PostNetBeginPlay();
}

function CheckController()
{
	if (Instigator.ControllerClass == class'DEKFriendlyMonsterController')
		SummonedMonster = true;
	else
		SummonedMonster = false;
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.class == class'VampireGnat' );
}

function SplitGnat()
{
	// this gnat is now too big. Split into two.
	Local int GnatHealth;
	Local VampireGnat G;
	local vector X,Y,Z;
	local int NewMaxSplits;

	if (MaxSplits <= 0)
		return;		//cannot split, have done so already as many times as we can.

	GnatHealth = (Health-SplitHealthLoss)/2;
	if (GnatHealth <=0)
		GnatHealth = default.Health;

	GetAxes(Rotation,X,Y,Z);
	G = spawn(class 'VampireGnat',,,Location + (3 * CollisionHeight * Z));
	if (G == None)	// failed to spawn
		G = spawn(class 'VampireGnat',,,Location - (3 * CollisionHeight * Z));
	if ( G != None )
	{
		NewMaxSplits = MaxSplits-1;		// take off one split

		// set up new gnat
		G.MaxSplits = int(NewMaxSplits/2.0);	
		G.Health = GnatHealth;
		G.DamagePercent = default.DamagePercent;
		G.NumKills = NumKills;
		G.SummonedMonster=True;

		// and adjust our settings
		Health = GnatHealth;
		MaxSplits = NewMaxSplits - G.MaxSplits;
		DamagePercent = default.DamagePercent;

		// now make sure everything consistent
		G.SizeGnat();		// set size of newly spawned gnat
		SizeGnat();		// and set our size.
	}
}

function SizeGnat()
{
	Local float GrowthFactor;

	// time to grow again
	GrowthFactor = Health/float(default.Health);
	DamagePercent = default.DamagePercent * GrowthFactor;
	MinDamage = default.MinDamage + int(5.0 * (GrowthFactor-1));
	MaxDamage = default.MaxDamage + int(30.0 * (GrowthFactor-1));
	RandomDamagePercent = default.RandomDamagePercent * GrowthFactor;
	MeleeRange = default.MeleeRange + (20.0 * (GrowthFactor-1));
	AirSpeed = default.AirSpeed + (250.0 * (GrowthFactor-1));
	AccelRate = default.AccelRate + (100.0 * (GrowthFactor-1));   
	SetDrawScale(default.DrawScale * GrowthFactor);
	SetCollisionSize(default.CollisionRadius * GrowthFactor,default.CollisionHeight * GrowthFactor);

	if (GrowthFactor > MaxGrowth)
		SplitGnat();
}

function CheckGrowGnat(int HealthTaken)
{
	local float CurGrowthFactor;

	// ok, just got some extra health. Can we use it?
	if (((Health/default.Health) > MaxGrowth) && (MaxSplits<=0))
		return; // we are already too big, and cannot split again. So do not absorb the health

	Health += HealthTaken;
	CurGrowthFactor = RandomDamagePercent/default.RandomDamagePercent;
	if (Health > (default.Health * CurGrowthFactor))
		SizeGnat();
}

function bool GnatMeleeDamageTarget(Pawn TheTarget, int hitdamage, vector pushdir)
{
	local vector HitLocation, HitNormal;
	local actor HitActor;
	
	// check if still in melee range
	If ( (TheTarget != None) && (VSize(TheTarget.Location - Location) <= MeleeRange * 1.4 + TheTarget.CollisionRadius + CollisionRadius)
		&& ((Physics == PHYS_Flying) || (Physics == PHYS_Swimming) || (Abs(Location.Z - TheTarget.Location.Z) 
			<= FMax(CollisionHeight, TheTarget.CollisionHeight) + 0.5 * FMin(CollisionHeight, TheTarget.CollisionHeight))) )
	{	
		HitActor = Trace(HitLocation, HitNormal, TheTarget.Location, Location, false);
		if ( HitActor != None )
			return false;
		TheTarget.TakeDamage(hitdamage, self, HitLocation, pushdir, class'MeleeDamage');
		return true;
	}
	return false;
}

function RangedAttack(Actor A)
{
	Local int StartHealth, EndHealth, HealthTaken;
	Local Pawn TheTarget;
	Local float DamagetoTake;
	local vehicle V;

	if (A == None)
		return;

	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		bShotAnim = true;
		PlayAnim('Shoot1');

		TheTarget = Pawn(A);
		If (TheTarget != None)
		{
			V = Vehicle(TheTarget);
			if (V != None)
			{
				if (V.bRemoteControlled || !V.bDrawDriverInTP || (V.Driver == None))
				{
					// cannot access the driver. Just do minimum damage to vehicle
					GnatMeleeDamageTarget(V, MinDamage, (15000.0 * Normal(A.Location - Location)));
					TheTarget = None;
				}
				else
				{
					// get the driver instead
					TheTarget = V.Driver;
				}
			}
		}
		If (TheTarget != None)
		{
			StartHealth = TheTarget.Health;
			DamagetoTake = int((StartHealth * (DamagePercent + (5*NumKills) + ((FRand() * 2.0 * RandomDamagePercent) - RandomDamagePercent)))/100.0);
			DamagetoTake = Max(MinDamage,Min(MaxDamage,DamagetoTake));
			if ( GnatMeleeDamageTarget(TheTarget, DamagetoTake, (15000.0 * Normal(A.Location - Location))) )
			{
				PlaySound(sound'injur1rf', SLOT_Talk);
				If (Controller != None && Controller.Target != None)
					EndHealth = TheTarget.Health;
				If (EndHealth <= 0)
				{
					EndHealth = 0;
					// its a kill. 
					NumKills += 1;
				}
				If (EndHealth > StartHealth)
					EndHealth = StartHealth;
				HealthTaken = StartHealth - EndHealth;
				HealthTaken = (HealthTaken * VampirePercent)/100.0;

				CheckGrowGnat(HealthTaken);
			}
		}

		if (Controller != None && A != None)
		{
			Controller.Destination = Location + 110 * (Normal(Location - A.Location) + VRand());
			Controller.Destination.Z = Location.Z + 70;
			Velocity = AirSpeed * normal(Controller.Destination - Location);
			Controller.GotoState('TacticalMove', 'DoMove');
		}
	}
	If (Vehicle(A) != None &&
		(Vehicle(A).bRemoteControlled || !Vehicle(A).bDrawDriverInTP || (Vehicle(A).Driver == None)))
	{
		// gnat currently attacking something metal. It doesn't like that
		if (Controller != None && VampireGnatController(Controller) != None)
			VampireGnatController(Controller).FindNewEnemy();
	}

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
     MaxSplits=3
     SplitHealthLoss=20
     VampirePercent=100.000000
     DamagePercent=12.500000
     RandomDamagePercent=2.000000
     MinDamage=10
     MaxDamage=50
     MaxGrowth=5.000000
     ScoringValue=3
     AirSpeed=600.000000
     AccelRate=1300.000000
     HealthMax=200.000000
     Health=40
     ControllerClass=Class'DEKMonsters208.VampireGnatController'
     DrawScale=0.500000
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.GenericMonsters.VGnatFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster206E.GenericMonsters.VGnatFB'
     CollisionRadius=9.000000
     CollisionHeight=5.500000
}
