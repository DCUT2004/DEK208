//=============================================================================
// DEKGold. 3x HP, 0.7x Speed, 1.25x Score, 1.5x Mass
//=============================================================================
class DEKGoldGasBag extends DCGasBag;

var config float HeatDamageMultiplier;

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int Damage )
{
	RefNormal=normal(HitLocation-Location);
	if(Frand()>0.2)
		return true;
	else
		return false;
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	if (DamageType == class'SMPDamTypeTitanRock' || DamageType == class'DamTypeTitanRock' || DamageType == class'DamTypeTechTitanRock' || DamageType == class'DamTypeIceTitan' || DamageType == class'DamTypeFruitCakeTitanRock' || DamageType == class'DamTypePumpkinTitan')
	{
		return;
		Momentum = vect(0,0,0);
	}
	else if (DamageType == class'DamTypeFireBall' || DamageType == class'DamTypeDEKSolarTurretBeam' || DamageType == class'DamTypeDEKSolarTurretHeatWave' || DamageType == class'DamTypeWildfireTrap' || DamageType == class'DamTypeFireBrute' || DamageType == class'DamTypeFireGasbag' || DamageType == class'DamTypeFireGiantGasbag' || DamageType == class'DamTypeFireKrall' || DamageType == class'DamTypeFireLord' || DamageType == class'DamTypeFireMercenary' || DamageType == class'DamTypeFireQueen' || DamageType == class'DamTypeFireSkaarjSuperHeat' || DamageType == class'DamTypeFireSkaarjTrooper' || DamageType == class'DamTypeFireSlith' || DamageType == class'DamTypeFireSlug' || DamageType == class'DamTypeFireTentacle' || DamageType == class'DamTypeFireTitan' || DamageType == class'DamTypeFireTitanSuperHeat')
	{
		Damage *= HeatDamageMultiplier;
	}
	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damagetype);
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
     HeatDamageMultiplier=1.150000
     ScoringValue=9
     GibGroupClass=Class'DEKMonsters208.DEKGoldGibGroup'
     AirSpeed=231.000000
     Health=450
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.GoldMonsters.GoldMonFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster206E.GoldMonsters.GoldMonFB'
     Mass=180.000000
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
