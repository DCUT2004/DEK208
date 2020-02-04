class NecroSorcerer extends Monster;

var int numChildren;
var() config int MaxChildren;
var() config float ResurrectedHealthPercent, ResurrectionIntervalTime, SnipeIntervalTime, ResurrectionRadius;
var() Sound ResurrectionSound;
var() float LastResurrectionTime, LastSnipeTime;
var() config bool bSorcererCanResurrect;
var name DeathAnim[4];
var bool SummonedMonster;
var class<xEmitter> BeamEffectClass;
var int BeamDamage;
var int AimError;
var class<DamageType> BeamDamageType;
var NecroInvFX FX;

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
		return ( P.class == class'Monster' || P.Class == class'NecroMortalSkeleton' || P.Class == class'NecroPhantom' || P.Class == class'NecroImmortalSkeleton' || P.Class == class'NecroSoulWraith' || P.Class == class'NecroSorcerer' || P.Class == class'NecroAdrenWraith');
}

function RangedAttack(Actor A)
{
	local Monster M, Resurrected;
	local float Decision, Percentage;
	local NecroSorcererResurrectedInv Inv;
	
	//Super.RangedAttack(A);
		
	if ( bShotAnim )
		return;
		
	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		MeleeDamageTarget(20, (15000.0 * Normal(A.Location - Location)));
			PlaySound(sound'mn_hit10', SLOT_Talk); 
			SetAnimAction('Bow2');
	}
	else if (FastTrace(A.Location,Location) == true && Level.TimeSeconds - LastSnipeTime > SnipeIntervalTime)
	{
		SetAnimAction('spell');
		FireBeam();
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
	}
	
	if (bSorcererCanResurrect && Level.TimeSeconds - LastResurrectionTime > ResurrectionIntervalTime)
	{
		foreach VisibleActors(class'Monster', M, ResurrectionRadius)
		{
			if(M != Self && M.GetStateName() == 'Dying')
			{
				M.SetCollision(false,false,false);
				M.bHidden = true;
				Resurrected = Spawn(M.class, self,, M.Location,);
				if(Resurrected != None)
				{
					Inv = NecroSorcererResurrectedInv(Resurrected.FindInventoryType(class'NecroSorcererResurrectedInv'));
					if (Inv == None)
					{
						Inv = Resurrected.spawn(class'NecroSorcererResurrectedInv');
						Inv.GiveTo(Resurrected);
					}
					//FX = Spawn(class'NecroInvFX', Resurrected,, Resurrected.Location, Resurrected.Rotation + rot(0, -16384, 0));
					//if (FX != None)
					//{
					//	FX.Emitters[0].SkeletalMeshActor = Resurrected;
					//	//FX.SetLocation(Resurrected.Location);
					//	//FX.SetRotation();
					//	FX.SetBase(Resurrected);
					//	FX.bOwnerNoSee = true;
					//	FX.RemoteRole = ROLE_SimulatedProxy;
					//}
					//Instigator.Spawn(Class'ReviveEffectA',Self,,Instigator.Location);
					Instigator.Spawn(Class'ReviveEFfectB',Self,,Instigator.Location);
					PlaySound(ResurrectionSound,SLOT_Interact, 500);
					Instigator.SetAnimAction('spell');
					if(Invasion(Level.Game) != None)
					{
						Invasion(Level.Game).NumMonsters++;
					}
					Percentage = ResurrectedHealthPercent * 100;
					Percentage = (Percentage/100) * Resurrected.default.health;
					Resurrected.Health = Percentage;
					LastResurrectionTime = Level.TimeSeconds;
					Resurrected = None;
					bShotAnim = true;
					Controller.bPreparingMove = true;
					Acceleration = vect(0,0,0);
					return;
				}
			}
		}
	}
	if (decision < 0.35 && numChildren==0)
	{
		SpawnChildren();
		return;
	}
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	//bShotAnim = true;
}

function SpawnChildren()
{
	local NavigationPoint N;
	local NecroChildImmortalSkeleton P;

	For ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
		if(numChildren>=MaxChildren)
			return;
		else if(vsize(N.Location-Location)<2000 && FastTrace(N.Location,Location))
		{
			P=spawn(class 'NecroChildImmortalSkeleton' ,self,,N.Location);
		    if(P!=none)
		    {
		    	P.LifeSpan=20+Rand(10);
				numChildren++;
			}
		}

	}

}

function FireBeam()
{
	local Vector X,Y,Z, End, HitLocation, HitNormal, RefNormal;
	local Actor Other, mainArcHitTarget;
	local float TraceRange;
	local vector Start;
	local rotator Dir;
	Local xEmitter Beam;
	local bool bReflect;
	
	LastSnipeTime = Level.TimeSeconds;

	GetAxes(Rotation,X,Y,Z);
	Start = GetFireStart(X,Y,Z);

	Dir = Controller.AdjustAim(SavedFireProperties,Start,AimError);
	TraceRange = 10000;

	while(true)
	{
		bReflect = false;
		X = Vector(Dir);
		End = Start + TraceRange * X;
		Other = Trace(HitLocation, HitNormal, End, Start, true);

		if ( Other != None && Other != Instigator)
		{
			if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, BeamDamage * 0.25))
			{
				bReflect = true;
			}
			else if ( Other != mainArcHitTarget )
			{
				if ( !Other.bWorldGeometry )
				{
					if ( (Pawn(Other) != None))
					{
						HitLocation = Other.Location;
						Other.TakeDamage(BeamDamage, Instigator, HitLocation, X, BeamDamageType);
					}
				}
				else
				{
					HitLocation = HitLocation + 2.0 * HitNormal;
				}
			}
		}
		else
		{
			HitLocation = End;
			HitNormal = Normal(Start - End);
		}

		Beam = Spawn(BeamEffectClass ,,, Start,);
		Beam.mSpawnVecA = HitLocation;

		if(bReflect == true)
		{
			Start = HitLocation;
			Dir = Rotator( X - 2.0*RefNormal*(X dot RefNormal) );
		}
		else
		{
			break;
		}
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
     MaxChildren=2
     ResurrectedHealthPercent=1.000000
     ResurrectionIntervalTime=8.000000
     SnipeIntervalTime=2.000000
     ResurrectionRadius=1500.000000
     ResurrectionSound=Sound'GameSounds.DDAverted'
     bSorcererCanResurrect=True
     DeathAnim(0)="Dead"
     DeathAnim(1)="Dead2"
     DeathAnim(2)="Dead3"
     DeathAnim(3)="Dead4"
     BeamEffectClass=Class'DEKRPG208.DefenseBoltEmitter'
     BeamDamage=80
     aimerror=600
     BeamDamageType=Class'DEKMonsters208.DamTypeSorcererLightning'
     bMeleeFighter=False
     HitSound(0)=Sound'NewDeath.MaleNightmare.mn_hit02'
     HitSound(1)=Sound'NewDeath.MaleNightmare.mn_hit03'
     HitSound(2)=Sound'NewDeath.MaleNightmare.mn_hit05'
     HitSound(3)=Sound'NewDeath.MaleNightmare.mn_hit06'
     DeathSound(0)=Sound'NewDeath.MaleNightmare.mn_death01'
     DeathSound(1)=Sound'NewDeath.MaleNightmare.mn_death07'
     ScoringValue=14
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
     Health=350
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
     Skins(0)=Shader'DEKMonstersTexturesMaster206E.NecroMonsters.SorcererNaliShader'
     Skins(1)=Shader'DEKMonstersTexturesMaster206E.NecroMonsters.SorcererNaliShader'
}
