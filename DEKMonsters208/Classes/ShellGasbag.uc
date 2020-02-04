class ShellGasBag extends DCGasBag;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.class == class'ShellGasBag' );
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
     AmmunitionClass=Class'DEKMonsters208.ShellGasBagAmmo'
     AirSpeed=530.000000
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
     Skins(0)=Texture'DEKMonstersTexturesMaster206E.GenericMonsters.ShellGasBag1'
     Skins(1)=Texture'DEKMonstersTexturesMaster206E.GenericMonsters.ShellGasBag2'
}
