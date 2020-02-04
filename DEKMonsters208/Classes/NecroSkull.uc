class NecroSkull extends DCManta;

#exec obj load file=GeneralAmbience.uax
#exec obj load file=DEKAnimationMaster206.ukx

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	PlayAnim('Chase');
}

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
	PlayAnim('Chase');
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.Class == class'NecroMortalSkeleton' || P.Class == class'NecroPhantom' || P.Class == class'NecroImmortalSkeleton' || P.Class == class'NecroSoulWraith' || P.Class == class'NecroSorcerer' || P.Class == class'NecroAdrenWraith');
}

function WingBeat()
{
	PlaySound(sound'tortureloop3', SLOT_Interact);
}

simulated function AnimEnd(int Channel)
{
	local name Anim;
	local float frame,rate;
	local vector AccelDir;

	if ( bShotAnim )
		bShotAnim = false;
	if ( bVictoryNext && (Physics != PHYS_Falling) )
	{
		bVictoryNext = false;
		PlayVictory();
		return;
	}
	GetAnimParams(0, Anim,frame,rate);
	if ( Anim != 'Chase' )
		TweenAnim('Chase',0.4);
	else if ( (frame > 0.5) && (FRand() < 0.35) )
	{
		AccelDir = Normal(Acceleration);
		if ( AccelDir.Z > 0.5 )
			PlayAnim('Chase');
		else
			TweenAnim('Chase',0.8 + 2*FRand()+FRand());
	}
	else
		PlayAnim('Chase');
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	PlayAnim('Death');
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
	TweenAnim('HitByEnemy', 0.05);
}

function PlayVictory()
{
	SetAnimAction('Chase');
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;
		
	if ( Location.Z - A.Location.Z + A.CollisionHeight <= 0 )
		return;
	if ( VSize(A.Location - Location) > MeleeRange + CollisionRadius + A.CollisionRadius - FMax(0, 0.7 * A.Velocity Dot Normal(A.Location - Location)) )
		return;
	bShotAnim = true;
	Acceleration = AccelRate * Normal(A.Location - Location + vect(0,0,0.8) * A.CollisionHeight);
	Enable('Bump');
	bStinging = true;
	if (FRand() < 0.5)
	{
		SetAnimAction('Bite');
		PlaySound(sound'mn_hit06', SLOT_Interact);	 		
	}
	else
	{
 		SetAnimAction('Bite');
 		PlaySound(sound'mn_hit06', SLOT_Interact); 
 	}	
}

singular function Bump(actor Other)
{
	local name Anim;
	local float frame,rate;

	if ( bShotAnim && bStinging )
	{
		bStinging = false;
		GetAnimParams(0, Anim,frame,rate);
		if ( (Anim == 'Bite') || (Anim == 'Bite') )
			MeleeDamageTarget(18, (20000.0 * Normal(Controller.Target.Location - Location)));
		Velocity *= -0.5;
		Acceleration *= -1;
		if (Acceleration.Z < 0)
			Acceleration.Z *= -1;
	}
	Super.Bump(Other);
}

function bool IsHeadShot(vector loc, vector ray, float AdditionalScale)
{
	return super(xPawn).IsHeadShot(loc,ray,AdditionalScale);
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
    
    if ( (DamageType == class'DamTypeSniperHeadShot') || ((HitLoc.Z > Location.Z + 0.75 * CollisionHeight) && (FRand() > 0.5)  && (DamageType != class'DamTypeAssaultBullet') && (DamageType != class'DamTypeMinigunBullet') && (DamageType != class'DamTypeFlakChunk')) )
    {
		//CreateGib('head',DamageType,Rotation);
		PlayAnim('Death');
		return;
	}
	else
		PlayAnim('Death');
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
     HitSound(0)=Sound'NewDeath.MaleNightmare.mn_hit02'
     HitSound(1)=Sound'NewDeath.MaleNightmare.mn_hit03'
     HitSound(2)=Sound'NewDeath.MaleNightmare.mn_hit05'
     HitSound(3)=Sound'NewDeath.MaleNightmare.mn_hit06'
     DeathSound(0)=Sound'NewDeath.MaleNightmare.mn_death01'
     DeathSound(1)=Sound'NewDeath.MaleNightmare.mn_death07'
     DeathSound(2)=Sound'NewDeath.MaleNightmare.mn_death07'
     DeathSound(3)=Sound'NewDeath.MaleNightmare.mn_death07'
     ChallengeSound(0)=Sound'GeneralAmbience.tortureloop3'
     ChallengeSound(1)=Sound'GeneralAmbience.tortureloop3'
     ChallengeSound(2)=Sound'GeneralAmbience.tortureloop3'
     ChallengeSound(3)=Sound'GeneralAmbience.tortureloop3'
     HeadRadius=20.000000
     MovementAnims(0)="Chase"
     MovementAnims(1)="Chase"
     MovementAnims(2)="Chase"
     MovementAnims(3)="Chase"
     WalkAnims(0)="Chase"
     WalkAnims(1)="Chase"
     WalkAnims(2)="Chase"
     WalkAnims(3)="Chase"
     AirAnims(0)="Chase"
     AirAnims(1)="Chase"
     AirAnims(2)="Chase"
     AirAnims(3)="Chase"
     TakeoffAnims(0)="Chase"
     TakeoffAnims(1)="Chase"
     TakeoffAnims(2)="Chase"
     TakeoffAnims(3)="Chase"
     AirStillAnim="Chase"
     TakeoffStillAnim="Chase"
     Mesh=SkeletalMesh'DEKAnimationMaster206.NecroSkull'
     DrawScale=0.125000
     Skins(0)=Texture'DEKMonstersTexturesMaster206E.NecroMonsters.NecroSkull'
     Skins(1)=Texture'DEKMonstersTexturesMaster206E.NecroMonsters.NecroSkull'
     CollisionHeight=24.000000
     GibGroupClass=Class'DEKMonsters208.SkullGibGroup'
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
