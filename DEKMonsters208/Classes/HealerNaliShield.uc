class HealerNaliShield extends SMPNali;

var bool SummonedMonster;
var() config float HealthDamage, HealthDamageMax;
var config int SoundChance;

function PostNetBeginPlay()
{
	Instigator = self;
	Super.PostNetBeginPlay();
	SummonedMonster = True;
}

function CheckController()
{
	if (Instigator.ControllerClass == class'DEKFriendlyMonsterController')
		SummonedMonster = true;
}

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'Monster');
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
		AddHealth(HealthDamage, vect(0,0,0));
	}
	else if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		SetAnimAction('spell');
		AddHealth(HealthDamage, vect(0,0,0));
	}
	else
	{
		SetAnimAction('spell');
		AddHealth(HealthDamage, vect(0,0,0));
	}
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

function AddHealth(float HealthDamage, vector pushdir)
{
	local Pawn P;
	local HealerNaliShieldFX FX;
	local float HealthAmount;
	local Vehicle V;
	local int MaxShield;
	local Monster M;
	local HealerNaliShieldCorona Corona;

	HealthAmount = (HealthDamage + Rand(HealthDamageMax - HealthDamage));
	
	P = Controller.Enemy;
	V = Vehicle(P);
	M = Monster(P);
	
	if (P == None || P.Health<=0)
		return;
	if (V != None )
		return;
	if (M != None && M.ControllerClass != class'DEKFriendlyMonsterController')
		return;
		
	MaxShield = P.GetShieldStrengthMax();

	if (P != None && P.ShieldStrength < MaxShield)
	{
		P.AddShieldStrength(HealthAmount);
		P.PlaySound(Sound'PickupSounds.ShieldPack',, 2 * P.TransientSoundVolume,, 1.5 * P.TransientSoundRadius);
		FX = Spawn(class'HealerNaliShieldFX',,,P.Location,Rotation);
		Corona = Spawn(class'HealerNaliShieldCorona',Self);
	}
	
	if (SoundChance > Rand(99))
		Self.PlaySound(Sound'satoreMonsterPackv120.Nali.contct3n');
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local Monster M;
	
	M = Monster(InstigatedBy);
	
	if (M != None && M.ControllerClass == class'DEKFriendlyMonsterController')
	{
		return;		//This is a pet trying to kill me.
	}
	
	if (DamageType == class'DamTypeLightningRod' || DamageType == class'DamTypeEnhLightningRod' || DamageType == class'DamTypeLightningBolt' || DamageType == class'DamTypeLightningSent' || DamageType == class'DamTypeMachinegunSentinel' || DamageType == class'DamTypeSniperSentinel' || DamageType == class'DamTypeBeamSentinel')
	{
		return; //These things are out of our control.
	}
	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damagetype);
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
     HealthDamage=5.000000
     HealthDamageMax=10.000000
     SoundChance=20
     ScoringValue=0
     Health=20
}
