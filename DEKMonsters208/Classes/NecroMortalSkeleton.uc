class NecroMortalSkeleton extends Monster;

var name DeathAnims[4];
var bool SummonedMonster;
var int ClawDamage;

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
		return ( P.Class == class'NecroMortalSkeleton' || P.Class == class'NecroPhantom' || P.Class == class'NecroImmortalSkeleton' || P.Class == class'NecroSoulWraith' || P.Class == class'NecroSorcerer' || P.Class == class'NecroAdrenWraith');
}

function RangedAttack(Actor A)
{
	local float Dist;
	
	Super.RangedAttack(A);
	
	if ( bShotAnim )
	{
		return;
	}
		
	Dist = VSize(A.Location - Location);
	if ( Dist > MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		return;
	}
	bShotAnim = true;
		
	MeleeDamageTarget(ClawDamage, (15000.0 * Normal(A.Location - Location)));
	PlaySound(sound'mn_hit10', SLOT_Talk); 
	SetAnimAction('Gesture_Taunt03');
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
}

function PlayVictory()
{
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
	PlayAnim('gesture_cheer', 1.0, 0.1);
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	AmbientSound = None;
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
		PlayAnim('DeathB',1,0.05);
		CreateGib('head',DamageType,Rotation);
		return;
	}
	else
		PlayAnim(DeathAnims[Rand(4)],1.2,0.05);		
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
     DeathAnims(0)="DeathB"
     DeathAnims(1)="DeathF"
     DeathAnims(2)="DeathL"
     DeathAnims(3)="DeathR"
     ClawDamage=12
     HitSound(0)=Sound'NewDeath.MaleNightmare.mn_hit02'
     HitSound(1)=Sound'NewDeath.MaleNightmare.mn_hit03'
     HitSound(2)=Sound'NewDeath.MaleNightmare.mn_hit05'
     HitSound(3)=Sound'NewDeath.MaleNightmare.mn_hit06'
     DeathSound(0)=Sound'NewDeath.MaleNightmare.mn_death01'
     DeathSound(1)=Sound'NewDeath.MaleNightmare.mn_death07'
     DeathSound(2)=Sound'NewDeath.MaleNightmare.mn_death04'
     DeathSound(3)=Sound'NewDeath.MaleNightmare.mn_death03'
     GibGroupClass=class'DEKMonsters208.BoneGibGroup'
     SoundFootsteps(0)=Sound'satoreMonsterPackv120.Nali.walkC'
     SoundFootsteps(1)=Sound'satoreMonsterPackv120.Nali.walkC'
     SoundFootsteps(2)=Sound'satoreMonsterPackv120.Nali.walkC'
     SoundFootsteps(3)=Sound'satoreMonsterPackv120.Nali.walkC'
     SoundFootsteps(4)=Sound'satoreMonsterPackv120.Nali.walkC'
     SoundFootsteps(5)=Sound'satoreMonsterPackv120.Nali.walkC'
     IdleHeavyAnim="Idle_Biggun"
     IdleRifleAnim="Idle_Rifle"
     RagdollOverride="Male2"
     MeleeRange=25.000000
     GroundSpeed=340.000000
     WaterSpeed=120.000000
     AirSpeed=340.000000
     JumpZ=140.000000
     TurnLeftAnim="TurnL"
     TurnRightAnim="TurnR"
     CrouchAnims(0)="CrouchF"
     CrouchAnims(1)="CrouchB"
     CrouchAnims(2)="CrouchL"
     CrouchAnims(3)="CrouchR"
     AirAnims(0)="JumpF_Mid"
     AirAnims(1)="JumpB_Mid"
     AirAnims(2)="JumpL_Mid"
     AirAnims(3)="JumpR_Mid"
     TakeoffAnims(0)="JumpF_Takeoff"
     TakeoffAnims(1)="JumpB_Takeoff"
     TakeoffAnims(2)="JumpL_Takeoff"
     TakeoffAnims(3)="JumpR_Takeoff"
     LandAnims(0)="JumpF_Land"
     LandAnims(1)="JumpB_Land"
     LandAnims(2)="JumpL_Land"
     LandAnims(3)="JumpR_Land"
     DoubleJumpAnims(0)="DoubleJumpF"
     DoubleJumpAnims(1)="DoubleJumpB"
     DoubleJumpAnims(2)="DoubleJumpL"
     DoubleJumpAnims(3)="DoubleJumpR"
     DodgeAnims(0)="DodgeF"
     DodgeAnims(1)="DodgeB"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="Jump_Mid"
     TakeoffStillAnim="Jump_Takeoff"
     CrouchTurnRightAnim="Crouch_TurnR"
     CrouchTurnLeftAnim="Crouch_TurnL"
     IdleWeaponAnim="Idle_Rifle"
     Mesh=SkeletalMesh'HumanMaleA.SkeletonMale'
     Skins(0)=Texture'DEKMonstersTexturesMaster206E.NecroMonsters.NecroSkeleton'
     Skins(1)=Texture'DEKMonstersTexturesMaster206E.NecroMonsters.NecroSkeleton'
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
