// BlastKrall - Krall firing yellow link primaries
class BlastKrall extends Krall;

var bool SummonedMonster;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	bSuperAggressive = (FRand() < 0.2);
	Instigator = self;
	CheckController();
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'BlastKrall' );
}

function CheckController()
{
	if (Instigator.ControllerClass == class'DEKFriendlyMonsterController')
		SummonedMonster = true;
	else
		SummonedMonster = false;
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
     AmmunitionClass=Class'DEKMonsters208.BlastKrallAmmo'
     ScoringValue=7
     Health=130
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
     Skins(0)=Texture'XEffectMat.goop.SlimeSkin'
     Skins(1)=Texture'XEffectMat.goop.SlimeSkin'
}
