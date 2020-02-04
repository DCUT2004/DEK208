class NecroGhostIllusionClone extends NecroGhostIllusion
	config(satoreMonsterPack);
	
var NecroGhostIllusion ParentGhost;
var config int HPDamage, AdrenDamage;

#exec  AUDIO IMPORT NAME="NecroGhostIllusionLaugh" FILE="C:\UT2004\Sounds\NecroGhostIllusionLaugh.WAV" GROUP="MonsterSounds"

simulated function PreBeginPlay()
{
	ParentGhost=NecroGhostIllusion(Owner);
	if(ParentGhost==none)
		Destroy();
	Super.PreBeginPlay();
}

function Destroyed()
{
	FadeOutSkin=none;
	if ( ParentGhost != None )
		ParentGhost.numChildren--;
	Super.Destroyed();
}

function RangedAttack(Actor A)
{
	local float decision;
	local Pawn P;
	
	Super.RangedAttack(A);

	decision = FRand();
	
	P = Pawn(A);

	if ( bShotAnim )
		return;

	if ( Physics == PHYS_Swimming )
	{
		SetAnimAction('Idle_Rest');
	}
	else if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
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
		SetAnimAction('Idle_Rest');
		
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

function SpawnClone()
{
	return;
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
	
	if(ParentGhost==none || ParentGhost.Controller==none || ParentGhost.Controller.Enemy==self)
	{
		Destroy();
		return;
	}
	if(ParentGhost.Controller!=none && Controller!=none && Health>=0)
	{
		Controller.Enemy=ParentGhost.Controller.Enemy;
		Controller.Target=ParentGhost.Controller.Target;
	}

	super.Tick(DeltaTime);
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (rand(99) >= 33)
		Self.PlaySound(sound'DEKMonsters208.MonsterSounds.NecroGhostIllusionLaugh',,500.00);
	else if (rand(99) >= 66)
		Self.PlaySound(sound'DEKMonsters208.MonsterSounds.NecroGhostIllusionLaugh',,500.00);
	else
		Self.PlaySound(sound'DEKMonsters208.MonsterSounds.NecroGhostIllusionLaugh',,500.00);
	if (Killer != None && Killer.Pawn != None && Killer.Pawn.Health > 0)
	{
		Killer.Pawn.TakeDamage(HPDamage, ParentGhost, Killer.Pawn.Location, vect(0,0,0), class'DamTypeNecroGhostIllusion');
		Killer.Adrenaline -= default.AdrenDamage;
	}
	Destroy();
}

defaultproperties
{
     HPDamage=10
     AdrenDamage=20
     MaxChildren=0
     DeathSound(0)=Sound'DEKMonsters208.MonsterSounds.NecroGhostIllusionLaugh'
     DeathSound(1)=Sound'DEKMonsters208.MonsterSounds.NecroGhostIllusionLaugh'
     ScoringValue=0
}
