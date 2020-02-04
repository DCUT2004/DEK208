class NecroSoulWraith extends Monster;

#exec obj load file=GeneralAmbience.uax

var() config float SuckDamage, SuckDamageMax;
var() class<DamageType> SuckDamageType;
var ColorModifier FadeOutSkin;
var vector TelepDest;
var byte AChannel;
var float LastTelepoTime;
var bool bTeleporting, SummonedMonster;
var name DeathAnim[4];
var Controller Master;

replication
{
	reliable if(Role==ROLE_Authority )
         bTeleporting,Master;
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

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	FadeOutSkin= new class'ColorModifier';
	FadeOutSkin.Material=Skins[0];
	Skins[0]=FadeOutSkin;
}

simulated function Destroyed()
{
	FadeOutSkin=none;
	super.Destroyed();
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.class == class'Monster' || P.Class == class'NecroMortalSkeleton' || P.Class == class'NecroPhantom' || P.Class == class'NecroImmortalSkeleton' || P.Class == class'NecroSoulWraith' || P.Class == class'NecroSorcerer' || P.Class == class'NecroAdrenWraith');
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
		SuckSoul(SuckDamage, vect(0,0,0));
	}
	else if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		SetAnimAction('Bow2');
		if ( MeleeDamageTarget(45, (45000.0 * Normal(Controller.Target.Location - Location))) )
			PlaySound(sound'mn_hit10', SLOT_Talk); 
	}
	else if(VSize(A.Location-Location)>7000 && (decision < 0.70))
	{
		SetAnimAction('spell');
		PlaySound(sound'BWeaponSpawn1', SLOT_Interface);
		GotoState('Teleporting');
	}
	else
	{
		SetAnimAction('spell');
		SuckSoul(SuckDamage, vect(0,0,0));
	}
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

simulated function SuckSoul(float SuckDamage, vector pushdir)
{
	local Pawn P;
	local NecroSoulParticle FX;
	local NecroSoulParticle FX2;
	local vector FX2Radius;
	local float Damage;
	local Vehicle V;
	local DEKFriendlyMonsterController FMC;

	Damage = (SuckDamage + Rand(SuckDamageMax - SuckDamage));
	
	P = Controller.Enemy;
	V = Vehicle(P);

	FX2Radius.X=P.Location.X+-5+FRand();
	FX2Radius.Y=P.Location.Y+-5+FRand();
	FX2Radius.Z=P.Location.Z+-5+FRand();
	
	if (P != None && P.Health<=0)
		return; //don't suck health from an enemy if it is already dead
	if (V != None )
		return; //don't suck souls from vehicles and turrets

	if (P != None)
		P.TakeDamage(Damage, self,vect(0, 0, 0), pushdir, SuckDamageType);
		
	FMC = DEKFriendlyMonsterController(Self.Controller);
	if (FMC != None)
		Master = FMC.Master;
	if (FMC != None && Master != None)
	{
		if (Master.Pawn != None && Master.Pawn.Health > 0)
			Master.Pawn.GiveHealth(Damage, Master.Pawn.HealthMax);
		Self.GiveHealth(Damage*2, Self.HealthMax);
		if (P != None)
			FX = Spawn(class'NecroSoulParticle',,,P.Location,Rotation);
		if (FX != None)
			FX.Seeking = Master.Pawn;
		FX2 = Spawn(class'NecroSoulParticle',,,FX2Radius,Rotation);
		if (FX2 != None)
			FX2.Seeking = self;
	}
	else
	{
		Self.GiveHealth(Damage*2, Self.HealthMax);
		FX = Spawn(class'NecroSoulParticle',,,P.Location,Rotation);
		if (FX != None)
			FX.Seeking = self;
		FX2 = Spawn(class'NecroSoulParticle',,,FX2Radius,Rotation);
		if (FX2 != None)
			FX2.Seeking = self;
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
	Spawn(class'WhiteTransEffect',Self,,Location);
	Spawn(class'WhiteTransDeres',Self,,Location);
		PlaySound(sound'BWeaponSpawn1', SLOT_Interface);
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

function PlayVictory()
{
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
	SetAnimAction('Victory1');
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');
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
     SuckDamage=15.000000
     SuckDamageMax=20.000000
     SuckDamageType=Class'DEKMonsters208.DamTypeSoulWraith'
     AChannel=255
     DeathAnim(0)="Dead"
     DeathAnim(1)="Dead2"
     DeathAnim(2)="Dead3"
     DeathAnim(3)="Dead4"
     bMeleeFighter=False
     HitSound(0)=Sound'NewDeath.MaleNightmare.mn_hit02'
     HitSound(1)=Sound'NewDeath.MaleNightmare.mn_hit03'
     HitSound(2)=Sound'NewDeath.MaleNightmare.mn_hit05'
     HitSound(3)=Sound'NewDeath.MaleNightmare.mn_hit06'
     DeathSound(0)=Sound'GeneralAmbience.tortureloop1'
     DeathSound(1)=Sound'GeneralAmbience.tortureloop1'
     ScoringValue=10
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
     HealthMax=400.000000
     Health=200
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
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.NecroMonsters.WraithNaliFinalBlend'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster206E.NecroMonsters.WraithNaliFinalBlend'
}
