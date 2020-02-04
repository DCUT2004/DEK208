class CosmicBrute extends Brute;

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
		return ( P.class == class'HealerNali');
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
     AmmunitionClass=Class'DEKMonsters208.CosmicBruteAmmo'
     ScoringValue=7
     GibGroupClass=Class'DEKMonsters208.CosmicGibGroup'
     bCanFly=True
     GroundSpeed=500.000000
     AirSpeed=600.000000
     AccelRate=600.000000
     Health=132
     Skins(0)=Shader'DEKMonstersTexturesMaster206E.CosmicMonsters.CosmicBrute'
     Skins(1)=Shader'DEKMonstersTexturesMaster206E.CosmicMonsters.CosmicBrute'
     Mass=100.000000
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
