class DCMercenary extends SMPMercenary;

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
		return ( P.class == class'DCMercenary');
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
     MyDamageType=Class'DEKMonsters208.DamTypeMercenaryAmmo'
     RocketAmmoClass=Class'DEKMonsters208.MercenaryRocketAmmo'
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
