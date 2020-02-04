//=============================================================================
// DEK Fire. 3x HP, 1.1x Speed, 2.0x Score, 0.75x Mass
//=============================================================================

class FireNali extends DCNali;

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     ScoringValue=2
     GibGroupClass=Class'DEKMonsters208.FireGibGroup'
     Health=125
     Skins(0)=Shader'DEKMonstersTexturesMaster206E.FireMonsters.FireNaliShader'
     Skins(1)=Shader'DEKMonstersTexturesMaster206E.FireMonsters.FireNaliShader'
}
