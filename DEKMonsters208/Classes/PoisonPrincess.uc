class PoisonPrincess extends PoisonQueen;

//Princess can't spawn pupae
function SpawnChildren() {}

//No shield?
//function SpawnShield() {}

//No teleport?
//function Teleport() {}

defaultproperties
{
	 MaxChildren=0
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
