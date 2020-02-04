class MissionCow extends SMPNaliCow
	config(satoreMonsterPack);

var Pawn Master;
var bool SummonedMonster;

function PostNetBeginPlay()
{
	Instigator = self;
	Super.PostNetBeginPlay();
	SummonedMonster = True;
}

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'Monster');
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
	SetAnimAction('Swish');
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local Monster M;
	local FriendlyMonsterInv Inv;
	
	M = Monster(InstigatedBy);
	Inv = FriendlyMonsterInv(InstigatedBy.FindInventoryType(class'FriendlyMonsterInv'));
	
	if (DamageType == class'DamTypeLightningRod' || DamageType == class'DamTypeEnhLightningRod' || DamageType == class'DamTypeLightningBolt' || DamageType == class'DamTypeLightningSent' || DamageType == class'DamTypeMachinegunSentinel' || DamageType == class'DamTypeSniperSentinel' || DamageType == class'DamTypeBeamSentinel' || DamageType == class'DamTypeBlasterLaser' || DamageType == class'DamTypeEnergyWall' || DamageType == class'DamTypeHellfireSentinel' || DamageType == class'DamTypeLightningTurretMinibolt' || DamageType == class'DamTypeLightningTurretProj' || DamageType == class'DamTypeMassDrain' || DamageType == class'DamTypeMercurySENTAirHeadHit' || DamageType == class'DamTypeMercurySENTAirHit' || DamageType == class'DamTypeMercurySENTAirPunchThrough' || DamageType == class'DamTypeMercurySENTAirPunchThroughHead' || DamageType == class'DamTypeMercurySENTDirectHit' || DamageType == class'DamTypeMercurySENTHeadHit' || DamageType == class'DamTypeMercurySENTPunchThrough' || DamageType == class'DamTypeMercurySENTPunchThroughHead' || DamageType == class'DamTypeMercurySENTSplashDamage' || DamageType == class'DamTypeRocketSentinelProj' || DamageType == class'DamTypeAerialTrap' || DamageType == class'DamTypeBombTrap' || DamageType == class'DamTypeFrostTrap' || DamageType == class'DamTypeLaserGrenadeLaser' || DamageType == class'DamTypeShockTrap' || DamageType == class'DamTypeShockTrapShock' || DamageType == class'DamTypeWildfireTrap' || DamageType == class'DamTypeDronePlasma')
	{
		return; //These things are out of our control.
	}
	
	if (InstigatedBy.IsA('HealerNali'))
		return;
	
	if (M == None)
		return;
	
	if (M.ControllerClass == class'DEKFriendlyMonsterController')
		return;
		
	if (Inv != None)
		return;

	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damagetype);
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local Actor A;
	
	A = spawn(class'NewTransEffectBlue', Self,, Self.Location, Self.Rotation);
	if (A != None)
		A.RemoteRole = ROLE_SimulatedProxy;
	Self.PlaySound(Sound'SkaarjPack_rc.DeathC2c');
	
	if (SummonedMonster)
	{
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	}
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     bMeleeFighter=True
     ScoringValue=0
     MeleeRange=40.000000
     GroundSpeed=340.000000
     WaterSpeed=169.000000
     AirSpeed=338.000000
     JumpZ=261.000000
     HealthMax=150.000000
     Health=150
     ControllerClass=Class'SkaarjPack.MonsterController'
}
