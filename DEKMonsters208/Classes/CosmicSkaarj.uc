class CosmicSkaarj extends Skaarj;

var bool SummonedMonster;

function PostBeginPlay()
{
	Instigator = self;
	Super.PostBeginPlay();
	CheckController();
}

function CheckController()
{
	if (Instigator.ControllerClass == class'DEKFriendlyMonsterController')
		SummonedMonster = true;
	else
		SummonedMonster = false;
}

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.class == class'Monster' );
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
     FireSound=Sound'ONSBPSounds.Artillery.ShellIncoming1'
     AmmunitionClass=Class'DEKMonsters208.CosmicSkaarjAmmo'
     ScoringValue=9
     GibGroupClass=Class'DEKMonsters208.CosmicGibGroup'
     bCanFly=True
     GroundSpeed=500.000000
     AirSpeed=600.000000
     AccelRate=600.000000
     Health=90
     Skins(0)=Shader'DEKMonstersTexturesMaster206E.CosmicMonsters.CosmicSkaarj'
     Mass=100.000000
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
