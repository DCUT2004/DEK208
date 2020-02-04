class PoisonQueen extends SMPQueen config(satoreMonsterPack);

var int PoisonLifespan;
var int PoisonModifier;
var float MaxHoldTime;
var int MinProjectiles;
var int MaxProjectiles;
var float LastFireTime;
var float SpreadAngle;		// Angle between initial shots, in radians.
var bool bStuckEnemy;		// true if we have stuck an enemy on the web
var Actor StuckEnemy;
var RPGRules RPGRules;
var bool SummonedMonster;

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

simulated function PostBeginPlay()
{
	Local GameRules G;

	Super(SMPMonster).PostBeginPlay();
	if (Controller != None && MonsterController(Controller) != None)
		GroundSpeed = GroundSpeed * (1 + 0.1 * MonsterController(Controller).Skill);
	QueenFadeOutSkin= new class'ColorModifier';
	QueenFadeOutSkin.Material=Skins[0];
	Skins[0]=QueenFadeOutSkin;
	LastFireTime = Level.TimeSeconds;

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			RPGRules = RPGRules(G);
			break;
		}
	}
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.Class == class'PoisonQueen' || P.Class == class'PoisonPupae' );
}

function SpawnChildren()
{
	local NavigationPoint N;
	local PoisonPupae P;

	For ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
		if(numChildren>=MaxChildren)
			return;
		else if(vsize(N.Location-Location)<2000 && FastTrace(N.Location,Location))
		{
			P=spawn(class 'PoisonPupae' ,self,,N.Location);
			if(P!=none)
			{
				//P.LifeSpan=20+Rand(10);
				P.SummonedMonster = True;
				numChildren++;
				bStuckEnemy=false;	// we have responded
			}
		}

	}
}

function NotifyStuckEnemy(Actor A)
{
	StuckEnemy=A;
	bStuckEnemy=true;
}

function Fire( optional float F )
{
	local Actor BestTarget;
	local float bestAim, bestDist;
	local vector FireDir, X,Y,Z;

	if (bStuckEnemy)
	{
		if (StuckEnemy == None || Pawn(StuckEnemy) == None || Pawn(StuckEnemy).Health<=0)
			bStuckEnemy=false;
	}
	if (bStuckEnemy)
	{
		RangedAttack(StuckEnemy);
	}
	else
	{
		bestAim = 0.90;
		GetAxes(Controller.Rotation,X,Y,Z);
		FireDir = X;
		BestTarget = Controller.PickTarget(bestAim, bestDist, FireDir, GetFireStart(X,Y,Z), 6000); 
		RangedAttack(BestTarget);
	}
}

function RangedAttack(Actor A)
{
	local float decision;
	local int dist;
	local float timediff;

	decision = FRand();
	dist = VSize(A.Location - Location);
        timediff = Level.TimeSeconds - LastFireTime;

	if ( bShotAnim )
	{
		return;
	}
	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		bStuckEnemy = false;		// we have responded
		if (decision < 0.4)
		{
			PlaySound(Stab, SLOT_Interact);
 			SetAnimAction('Stab');
 		}
		else if (decision < 0.7)
		{
			PlaySound(Claw, SLOT_Interact);
			SetAnimAction('Claw');
		}
		else
		{
			PlaySound(Claw, SLOT_Interact);
			SetAnimAction('Gouge');
		}
		return;
	}
	else if (!Controller.bPreparingMove && Controller.InLatentExecution(Controller.LATENT_MOVETOWARD) )
	{
		SetAnimAction(MovementAnims[0]);
		bShotAnim = true;
		return;

	}
	else if ((bStuckEnemy && VSize(A.Location-Location)>(GroundSpeed*2)) || (VSize(A.Location-Location)>7000 && (decision < 0.70)))
	{
		SetAnimAction('Meditate');
		GotoState('Teleporting');
		bJustScreamed = false;
		bStuckEnemy = false;			// we have responded
		return;
	}
	else if (!bJustScreamed && ((decision < 0.15) || bStuckEnemy))
	{
		Scream();
		return;
	}
	else if ( (Shield != None) && (decision < 0.5)
		&& (((A.Location - Location) dot (Shield.Location - Location)) > 0))
	{
		Scream();
		return;
	}
	else if(((Level.TimeSeconds - LastFireTime) > MaxHoldTime) && ((decision < 0.8 && Shield != None ) || decision < 0.4))
	{
		if ( Shield != None )
			Shield.Destroy();
		row = 0;
		bJustScreamed = false;
		bStuckEnemy = false;			// starting shooting again, so clear out any outstanding stuck flag
		SetAnimAction('Shoot1');
		PlaySound(Shoot, SLOT_Interact);
		return;
	}
	else if(Shield==none && (decision < 0.9) && !bStuckEnemy)
	{
		SetAnimAction('Shield');
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		bShotAnim = true;
		return;
	}
	else if(!IsInState('Teleporting') && (decision < 0.6))
	{
		SetAnimAction('Meditate');
		GotoState('Teleporting');
		return;
	}

	// if all else fails, shoot and walk
	if ( Shield != None )
		Shield.Destroy();
	row = 0;
	bJustScreamed = false;
	SetAnimAction('Shoot1');
	PlaySound(Shoot, SLOT_Interact);
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

function SpawnShot()
{
	local vector X,Y,Z, projStart;
	local int i, NumProjectiles;
	local vector GunDir, RightDir, FireDir;
	local float SpreadAngleRad, FireAngleRad; // Radians
	local ONSRVWebProjectileLeader Leader;
	local ONSRVWebProjectile P;

	if(Controller==none)
		return;
	GetAxes(Rotation,X,Y,Z);

	if (row == 0)
		MakeNoise(1.0);

	projStart = Location + 1 * CollisionRadius * X + ( 0.7 - 0.2 * row) * CollisionHeight * Z + 0.2 * CollisionRadius * Y;

	// Defines plane in which projectiles will start travelling in.
	GunDir = vector(Controller.AdjustAim(SavedFireProperties,projStart,600));
	RightDir = normal( GunDir Cross vect(0,0,1) );

	NumProjectiles = MinProjectiles + (MaxProjectiles - MinProjectiles) * (FMin(Level.TimeSeconds - LastFireTime, MaxHoldTime) / MaxHoldTime);
	SpreadAngleRad = SpreadAngle * (Pi/180.0);

	// Spawn all the projectiles
	for(i=0; i<NumProjectiles; i++)
	{
		FireAngleRad = (-0.5 * SpreadAngleRad * (NumProjectiles - 1)) + (i * SpreadAngleRad); // So shots are centered around FireAngle of zero.
		FireDir = (Cos(FireAngleRad) * GunDir) + (Sin(FireAngleRad) * RightDir);

		if(i == 0)
		{
			Leader = spawn(class'PoisonQueenProjectileLeader', self, , projStart, rotator(FireDir));

			if(Leader != None)
			{
				Leader.Projectiles.Length = NumProjectiles;
				Leader.ProjTeam = Controller.GetTeamNum();

				Leader.Projectiles[0] = Leader;
				Leader.ProjNumber = 0;
				Leader.Leader = Leader;
			}
		}
		else
		{
			P = spawn(class'PoisonQueenProjectile', self, , projStart, rotator(FireDir));

			if(P != None && Leader != None)
			{
				Leader.Projectiles[i] = P;
				P.ProjNumber = i;
				P.Leader = Leader;
			}
		}
	}

	LastFireTime = Level.TimeSeconds;
	row++;
}

function PoisonTarget(Actor Victim)
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

function ClawDamageTarget()
{
	if(Controller==none || Controller.Target==none) 
		return;
	if (MeleeDamageTarget(ClawDamage, (50000.0 * (Normal(Controller.Target.Location - Location)))) )
	{
		PlaySound(Claw, SLOT_Interact);
		// ok, now you also get poisoned
		PoisonTarget(Controller.Target);
	}
}

function StabDamageTarget()
{
	local vector X,Y,Z;
	if(Controller==none || Controller.Target==none) 
		return;
	GetAxes(Rotation,X,Y,Z);
	if (MeleeDamageTarget(StabDamage, (15000.0 * ( Y + vect(0,0,1)))) )
	{
		PlaySound(Stab, SLOT_Interact);
		// ok, now you also get poisoned
		if (Controller != None)		// in case it has died
			PoisonTarget(Controller.Target);
	}
}

function Scream()
{
	local Actor A;
	local int EventNum;

	PlaySound(ScreamSound, SLOT_None, 3 * TransientSoundVolume);
	SetAnimAction('Scream');
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bJustScreamed = true;

	if ( ScreamEvent == '' )
		return;
	ForEach DynamicActors( class 'Actor', A, ScreamEvent )
	{
		A.Trigger(self, Instigator);
		EventNum++;
	}
	if(EventNum==0 || (bStuckEnemy && (numChildren<MaxChildren)))
		SpawnChildren();
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
     PoisonLifespan=5
     PoisonModifier=4
     MaxHoldTime=4.000000
     MinProjectiles=3
     MaxProjectiles=7
     SpreadAngle=7.000000
     ClawDamage=90
     StabDamage=110
     MonsterName="Poison Queen"
     AmmunitionClass=None
     ScoringValue=15
     GroundSpeed=700.000000
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
     Skins(0)=Texture'DEKMonstersTexturesMaster206E.GenericMonsters.PoisonQueen'
     Skins(1)=Texture'DEKMonstersTexturesMaster206E.GenericMonsters.PoisonQueen'
}
