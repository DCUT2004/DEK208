class DCTentacle extends Monster;

var bool SummonedMonster;
var float LastShootTime;
var() config float ShootIntervalTime;

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
}

function bool SetTentacleLocation()
{
	local Actor Other;
	local vector HitLoc,HitNorm;

	foreach TraceActors(class'Actor',Other,HitLoc,HitNorm,Location+vect(0,0,1)*5000,Location)
	{
		//	Log("Tentacle=" $ Other $ " & Location=" $ HitLoc);
		if(Other.bWorldGeometry && Other.bBlockActors)
		{
			SetPhysics(PHYS_none);
			SetBase(Other,HitLoc-vect(0,0,1)*(CollisionHeight));
			if(SetLocation(HitLoc-vect(0,0,1)*(CollisionHeight)))
				return true;
			else
				return false;
		}
	}
	return false;
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'DCTentacle');
}

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

singular function Falling()
{
	SetPhysics(PHYS_Flying);
}

Simulated function PlayWaiting()
{
	Instigator.Acceleration = vect(0,0,950);
    TweenAnim('Hide', 5.0);
    Controller.GotoState('TacticalMove','WaitForAnim');
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
	TweenAnim('TakeHit', 0.05);
}

function bool Dodge(eDoubleClickDir DoubleClickMove)
{
	local vector X,Y,Z,duckdir;

    GetAxes(Rotation,X,Y,Z);
	if (DoubleClickMove == DCLICK_Forward)
		duckdir = X;
	else if (DoubleClickMove == DCLICK_Back)
		duckdir = -1*X;
	else if (DoubleClickMove == DCLICK_Left)
		duckdir = Y;
	else if (DoubleClickMove == DCLICK_Right)
		duckdir = -1*Y;

	Controller.Destination = Location + 200 * duckDir;
	Velocity = AirSpeed * duckDir;
	Controller.GotoState('TacticalMove', 'DoMove');
	return true;
}

function RangedAttack(Actor A)
{

	if ( bShotAnim )
		return;
	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
        PlaySound(Sound'strike2tn', SLOT_Interact);
		SetAnimAction('Smack');
	}
	else if( Level.TimeSeconds - LastShootTime > ShootIntervalTime)
	{
		SetAnimAction('Shoot');
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		bShotAnim = true;
	}

	bShotAnim = true;

}
function Shoot()
{
	FireProjectile();
}

function SmackTarget()
{
	if ( MeleeDamageTarget(28, 25000 * Normal(Controller.Target.Location - Location)))
		PlaySound(Sound'splat2tn', SLOT_Interact);
}

function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local vector HitLocation, HitNormal;
	local actor HitActor;

	// check if still in melee range
	if ( (Controller.target != None) && (VSize(Controller.Target.Location - Location) <= MeleeRange * 1.5 + Controller.Target.CollisionRadius + CollisionRadius))
	{
		HitActor = Trace(HitLocation, HitNormal, Controller.Target.Location, Location, false);
		if ( HitActor != None )
			return false;
		Controller.Target.TakeDamage(hitdamage, self,HitLocation, pushdir, class'MeleeDamage');
		return true;
	}
	return false;
}

function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + CollisionHeight * vect(0,0,-1.2);
}

function PlayVictory()
{
    Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
    PlayAnim('Move1', 0.6, 0.1);
    Controller.Destination = Location;
    Controller.GotoState('TacticalMove','WaitForAnim');
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    SetPhysics(PHYS_Falling);
	AmbientSound = None;
    bCanTeleport = false;
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;
    	LifeSpan = RagdollLifeSpan;
    Velocity=vect(0,0,800);


    GotoState('Dying');
	//PlaySound(Sound'death2tn', SLOT_Talk, 3 * TransientSoundVolume);
	if ( Velocity.Z > 200 )
		PlayAnim('Dead2', 0.7, 0.1);
	else
	{
		PlayAnim('Dead1', 0.7, 0.1);
		//SetPhysics(PHYS_None);
	}
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
     ShootIntervalTime=0.500000
     bMeleeFighter=False
     HitSound(0)=Sound'satoreMonsterPackSound.Slith.injur1sl'
     HitSound(1)=Sound'satoreMonsterPackSound.Slith.injur2sl'
     HitSound(2)=Sound'satoreMonsterPackSound.Slith.injur1sl'
     HitSound(3)=Sound'satoreMonsterPackSound.Slith.injur2sl'
     DeathSound(0)=Sound'satoreMonsterPackSound.Slith.deathLsl'
     DeathSound(1)=Sound'satoreMonsterPackSound.Slith.deathWsl'
     AmmunitionClass=Class'DEKMonsters208.DCTentacleAmmo'
     bCanJump=False
     bCanWalk=False
     bCanFly=True
     MeleeRange=70.000000
     AirSpeed=330.000000
     Health=50
     MovementAnims(0)="Waver"
     MovementAnims(1)="Waver"
     MovementAnims(2)="Waver"
     MovementAnims(3)="Waver"
     TurnLeftAnim="Waver"
     TurnRightAnim="Waver"
     CrouchAnims(0)="Waver"
     CrouchAnims(1)="Waver"
     CrouchAnims(2)="Waver"
     CrouchAnims(3)="Waver"
     AirAnims(0)="Waver"
     AirAnims(1)="Waver"
     AirAnims(2)="Waver"
     AirAnims(3)="Waver"
     TakeoffAnims(0)="Waver"
     TakeoffAnims(1)="Waver"
     TakeoffAnims(2)="Waver"
     TakeoffAnims(3)="Waver"
     LandAnims(0)="Waver"
     LandAnims(1)="Waver"
     LandAnims(2)="Waver"
     LandAnims(3)="Waver"
     DodgeAnims(0)="Waver"
     DodgeAnims(1)="Waver"
     DodgeAnims(2)="Waver"
     DodgeAnims(3)="Waver"
     AirStillAnim="Waver"
     TakeoffStillAnim="Waver"
     CrouchTurnRightAnim="Waver"
     CrouchTurnLeftAnim="Waver"
     IdleWeaponAnim="Waver"
     Mesh=VertMesh'satoreMonsterPackMeshes.Tentacle1'
     Skins(0)=Texture'satoreMonsterPackTexture.Skins.JTentacle1'
     Skins(1)=None
     CollisionRadius=28.000000
     CollisionHeight=36.000000
     RotationRate=(Pitch=0,Yaw=30000,Roll=0)
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
