//=============================================================================
// DEKGhost. 2x HP, 1.1x Speed, 1.25x Score, 0.5x Mass
//=============================================================================

class DEKGhostQueen extends SMPMonster config(satoreMonsterPack);
var() name ScreamEvent;
var bool SummonedMonster, bJustScreamed, bTeleporting;
var vector TelepDest;
var byte row;
var SMPQueenShield Shield;
var() int ClawDamage, StabDamage, numChildren;
var byte AChannel;
var() sound Acquire,Fear,Roam,footstepSound,ScreamSound,stab,shoot,claw,Threaten;
var float LastTelepoTime;
var() config int MaxChildren, GhostChance;

replication
{
	reliable if(Role==ROLE_Authority )
         bTeleporting;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	GroundSpeed = GroundSpeed * (1 + 0.1 * MonsterController(Controller).Skill);
}

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


simulated function Destroyed()
{
    if(Shield!=none)
    	Shield.Destroy();
	super.Destroyed();
}
function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.class == class'DEKGhostQueen' ||  P.class == class'DEKGhostSkaarjPupae' ||  P.class == class'DEKGhostChildPupae');
}


function SpawnShield()
{
//	log("SpawnShield");
	//New Shield
	if(Shield!=none)
		Shield.Destroy();

	Shield = Spawn(class'SMPQueenShield',,,Location);
	if(Shield!=none)
	{
		Shield.SetDrawScale(Shield.DrawScale*(drawscale/default.DrawScale));
	    Shield.AimedOffset.X=CollisionRadius;
		Shield.AimedOffset.Y=CollisionRadius;
		Shield.SetCollisionSize(CollisionRadius*1.2,CollisionHeight*1.2);
	}
//	Shield.SetBase(self);

}

simulated function FootStep()
{
//	bEndFootstep = false;
//	PlaySound(FootstepSound, SLOT_Interact, 8);
	PlaySound(FootstepSound, SLOT_Interact, 8);
}
simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	AmbientSound = None;
    bCanTeleport = false;
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;

	HitDamageType = DamageType; // these are replicated to other clients
    TakeHitLocation = HitLoc;
	LifeSpan = RagdollLifeSpan;
    if(Shield!=none)
    	Shield.Destroy();
    GotoState('Dying');

	Velocity += TearOffMomentum;
    BaseEyeHeight = Default.BaseEyeHeight;
    SetPhysics(PHYS_Falling);


	PlayAnim('OutCold',0.7, 0.1);
}
function RangedAttack(Actor A)
{
	local float decision;
//	log("Queen RangedAttack");
	if ( bShotAnim )
		return;
	decision = FRand();
	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
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

	}
	else if (!Controller.bPreparingMove && Controller.InLatentExecution(Controller.LATENT_MOVETOWARD) )
	{
		SetAnimAction(MovementAnims[0]);
		bShotAnim = true;
		return;

	}
	else if(VSize(A.Location-Location)>7000 && (decision < 0.70))
	{
		SetAnimAction('Meditate');
		GotoState('Teleporting');
		bJustScreamed = false;
	}
	else if (!bJustScreamed && (decision < 0.15) )
		Scream();
	else if ( (Shield != None) && (decision < 0.5)
		&& (((A.Location - Location) dot (Shield.Location - Location)) > 0) )
		Scream();
	else if((decision < 0.8 && Shield != None ) || decision < 0.4)
	{
		if ( Shield != None )
			Shield.Destroy();
		row = 0;
		bJustScreamed = false;
		SetAnimAction('Shoot1');
		PlaySound(Shoot, SLOT_Interact);
	}
	else if(Shield==none && (decision < 0.9))
	{
		SetAnimAction('Shield');
	}
	else if(!IsInState('Teleporting') && (decision < 0.6))
	{
		SetAnimAction('Meditate');
		GotoState('Teleporting');
	}
	else
	{
		if ( Shield != None )
			Shield.Destroy();
		row = 0;
		bJustScreamed = false;
		SetAnimAction('Shoot1');
		PlaySound(Shoot, SLOT_Interact);
//		log("Queen :ShootSound");
	}
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}
function ThrowOther(Pawn Other,int Power)
{
	local float dist, shake;
	local vector Momentum;


	if ( Other.mass >= Mass )
		return;

	if (xPawn(Other)==none)
	{
		if ( Power<400 || (Other.Physics != PHYS_Walking) )
			return;
		dist = VSize(Location - Other.Location);
		if (dist > Mass)
			return;
	}
	else
	{

		dist = VSize(Location - Other.Location);
		shake = 0.4*FMax(500, Mass - dist);
		shake=FMin(2000,shake);
		if ( dist > Mass )
			return;
		if(Other.Controller!=none)
			Other.Controller.ShakeView( vect(0.0,0.02,0.0)*shake, vect(0,1000,0),0.003*shake, vect(0.02,0.02,0.02)*shake, vect(1000,1000,1000),0.003*shake);

		if ( Other.Physics != PHYS_Walking )
			return;
	}

	Momentum = 100 * Vrand();
	Momentum.Z = FClamp(0,Power,Power - ( 0.4 * dist + Max(10,Other.Mass)*10));
	Other.AddVelocity(Momentum);
}

function Landed(vector HitNormal)
{
	local pawn Thrown;
	if(Velocity.Z<-10)
		foreach CollidingActors( class 'Pawn', Thrown,Mass)
			ThrowOther(Thrown,Mass/12+(-0.5*Velocity.Z));
	super.Landed(HitNormal);
}
function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
    if(Damage>80)
    {
		PlayDirectionalHit(HitLocation);

	}

    if( Level.TimeSeconds - LastPainSound < MinTimeBetweenPainSounds )
        return;

    LastPainSound = Level.TimeSeconds;
    PlaySound(HitSound[Rand(4)], SLOT_Pain,2*TransientSoundVolume,,400);
}
function PlayDirectionalHit(Vector HitLoc)
{
	TweenAnim('TakeHit', 0.05);
}
function Scream()
{
	local Actor A;
	local int EventNum;


//	PlaySound(ScreamSound, SLOT_Talk, 2 * TransientSoundVolume);
//	PlaySound(ScreamSound, SLOT_None, 2 * TransientSoundVolume);
//	PlaySound(ScreamSound, SLOT_None, 2 * TransientSoundVolume);
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
	if(EventNum==0)
		SpawnChildren();
}
function SpawnChildren()
{
	local NavigationPoint N;
	local DEKGhostChildPupae P;

	For ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
		if(numChildren>=MaxChildren)
			return;
		else if(vsize(N.Location-Location)<2000 && FastTrace(N.Location,Location))
		{
			P=spawn(class 'DEKGhostChildPupae' ,self,,N.Location);
		    if(P!=none)
		    {
		    	P.LifeSpan=20+Rand(10);
				numChildren++;
			}
		}

	}

}

function SpawnShot()
{
	if (GhostChance > rand(99))
	{
		SetCollision(False,False,False);
		bCollideWorld = True;
		SetInvisibility(60.0);
	}
	else
	{
		SetCollision(True,True,True);
		bCollideWorld = True;
		SetInvisibility(0.0);
	}
	Super(SMPQueen).SpawnShot();
}

function PlayVictory()
{
	if(Controller!=none)
	{
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		bShotAnim = true;
	    PlaySound(Threaten,SLOT_Interact);
		SetAnimAction('ThreeHit');
		Controller.Destination = Location;
		Controller.GotoState('TacticalMove','WaitForAnim');
	}
}

function ClawDamageTarget()
{
	if(Controller==none || Controller.Target==none) return;
	if (MeleeDamageTarget(ClawDamage, (50000.0 * (Normal(Controller.Target.Location - Location)))) )
		PlaySound(Claw, SLOT_Interact);
}

function StabDamageTarget()
{
	local vector X,Y,Z;
	if(Controller==none || Controller.Target==none) return;
	GetAxes(Rotation,X,Y,Z);
	if (MeleeDamageTarget(StabDamage, (15000.0 * ( Y + vect(0,0,1)))) )
		PlaySound(Stab, SLOT_Interact);
}

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int Damage )
{
	local Vector HitDir;
	local Vector FaceDir;
	FaceDir=vector(Rotation);
	HitDir = Normal(Location-HitLocation+ Vect(0,0,8));
	RefNormal=FaceDir;
	if ( FaceDir dot HitDir < -0.26 && Shield!=none) // 68 degree protection arc
	{
		Shield.Flash(Damage);

		return true;
	}
	return false;
}
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
					vector momentum, class<DamageType> damageType)
{
   	local vector HitNormal;
	if(CheckReflect(HitLocation,HitNormal,Damage))
		Damage*=0;
	super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
}
function Teleport()
{
		local rotator EnemyRot;

		if ( Role == ROLE_Authority )
			ChooseDestination();
		SetLocation(TelepDest+vect(0,0,1)*CollisionHeight/2);
		if(Controller.Enemy!=none)
			EnemyRot = rotator(Controller.Enemy.Location - Location);
		EnemyRot.Pitch = 0;
		setRotation(EnemyRot);
		PlaySound(sound'Teleport1', SLOT_Interface);

}
function ChooseDestination()
{
	local NavigationPoint N;
	local vector ViewPoint, Best;
	local float rating, newrating;
	local Actor jActor;
	Best = Location;
	TelepDest = Location;
	rating = 0;
	if(Controller.Enemy==none)
		return;
	for ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
			newrating = 0;

			ViewPoint = N.Location +vect(0,0,1)*CollisionHeight/2;
			if (FastTrace( Controller.Enemy.Location,ViewPoint))
				newrating += 20000;
			newrating -= VSize(N.Location - Controller.Enemy.Location) + 1000 * FRand();
	//		if ( N.Location.Z > Controller.Enemy.Location.Z )
	//			newrating += 1000;
			foreach N.VisibleCollidingActors(class'Actor',jActor,CollisionRadius,ViewPoint)
				newrating -= 30000;
			if ( newrating > rating )
			{
				rating = newrating;
				Best = N.Location;
			}
   	}
	TelepDest = Best;
}
simulated function Tick(float DeltaTime)
{
	if(MonsterController(Controller)!=none && Controller.Enemy==none)
	{
		if(MonsterController(Controller).FindNewEnemy())
		{
			SetAnimAction('Meditate');
			GotoState('Teleporting');
			bJustScreamed = false;
	    }
	}


	super.Tick(DeltaTime);
}


state Teleporting
{
	function Tick(float DeltaTime)
	{
//		local int i;
		if(AChannel<20)
		{
			//PlayTeleportEffect(true,true);
            if (ROLE == ROLE_Authority)
				Teleport();
			GotoState('');
		}
		global.Tick(DeltaTime);
	}


	function RangedAttack(Actor A)
	{
		return;
	}
	function BeginState()
	{
		if(Controller.Enemy==none)
		{
			GotoState('');
			return;
		}
		bTeleporting=true;
//		log("Queen Teleporting");
		Acceleration = Vect(0,0,0);
//		SetFadeOutTexture();
		bUnlit = true;
		AChannel=255;
		Spawn(class'SMPQueenTeleportEffect',,,Location);
//		Spawn(class'SMPQueenTeleportLight');
	}

	function EndState()
	{
//		local int i;
        bTeleporting=false;
//		SetRealTexture();
		bUnlit = false;
		AChannel=255;
///		for ( i=0; i<Skins.Length; i++ )
//		if(ColorModifier(Skins[i])!=none)
//			ColorModifier(Skins[i]).Color.A=AChannel;

		LastTelepoTime=Level.TimeSeconds;
	}
}

state Dying
{
ignores AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;
simulated function ProcessHitFX(){}
}

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
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
     ScreamEvent="QScream"
     ClawDamage=70
     StabDamage=90
     AChannel=255
     Acquire=Sound'satoreMonsterPackSound.Queen.yell1Q'
     Fear=Sound'satoreMonsterPackSound.Queen.yell2Q'
     Roam=Sound'satoreMonsterPackSound.Queen.nearby2Q'
     footstepSound=Sound'satoreMonsterPackSound.Titan.step1t'
     ScreamSound=Sound'satoreMonsterPackSound.Queen.yell3Q'
     Stab=Sound'satoreMonsterPackSound.Queen.stab1Q'
     Shoot=Sound'satoreMonsterPackSound.Queen.shoot1Q'
     Claw=Sound'satoreMonsterPackSound.Queen.claw1Q'
     Threaten=Sound'satoreMonsterPackSound.Queen.yell2Q'
     MaxChildren=3
     GhostChance=60
     InvalidityMomentumSize=100000.000000
     MonsterName="Queen"
     bNoTeleFrag=True
     bBoss=True
     HitSound(0)=Sound'satoreMonsterPackSound.Queen.yell2Q'
     HitSound(1)=Sound'satoreMonsterPackSound.Queen.yell2Q'
     HitSound(2)=Sound'satoreMonsterPackSound.Queen.yell2Q'
     HitSound(3)=Sound'satoreMonsterPackSound.Queen.yell2Q'
     DeathSound(0)=Sound'satoreMonsterPackSound.Queen.outcoldQ'
     DeathSound(1)=Sound'satoreMonsterPackSound.Queen.outcoldQ'
     DeathSound(2)=Sound'satoreMonsterPackSound.Queen.outcoldQ'
     DeathSound(3)=Sound'satoreMonsterPackSound.Queen.outcoldQ'
     AmmunitionClass=Class'satoreMonsterPackv120.SMPQueenAmmo'
     ScoringValue=23
     InvisMaterial=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.InvshadeFB'
     GibGroupClass=Class'DEKMonsters208.DEKGhostGibGroup'
     bCanSwim=False
     bCanFly=True
     MeleeRange=120.000000
     GroundSpeed=600.000000
     AirSpeed=100.000000
     AccelRate=1600.000000
     JumpZ=800.000000
     Health=2000
     MovementAnims(0)="Run"
     MovementAnims(1)="Run"
     MovementAnims(2)="Run"
     MovementAnims(3)="Run"
     TurnLeftAnim="Walk"
     TurnRightAnim="Walk"
     WalkAnims(0)="Walk"
     WalkAnims(1)="Walk"
     WalkAnims(2)="Walk"
     WalkAnims(3)="Walk"
     IdleWeaponAnim="Meditate"
     IdleRestAnim="Meditate"
     AmbientSound=Sound'satoreMonsterPackSound.Queen.amb1Q'
     Mesh=VertMesh'satoreMonsterPackMeshes.SkQueen'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.shadeFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.shadeFB'
     TransientSoundVolume=16.000000
     CollisionRadius=90.000000
     CollisionHeight=106.000000
     Mass=1000.000000
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
