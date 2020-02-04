class NecroGhostPoltergeist extends Monster
	config(satoreMonsterPack);

var ColorModifier FadeOutSkin;
var vector TelepDest;
var		byte AChannel;
var float LastTelepoTime;
var bool bTeleporting;
var config float TargetRadius, DamageMultiplier, MaxDamageBoost;
var NecroGhostPoltergeistDamageSphere Sphere;

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
	local float decision;
	local Pawn P;
	local Vehicle V;
	
	Super.RangedAttack(A);

	decision = FRand();
	
	P = Pawn(A);
	V = Vehicle(P);

	if ( bShotAnim )
		return;

	if ( Physics == PHYS_Swimming )
	{
		SetAnimAction('Idle_Rest');
		if (Sphere == None)
			SpawnSphere();
	}
	else if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		SetAnimAction('gesture_point');
		if ( MeleeDamageTarget(45, (45000.0 * Normal(Controller.Target.Location - Location))) )
			PlaySound(sound'mn_hit10', SLOT_Talk); 
	}
	else if (V != None)
	{
		SetAnimAction('gesture_point');
		if ( MeleeDamageTarget(45, (45000.0 * Normal(Controller.Target.Location - Location))) )
			PlaySound(sound'mn_hit10', SLOT_Talk); 
	}
	else if(VSize(A.Location-Location)>7000 && (decision < 0.70))
	{
		SetAnimAction('Idle_Rest');
		PlaySound(sound'BWeaponSpawn1', SLOT_Interface);
		GotoState('Teleporting');
	}
	else
	{
		SetAnimAction('Idle_Rest');
		if (Sphere == None)
			SpawnSphere();
	}
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

function SpawnSphere()
{
	local Actor A;
	local FriendlyMonsterInv Inv;
	local Controller C, BestC;
	local int MostHealth;

	C = Level.ControllerList;
	BestC = None;
	MostHealth = 0;
	
	
	while (C != None)
	{
		// loop round finding strongest enemy to attack
		if ( C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && C.Pawn.IsA('Monster')
		     && VSize(C.Pawn.Location - Instigator.Location) < TargetRadius && FastTrace(C.Pawn.Location, Instigator.Location) && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !C.Pawn.bCanFly)
		{
			Inv = FriendlyMonsterInv(C.Pawn.FindInventoryType(class'FriendlyMonsterInv'));
			if (Inv == None && C.Pawn.Health > MostHealth)
			{
				MostHealth = C.Pawn.Health;
				BestC = C;
			}
		}
		C = C.NextController;
	}

	if ((MostHealth > 0) && (BestC != None) && (BestC.Pawn != None))
		Sphere = Spawn(class'NecroGhostPoltergeistDamageSphere',Instigator,,BestC.Pawn.Location);
	else if (BestC == None)
		Sphere = Spawn(class'NecroGhostPoltergeistDamageSphere',Instigator,,Instigator.Location);		
	GotoState('Teleporting');
	
	if (rand(99) <= 15)
	{
		A = Instigator.spawn(class'NecroGhostPoltergeistLight', Instigator,, Instigator.Location, Instigator.Rotation);
		if (A != None)
		{
			A.RemoteRole = ROLE_SimulatedProxy;
		}
	}
}

//function MoveEnemy(Pawn P)
//{
//	local bool bOnCeiling;
//	local bool bOnFloor;
//	local float decision;
//	local Actor A;
//	local Vehicle V;
//	
//	decision = FRand();
//	V = Vehicle(P);
//	
//	if (P.Mass >= 19000)
//		return;
//		
//	if(!class'RW_Freeze'.static.canTriggerPhysics(P))
//	{
//		return;
//	}
//	
//	if (V != None)
//		return;
//
//	if ( Role == ROLE_Authority )
//	{
//		bOnFloor = GetSpawnHeight(P.Location);
//		bOnCeiling = FindCeiling(P.Location);
//		if (bOnCeiling)
//		{
//			P.SetPhysics(PHYS_Falling);
//			P.Velocity.Z=-1500;
//		}
//		else if(bOnFloor)
//		{
//			//P.SetPhysics(PHYS_Hovering);
//			P.Velocity.Z=1000;
//			if (Rand(99) > 25)
//				P.Velocity.X=1000;
//			else if (Rand(99) > 50)
//				P.Velocity.X=-1000;
//			else if (Rand(99) > 75)
//				P.Velocity.Y=1000;
//			else
//				P.Velocity.Y=-1000;
//		}
//		else if(!bOnFloor && !bOnCeiling && decision > 0.85)
//		{
//			P.SetPhysics(PHYS_Falling);
//			P.Velocity.Z=-1500;
//		}
//		else
//		{
//			if(decision > 0.5)
//			{
//				//P.SetPhysics(PHYS_Hovering);
//				P.Velocity.Z=1000;
//				if (Rand(99) > 25)
//					P.Velocity.X=1000;
//				else if (Rand(99) > 50)
//					P.Velocity.X=-1000;
//				else if (Rand(99) > 75)
//					P.Velocity.Y=1000;
//				else
//					P.Velocity.Y=-1000;
//			}
//			else
//			{
//				P.SetPhysics(PHYS_Falling);
//				P.Velocity.Z=-1500;
//			}
//		}
//	}
//	if (rand(99) <= 15)
//	{
//		A = Instigator.spawn(class'NecroGhostPoltergeistLight', Instigator,, Instigator.Location, Instigator.Rotation);/
//		if (A != None)
//		{
//			A.RemoteRole = ROLE_SimulatedProxy;
//		}
//	}
//}

//function bool GetSpawnHeight(Vector MyLocation)
//{
//	local Vector DownEndLocation;
//	local vector HitLocation;
//	local vector HitNormal;
//	local Actor AHit;
//	
//	DownEndLocation = MyLocation + vect(0,0,-300);
//
 //   	AHit = Trace(HitLocation, HitNormal, DownEndLocation, MyLocation, true);
//	if (AHit == None || !AHit.bWorldGeometry)
//		return false;	
//	else 
//		return true;
//}

//function bool FindCeiling(Vector MyLocation)
//{
//	local Vector UpEndLocation;
//	local vector HitLocation;
//	local vector HitNormal;
//	local Actor AHit;
//	
//	UpEndLocation = MyLocation + vect(0,0,300);
//
 //   	AHit = Trace(HitLocation, HitNormal, UpEndLocation, MyLocation, true);
//	if (AHit == None || !AHit.bWorldGeometry)
//		return false;
//	else 
//		return true;
//}

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
	
	A = spawn(class'NecroGhostPoltergeistVanishFX', Self,, Self.Location, Self.Rotation);
	if (A != None)
		A.RemoteRole = ROLE_SimulatedProxy;
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
	Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     AChannel=255
     TargetRadius=2000.000000
     MaxDamageBoost=0.500000
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
     Mesh=SkeletalMesh'HumanMaleA.NightMaleB'
     Skins(0)=FinalBlend'DEKRPGTexturesMaster207P.fX.SphereDamageFB'
     Skins(1)=FinalBlend'DEKRPGTexturesMaster207P.fX.SphereDamageFB'
     TransientSoundRadius=800.000000
}
