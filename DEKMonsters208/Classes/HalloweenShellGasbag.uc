class HalloweenShellGasbag extends ShellGasbag;


function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return (  P.class == class'DCBrute' || P.class == class'RedGreenBrute');
}

defaultproperties
{
     AmmunitionClass=Class'DEKMonsters208.HalloweenShellGasbagAmmo'
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
