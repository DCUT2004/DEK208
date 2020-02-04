class NecroGhostExp extends Monster
	config(satoreMonsterPack);

var() config float MinXPDamage, MaxXPDamage;
var ColorModifier FadeOutSkin;
var vector TelepDest;
var		byte AChannel;
var float LastTelepoTime;
var bool bTeleporting;
var RPGRules Rules;
var config int MinimumLevel, MinimumExp;
var config float TargetRadius;
var xEmitter Chain;
var Pawn Enemy;

#exec  AUDIO IMPORT NAME="NecroGhostDeathSound1" FILE="C:\UT2004\Sounds\NecroGhostDeathSound1.WAV" GROUP="MonsterSounds"
#exec  AUDIO IMPORT NAME="NecroGhostDeathSound2" FILE="C:\UT2004\Sounds\NecroGhostDeathSound2.WAV" GROUP="MonsterSounds"
#exec  AUDIO IMPORT NAME="NecroGhostDeathSound3" FILE="C:\UT2004\Sounds\NecroGhostDeathSound3.WAV" GROUP="MonsterSounds"

replication
{
	reliable if(Role==ROLE_Authority )
         bTeleporting;
}

function PostNetBeginPlay()
{
	Instigator = self;
	Super.PostNetBeginPlay();
}

simulated function PostBeginPlay()
{
	local MagicShieldInv Inv;
	
	Super.PostBeginPlay();
	FadeOutSkin= new class'ColorModifier';
	FadeOutSkin.Material=Skins[0];
	Skins[0]=FadeOutSkin;
	CheckRPGRules();
	
	if (Instigator != None)
	{
		Inv = MagicShieldInv(Instigator.FindInventoryType(class'MagicShieldInv'));
		if (Inv == None)
		{
			Inv = spawn(class'MagicShieldInv', Instigator,,, rot(0,0,0));
			Inv.GiveTo(Instigator);
		}
	}
}

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}
	}

	if(Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

simulated function Destroyed()
{
	FadeOutSkin=none;
	super.Destroyed();
}

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'Monster');
}

function RangedAttack(Actor A)
{
	local RPGStatsInv Inv;
	
	Super.RangedAttack(A);
	
	Enemy = Pawn(A);
	Inv = RPGStatsInv(Enemy.FindInventoryType(class'RPGStatsInv'));

	if ( bShotAnim )
		return;

	if ( Physics == PHYS_Swimming )
	{
		if (Inv != None && Rules != None)
		{
			SetAnimAction('Idle_Rest');
			SuckEXP(Enemy);
		}
		else
			SetAnimAction('Idle_Rest');
	}
	else if ( VSize(Enemy.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		SetAnimAction('gesture_point');
		if ( MeleeDamageTarget(45, (45000.0 * Normal(Controller.Target.Location - Location))) )
			PlaySound(sound'mn_hit10', SLOT_Talk); 
	}
	else if(VSize(Enemy.Location-Location) > TargetRadius)
	{
		SetAnimAction('Idle_Rest');
		PlaySound(sound'BWeaponSpawn1', SLOT_Interface);
		GotoState('Teleporting');
	}
	else if(VSize(Enemy.Location-Location) <= TargetRadius)
	{
		if (Inv != None && Rules != None)
		{
			SetAnimAction('Idle_Rest');
			SuckEXP(Enemy);
		}
		else
			SetAnimAction('Idle_Rest');		
	}
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

simulated function SuckEXP(Pawn Enemy)
{
	local float XPDamage;
	local RPGStatsInv Inv;
	local Actor A;

	XPDamage = (default.MinXPDamage + Rand(default.MaxXPDamage - default.MinXPDamage));
	Inv = RPGStatsInv(Enemy.FindInventoryType(class'RPGStatsInv'));
	
	if (Enemy == None || Enemy.Health <= 0 || Inv == None || Rules == None)
		return;
		
	if (Enemy.IsA('Monster'))
		return;		//targeting pet, which doesn't have XP!

	if (Enemy != None && Enemy.Health > 0 && Inv != None && Rules != None && Inv.DataObject.Level > default.MinimumLevel && Inv.DataObject.Experience > default.MinimumExp)
	{
			Rules.ShareExperience(RPGStatsInv(Enemy.FindInventoryType(class'RPGStatsInv')), XPDamage);
	}
	if (Chain == None && Instigator != None && Enemy != None && FastTrace(Instigator.Location, Enemy.Location))
	{
		Chain = Spawn(class'NecroGhostExpChain',Instigator,,Instigator.Location,rotator(Instigator.Location - Enemy.Location));
	}
	if (Chain != None && Instigator != None)
		Chain.SetBase(Instigator);
	if (rand(99) <= 15)
	{
		A = Instigator.spawn(class'NecroGhostExpLight', Instigator,, Instigator.Location, Instigator.Rotation);
		if (A != None)
		{
			A.RemoteRole = ROLE_SimulatedProxy;
		}
	}
	Enemy.PlaySound(sound'ONSBPSounds.ShockTank.ShieldOff',,500.00);
	PlaySound(sound'tortureloop3', SLOT_Interact);
}

simulated function bool IsViewingAt( vector A, rotator ARot, vector B )
{
	Return ((Normal(B-A) Dot vector(ARot))>0);
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
			SetAnimAction('Idle_Rest');
			GotoState('Teleporting');
	    }
	}

	if(Chain != None && Instigator != None && Enemy != None)
	{
		if (VSize(Instigator.Location - Enemy.Location) > TargetRadius || !FastTrace(Instigator.Location, Enemy.Location))
			Chain.Destroy();
		else
		{
			Chain.mSpawnVecA = Enemy.Location;
			Chain.SetRotation(rotator(Enemy.Location - Instigator.Location));
		}
	}
	if (Chain != None && Enemy == None)
		Chain.Destroy();


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
	local Actor A;
	
	AmbientSound = None;
    bCanTeleport = false; 
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;
		
	HitDamageType = DamageType;
    TakeHitLocation = HitLoc;
	LifeSpan = 0.1000;

    GotoState('Dying');
		
	Velocity += TearOffMomentum;
    BaseEyeHeight = Default.BaseEyeHeight;
    SetPhysics(PHYS_Falling);	
	
	A = spawn(class'NecroGhostExpVanishFX', Self,, Self.Location, Self.Rotation);
	if (A != None)
		A.RemoteRole = ROLE_SimulatedProxy;
		
	if (Chain != None)
		Chain.Destroy();
}

function PlayVictory()
{
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
	SetAnimAction('Idle_Rest');
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (rand(99) >= 33)
		Self.PlaySound(sound'DEKMonsters208.MonsterSounds.NecroGhostDeathSound1',,500.00);
	else if (rand(99) >= 66)
		Self.PlaySound(sound'DEKMonsters208.MonsterSounds.NecroGhostDeathSound2',,500.00);
	else
		Self.PlaySound(sound'DEKMonsters208.MonsterSounds.NecroGhostDeathSound3',,500.00);
	if (Chain != None)
		Chain.Destroy();
	Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     MinXPDamage=-5.000000
     MaxXPDamage=-10.000000
     AChannel=255
     MinimumLevel=60
     MinimumExp=5
     TargetRadius=2000.000000
     bMeleeFighter=False
     DeathSound(0)=Sound'DEKMonsters208.MonsterSounds.NecroGhostDeathSound1'
     DeathSound(1)=Sound'DEKMonsters208.MonsterSounds.NecroGhostDeathSound2'
     ScoringValue=10
     GibGroupClass=Class'DEKMonsters208.NecroGhostExpGibGroup'
     WallDodgeAnims(0)="Idle_Rest"
     WallDodgeAnims(1)="Idle_Rest"
     WallDodgeAnims(2)="Idle_Rest"
     WallDodgeAnims(3)="Idle_Rest"
     FireHeavyRapidAnim="Idle_Rest"
     FireHeavyBurstAnim="Idle_Rest"
     FireRifleRapidAnim="Idle_Rest"
     FireRifleBurstAnim="Idle_Rest"
     bCanFly=True
     MeleeRange=10.000000
     AirSpeed=800.000000
     AccelRate=800.000000
     Health=200
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
     MovementAnims(0)="Idle_Rest"
     MovementAnims(1)="Idle_Rest"
     MovementAnims(2)="Idle_Rest"
     MovementAnims(3)="Idle_Rest"
     SwimAnims(0)="Idle_Rest"
     SwimAnims(1)="Idle_Rest"
     SwimAnims(2)="Idle_Rest"
     SwimAnims(3)="Idle_Rest"
     CrouchAnims(0)="Idle_Rest"
     CrouchAnims(1)="Idle_Rest"
     CrouchAnims(2)="Idle_Rest"
     CrouchAnims(3)="Idle_Rest"
     WalkAnims(0)="Idle_Rest"
     WalkAnims(1)="Idle_Rest"
     WalkAnims(2)="Idle_Rest"
     WalkAnims(3)="Idle_Rest"
     AirAnims(0)="Idle_Rest"
     AirAnims(1)="Idle_Rest"
     AirAnims(2)="Idle_Rest"
     AirAnims(3)="Idle_Rest"
     TakeoffAnims(0)="Idle_Rest"
     TakeoffAnims(1)="Idle_Rest"
     TakeoffAnims(2)="Idle_Rest"
     TakeoffAnims(3)="Idle_Rest"
     LandAnims(0)="Idle_Rest"
     LandAnims(1)="Idle_Rest"
     LandAnims(2)="Idle_Rest"
     LandAnims(3)="Idle_Rest"
     DoubleJumpAnims(0)="Idle_Rest"
     DoubleJumpAnims(1)="Idle_Rest"
     DoubleJumpAnims(2)="Idle_Rest"
     DoubleJumpAnims(3)="Idle_Rest"
     DodgeAnims(0)="Idle_Rest"
     DodgeAnims(1)="Idle_Rest"
     DodgeAnims(2)="Idle_Rest"
     DodgeAnims(3)="Idle_Rest"
     AirStillAnim="Idle_Rest"
     TakeoffStillAnim="Idle_Rest"
     CrouchTurnRightAnim="Idle_Rest"
     CrouchTurnLeftAnim="Idle_Rest"
     IdleCrouchAnim="Idle_Rest"
     IdleSwimAnim="Idle_Rest"
     IdleChatAnim="Idle_Rest"
     Mesh=SkeletalMesh'XanRobots.XanF02'
     Skins(0)=FinalBlend'DEKRPGTexturesMaster207P.fX.SphereInvFB'
     Skins(1)=FinalBlend'DEKRPGTexturesMaster207P.fX.SphereInvFB'
     TransientSoundRadius=800.000000
}
