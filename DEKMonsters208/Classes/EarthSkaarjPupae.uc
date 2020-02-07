class EarthSkaarjPupae extends DCPupae;

//var float IceBeamMultiplier, HeatDamageMultiplier;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield' || P.class == class'FireBrute' || P.Class == class'FireChildGasbag' || P.Class == class'FireChildSkaarjPupae' || P.Class == class'FireGasbag' || P.Class == class'FireGiantGasbag' || P.Class == class'FireKrall' || P.Class == class'FireLord' || P.Class == class'FireManta' || P.Class == class'FireMercenary' || P.Class == class'FireNali' || P.Class == class'FireNaliFighter' || P.Class == class'FireQueen' || P.Class == class'FireRazorfly' || P.Class == class'FireSkaarjPupae' || P.Class == class'FireSkaarjSniper' || P.Class == class'FireSkaarjSuperHeat' || P.Class == class'FireSlith' || P.Class == class'FireSlug' || P.Class == class'FireTitan');
	else
		return ( P.class == class'FireBrute' || P.Class == class'FireChildGasbag' || P.Class == class'FireChildSkaarjPupae' || P.Class == class'FireGasbag' || P.Class == class'FireGiantGasbag' || P.Class == class'FireKrall' || P.Class == class'FireLord' || P.Class == class'FireManta' || P.Class == class'FireMercenary' || P.Class == class'FireNali' || P.Class == class'FireNaliFighter' || P.Class == class'FireQueen' || P.Class == class'FireRazorfly' || P.Class == class'FireSkaarjPupae' || P.Class == class'FireSkaarjSniper' || P.Class == class'FireSkaarjSuperHeat' || P.Class == class'FireSlith' || P.Class == class'FireSlug' || P.Class == class'FireTitan');
}

function PostBeginPlay()
{
	
	default.Health *= class'ElementalConfigure'.default.EarthHealthMultiplier;
	default.HealthMax *= class'ElementalConfigure'.default.EarthHealthMultiplier;
	default.ScoringValue *= class'ElementalConfigure'.default.EarthScoreMultiplier
	default.GroundSpeed *= class'ElementalConfigure'.default.EarthGroundSpeedMultiplier;
	default.AirSpeed *= class'ElementalConfigure'.default.EarthAirSpeedMultiplier;
	default.WaterSpeed *= class'ElementalConfigure'.default.EarthWaterSpeedMultiplier;
	default.Mass *= class'ElementalConfigure'.default.EarthMassMultiplier;
	
	Super.PostBeginPlay();

}

//function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
//{
//	if (DamageType == class'DamTypeIceBeam' || DamageType == class'DamTypeFrostTrap' || DamageType == class'DamTypeIceBrute' || DamageType == class'DamTypeGasbag' || DamageType == class'DamTypeIceGiantGasbag' || DamageType == class'DamTypeIceKrall' || DamageType == class'DamTypeIceMercenary' || DamageType == class'DamTypeIceQueen' || DamageType == class'DamTypeIceSkaarjTrooper' || DamageType == class'DamTypeIceSkaarjFreezing' || DamageType == class'DamTypeIceSlith' || DamageType == class'DamTypeIceSlug' || DamageType == class'DamTypeIceTentacle' || DamageType == class'DamTypeIceTitan' || DamageType == class'DamTypeIceWarlord')
//	{
//		Damage *= IceBeamMultiplier;
//	}
//	if (DamageType == class'DamTypeFireBall' || DamageType == class'DamTypeDEKSolarTurretBeam' || DamageType == class'DamTypeDEKSolarTurretHeatWave' || DamageType == class'DamTypeWildfireTrap')
//	{
//		Damage *= HeatDamageMultiplier;
//	}
//	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damagetype);
//}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     //IceBeamMultiplier=1.500000
     //HeatDamageMultiplier=0.500000
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
