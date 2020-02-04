class NecroPhantom extends Monster;

var vector TelepDest;
var byte AChannel;
var float LastTelepoTime, LastFireBurnTime, LastInvulTime, LastMeteorTime;
var bool bTeleporting, SummonedMonster;
var() config float FireBurnIntervalTime, MeteorIntervalTime;
var ColorModifier FadeOutSkin;
var() class<Projectile> ProjectileClass[2];
var name DeathAnim[4];
var config int GhostChance;

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

replication
{
	reliable if (Role==ROLE_Authority )
         bTeleporting;
}

simulated function PostBeginPlay()
{
	FadeOutSkin= new class'ColorModifier';
	FadeOutSkin.Material=Skins[0];
	Skins[0]=FadeOutSkin;
	Super.PostBeginPlay();
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.Class == class'NecroMortalSkeleton' || P.Class == class'NecroPhantom' || P.Class == class'NecroImmortalSkeleton' || P.Class == class'NecroSoulWraith' || P.Class == class'NecroSorcerer' || P.Class == class'NecroAdrenWraith');
}

function RangedAttack(Actor A)
{
	local float decision;
	
	Super.RangedAttack(A);

	decision = FRand();

	if ( bShotAnim )
		return;

	if ( Physics == PHYS_Swimming )
	{
		SetAnimAction('Tread');
		PhantomCurse();
	}
	else if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		SetAnimAction('Bow2');
		MeleeDamageTarget(45, (45000.0 * Normal(Controller.Target.Location - Location)));
		PlaySound(sound'mn_hit10', SLOT_Talk);
	}
	else if(VSize(A.Location-Location)>7000 && (decision < 0.70))
	{
		SetAnimAction('spell');
		GotoState('Teleporting');
	}
	else if( Level.TimeSeconds - LastFireBurnTime > FireBurnIntervalTime)
	{
		SetAnimAction('spell');
		bShotAnim = true;
		PhantomCurse();
	}
	if( Level.TimeSeconds - LastMeteorTime > MeteorIntervalTime)
	{
		SetAnimAction('spell');
		bShotAnim = true;
		PhantomMeteor();
	}
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

function PhantomCurse()
{
	local Projectile Proj;
	local Actor A;

	LastFireBurnTime = Level.TimeSeconds;

	if ( Controller != None && Controller.Target != None)
	{
		Proj = Spawn(ProjectileClass[0],self,,Controller.Target.Location);
		if(Proj != None)
		{
			PlaySound(FireSound,SLOT_Interact);
		}
		A = Instigator.spawn(class'ShockComboSparkles', Instigator,, Instigator.Location, Instigator.Rotation);
		if (A != None)
		{
			A.RemoteRole = ROLE_SimulatedProxy;
		}
	}
	if (GhostChance >= rand(99))
	{
		SetCollision(false,false,false);
		bCollideWorld = true;
		SetInvisibility(30.0);
	}
	else
	{
		SetCollision(true,true,true);
		bCollideWorld = true;
		SetInvisibility(0.0);
	}
}
function PhantomMeteor()
{
	local Projectile Proj;
	local Actor A;

	LastMeteorTime = Level.TimeSeconds;

	if ( Controller != None && Controller.Target != None)
	{
		Proj = Spawn(ProjectileClass[1],self,,Controller.Target.Location);
		if(Proj != None)
		{
			PlaySound(FireSound,SLOT_Interact);
		}
		A = Instigator.spawn(class'NecroPhantomMeteorCastFX', Instigator,, Instigator.Location, Instigator.Rotation);
		if (A != None)
		{
			A.RemoteRole = ROLE_SimulatedProxy;
		}
	}
}

function Teleport()
{
		local rotator EnemyRot;

		if ( Role == ROLE_Authority )
			ChooseDestination();
		SetLocation(TelepDest+vect(0,0,1)*CollisionHeight/2);
		AChannel=0;
		if(Controller.Enemy!=none)
			EnemyRot = rotator(Controller.Enemy.Location - Location);
		EnemyRot.Pitch = 0;
		setRotation(EnemyRot);
		Spawn(class'CosmicTransEffect',Self,,Location);
		Spawn(class'CosmicTransDeres',Self,,Location);
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
	if(bTeleporting)
	{
		AChannel-=300 *DeltaTime;
	}
	else
		AChannel=255;
	FadeOutSkin.Color.A=AChannel;

	if(MonsterController(Controller)!=none && Controller.Enemy==none)
	{
		if(MonsterController(Controller).FindNewEnemy())
		{
			SetAnimAction('Levitate');
			GotoState('Teleporting');
	    }
	}
	super.Tick(DeltaTime);
}

state Teleporting
{
	function Tick(float DeltaTime)
	{
		if(AChannel<20)
		{
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
		Acceleration = Vect(0,0,0);
		bUnlit = true;
		AChannel=255;
		PlaySound(sound'BWeaponSpawn1', SLOT_Interface);
	}

	function EndState()
	{
        bTeleporting=false;
		bUnlit = false;
		AChannel=255;

		LastTelepoTime=Level.TimeSeconds;
	}
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	AmbientSound = None;
    bCanTeleport = false; 
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;
		
	HitDamageType = DamageType;
    TakeHitLocation = HitLoc;
	LifeSpan = RagdollLifeSpan;

    GotoState('Dying');
		
	Velocity += TearOffMomentum;
    BaseEyeHeight = Default.BaseEyeHeight;
    SetPhysics(PHYS_Falling);
    
    if ( (DamageType == class'DamTypeSniperHeadShot')
		|| ((HitLoc.Z > Location.Z + 0.75 * CollisionHeight) && (FRand() > 0.5) 
			&& (DamageType != class'DamTypeAssaultBullet') && (DamageType != class'DamTypeMinigunBullet') && (DamageType != class'DamTypeFlakChunk')) )
    {
		PlayAnim('Dead3',1,0.05);
		CreateGib('head',DamageType,Rotation);
		return;
	}
	else
		PlayAnim(DeathAnim[Rand(4)],1.2,0.05);		
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

simulated function Destroyed()
{
	FadeOutSkin=none;
	super.Destroyed();
}

function PlayVictory()
{
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
	SetAnimAction('Victory1');
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');
}

defaultproperties
{
     AChannel=255
     FireBurnIntervalTime=1.000000
     MeteorIntervalTime=10.000000
     ProjectileClass(0)=Class'DEKMonsters208.NecroPhantomProjectile'
     ProjectileClass(1)=Class'DEKMonsters208.NecroPhantomMeteor'
     DeathAnim(0)="Dead"
     DeathAnim(1)="Dead2"
     DeathAnim(2)="Dead3"
     DeathAnim(3)="Dead4"
     GhostChance=33
     bMeleeFighter=False
     HitSound(0)=Sound'NewDeath.MaleNightmare.mn_hit02'
     HitSound(1)=Sound'NewDeath.MaleNightmare.mn_hit03'
     HitSound(2)=Sound'NewDeath.MaleNightmare.mn_hit05'
     HitSound(3)=Sound'NewDeath.MaleNightmare.mn_hit06'
     DeathSound(0)=Sound'NewDeath.MaleNightmare.mn_death01'
     DeathSound(1)=Sound'NewDeath.MaleNightmare.mn_death07'
     ScoringValue=12
     InvisMaterial=FinalBlend'DEKMonstersTexturesMaster206E.NecroMonsters.PhantomNaliFinalBlend'
     GibGroupClass=Class'XEffects.xAlienGibGroup'
     WallDodgeAnims(0)="levitate"
     WallDodgeAnims(1)="levitate"
     WallDodgeAnims(2)="levitate"
     WallDodgeAnims(3)="levitate"
     IdleHeavyAnim="Breath"
     IdleRifleAnim="Breath"
     FireHeavyRapidAnim="spell"
     FireHeavyBurstAnim="spell"
     FireRifleRapidAnim="spell"
     FireRifleBurstAnim="spell"
     MeleeRange=60.000000
     Health=250
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
     MovementAnims(0)="levitate"
     MovementAnims(1)="levitate"
     MovementAnims(2)="levitate"
     MovementAnims(3)="levitate"
     SwimAnims(0)="Swim"
     SwimAnims(1)="Swim"
     SwimAnims(2)="Swim"
     SwimAnims(3)="Swim"
     CrouchAnims(0)="Cringe"
     CrouchAnims(1)="Cringe"
     CrouchAnims(2)="Cringe"
     CrouchAnims(3)="Cringe"
     WalkAnims(0)="Walk"
     WalkAnims(1)="Walk"
     WalkAnims(2)="Walk"
     WalkAnims(3)="Walk"
     AirAnims(0)="levitate"
     AirAnims(1)="levitate"
     AirAnims(2)="levitate"
     AirAnims(3)="levitate"
     TakeoffAnims(0)="levitate"
     TakeoffAnims(1)="levitate"
     TakeoffAnims(2)="levitate"
     TakeoffAnims(3)="levitate"
     LandAnims(0)="Landed"
     LandAnims(1)="Landed"
     LandAnims(2)="Landed"
     LandAnims(3)="Landed"
     DoubleJumpAnims(0)="levitate"
     DoubleJumpAnims(1)="levitate"
     DoubleJumpAnims(2)="levitate"
     DoubleJumpAnims(3)="levitate"
     DodgeAnims(0)="levitate"
     DodgeAnims(1)="levitate"
     DodgeAnims(2)="levitate"
     DodgeAnims(3)="levitate"
     AirStillAnim="levitate"
     TakeoffStillAnim="levitate"
     CrouchTurnRightAnim="Cringe"
     CrouchTurnLeftAnim="Cringe"
     IdleCrouchAnim="Cringe"
     IdleSwimAnim="Tread"
     IdleWeaponAnim="Breath"
     IdleRestAnim="Breath"
     IdleChatAnim="Breath"
     Mesh=VertMesh'satoreMonsterPackv120.Nali2'
     Skins(0)=Texture'DEKMonstersTexturesMaster206E.NecroMonsters.PhantomNali'
     Skins(1)=Texture'DEKMonstersTexturesMaster206E.NecroMonsters.PhantomNali'
     TransientSoundRadius=800.000000
}
