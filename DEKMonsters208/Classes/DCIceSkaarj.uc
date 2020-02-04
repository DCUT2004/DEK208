class DCIceSkaarj extends IceSkaarj;

var bool SummonedMonster;

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

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'DCIceSkaarj');
}

event PostBeginPlay()
{
	Super.PostBeginPlay();
	MyAmmo.ProjectileClass = class'DCIceSkaarjProjectile';
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
     AmmunitionClass=Class'DEKMonsters208.DCIceSkaarjAmmo'
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
     DodgeAnims(2)="DodgeR"
     DodgeAnims(3)="DodgeL"
}
