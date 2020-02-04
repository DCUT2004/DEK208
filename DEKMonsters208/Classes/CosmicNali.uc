class CosmicNali extends SMPMonster config(satoreMonsterPack);

var config float CosmicNaliDeathDamage, CosmicNaliDeathRadius, CosmicShotIntervalTime;
var bool SummonedMonster, bTeleporting;
var float LastTelepoTime, LastCosmicShotTime;
var vector TelepDest;
var	byte AChannel;
var ColorModifier FadeOutSkin;
var name DeathAnim[4];

function PostNetBeginPlay()
{
	Instigator = self;
	Super.PostNetBeginPlay();
	CheckController();
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	FadeOutSkin= new class'ColorModifier';
	FadeOutSkin.Material=Skins[0];
	Skins[0]=FadeOutSkin;
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
	FadeOutSkin=none;
	super.Destroyed();
}

replication
{		
	reliable if(Role==ROLE_Authority )
         bTeleporting;
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.class == class'Monster' || P.Class == class'CosmicNali' || P.Class == class'CosmicBrute' || P.Class == class'CosmicKrall' || P.Class == class'CosmicSkaarj' || P.Class == class'CosmicWarlord' || P.Class == class'CosmicTitan' );
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
		CosmicShot();
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
	else if( Level.TimeSeconds - LastCosmicShotTime > CosmicShotIntervalTime)
	{
		SetAnimAction('spell');
		bShotAnim = true;
		CosmicShot();
	}
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

function CosmicShot()
{	
	local vector FireStart,X,Y,Z;
	
	if ( Controller != None )
	{
		GetAxes(Rotation,X,Y,Z);
		FireStart = GetFireStart(X,Y,Z);
		if ( !SavedFireProperties.bInitialized )
		{
			SavedFireProperties.AmmoClass = MyAmmo.Class;
			SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
			SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
			SavedFireProperties.MaxRange = MyAmmo.MaxRange;
			SavedFireProperties.bTossed = MyAmmo.bTossed;
			SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
			SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
			SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
			SavedFireProperties.bInitialized = true;
		}

		Spawn(MyAmmo.ProjectileClass,,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,600));
		PlaySound(FireSound,SLOT_Interact);
	}
	CosmicShotTwo();
}

function CosmicShotTwo()
{	
	local vector FireStart,X,Y,Z;
	
	if ( Controller != None )
	{
		GetAxes(Rotation,X,Y,Z);
		FireStart = GetFireStart(X,Y,Z);
		if ( !SavedFireProperties.bInitialized )
		{
			SavedFireProperties.AmmoClass = MyAmmo.Class;
			SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
			SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
			SavedFireProperties.MaxRange = MyAmmo.MaxRange;
			SavedFireProperties.bTossed = MyAmmo.bTossed;
			SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
			SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
			SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
			SavedFireProperties.bInitialized = true;
		}

		Spawn(MyAmmo.ProjectileClass,,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,600));
		PlaySound(FireSound,SLOT_Interact);
	}
	CosmicShotThree();
}

function CosmicShotThree()
{	
	local vector FireStart,X,Y,Z;
	
	if ( Controller != None )
	{
		GetAxes(Rotation,X,Y,Z);
		FireStart = GetFireStart(X,Y,Z);
		if ( !SavedFireProperties.bInitialized )
		{
			SavedFireProperties.AmmoClass = MyAmmo.Class;
			SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
			SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
			SavedFireProperties.MaxRange = MyAmmo.MaxRange;
			SavedFireProperties.bTossed = MyAmmo.bTossed;
			SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
			SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
			SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
			SavedFireProperties.bInitialized = true;
		}

		Spawn(MyAmmo.ProjectileClass,,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,600));
		PlaySound(FireSound,SLOT_Interact);
	}
	Teleport();
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

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	
	if (DamageType == class'DamTypeLightningRod' || DamageType == class'DamTypeEnhLightningRod' || DamageType == class'DamTypeLightningBolt' || DamageType == class'DamTypeLightningSent' || DamageType == class'DamTypeMachinegunSentinel' || DamageType == class'DamTypeCosmicNali' || DamageType == class'DamTypeSniperSentinel' || DamageType == class'DamTypeBeamSentinel')
	{
		return; //no cheap shots.
	}
	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damagetype);
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	Spawn(class'ShockComboFlash');
	HurtRadius(CosmicNaliDeathDamage, CosmicNaliDeathRadius, class'DamTypeCosmicNaliCombo', 100000, Location);
	super.PlayDying(DamageType,HitLoc);
	bHidden = true;
}

function bool IsHeadShot(vector loc, vector ray, float AdditionalScale)
{
	return super(xPawn).IsHeadShot(loc,ray,AdditionalScale);
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
     CosmicNaliDeathDamage=150.000000
     CosmicNaliDeathRadius=425.000000
     CosmicShotIntervalTime=1.500000
     AChannel=255
     DeathAnim(0)="Dead"
     DeathAnim(1)="Dead2"
     DeathAnim(2)="Dead3"
     DeathAnim(3)="Dead4"
     bMeleeFighter=False
     HitSound(0)=Sound'satoreMonsterPackv120.Nali.injur1n'
     HitSound(1)=Sound'satoreMonsterPackv120.Nali.injur2n'
     HitSound(2)=Sound'satoreMonsterPackv120.Nali.injur1n'
     HitSound(3)=Sound'satoreMonsterPackv120.Nali.injur2n'
     DeathSound(0)=Sound'satoreMonsterPackv120.Nali.death1n'
     DeathSound(1)=Sound'satoreMonsterPackv120.Nali.death2n'
     AmmunitionClass=Class'DEKMonsters208.CosmicNaliAmmo'
     ScoringValue=10
     GibGroupClass=Class'DEKMonsters208.CosmicGibGroup'
     SoundFootsteps(0)=Sound'satoreMonsterPackv120.Nali.walkC'
     SoundFootsteps(1)=Sound'satoreMonsterPackv120.Nali.walkC'
     SoundFootsteps(2)=Sound'satoreMonsterPackv120.Nali.walkC'
     SoundFootsteps(3)=Sound'satoreMonsterPackv120.Nali.walkC'
     SoundFootsteps(4)=Sound'satoreMonsterPackv120.Nali.walkC'
     SoundFootsteps(5)=Sound'satoreMonsterPackv120.Nali.walkC'
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
     RagdollOverride="Male2"
     bCanFly=True
     MeleeRange=60.000000
     AirSpeed=1000.000000
     AccelRate=1700.000000
     Health=15
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
     Skins(0)=Shader'DEKMonstersTexturesMaster206E.CosmicMonsters.CosmicSkaarj'
     Skins(1)=Shader'DEKMonstersTexturesMaster206E.CosmicMonsters.CosmicSkaarj'
}
