class EarthSkaarjPupae extends DCPupae;

var float IceDamageMultiplier, FireDamageMultiplier;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield' || P.class == class'EarthBrute' || P.Class == class'EarthChildGasbag' || P.Class == class'EarthChildSkaarjPupae' || P.Class == class'EarthGasbag' || P.Class == class'EarthGiantGasbag' || P.Class == class'EarthKrall' || P.Class == class'EarthLord' || P.Class == class'EarthManta' || P.Class == class'EarthMercenary' || P.Class == class'EarthNali' || P.Class == class'EarthNaliFighter' || P.Class == class'EarthQueen' || P.Class == class'EarthRazorfly' || P.Class == class'EarthSkaarjPupae' || P.Class == class'EarthSkaarjSniper' || P.Class == class'EarthSkaarjSuperHeat' || P.Class == class'EarthSlith' || P.Class == class'EarthSlug' || P.Class == class'EarthTitan');
	else
		return ( P.class == class'EarthBrute' || P.Class == class'EarthChildGasbag' || P.Class == class'EarthChildSkaarjPupae' || P.Class == class'EarthGasbag' || P.Class == class'EarthGiantGasbag' || P.Class == class'EarthKrall' || P.Class == class'EarthLord' || P.Class == class'EarthManta' || P.Class == class'EarthMercenary' || P.Class == class'EarthNali' || P.Class == class'EarthNaliFighter' || P.Class == class'EarthQueen' || P.Class == class'EarthRazorfly' || P.Class == class'EarthSkaarjPupae' || P.Class == class'EarthSkaarjSniper' || P.Class == class'EarthSkaarjSuperHeat' || P.Class == class'EarthSlith' || P.Class == class'EarthSlug' || P.Class == class'EarthTitan');
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

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	if (DamageType == class'DamTypeIceBeam' || DamageType == class'DamTypeFrostTrap' || DamageType == class'DamTypeIceBrute' || DamageType == class'DamTypeGasbag' || DamageType == class'DamTypeIceGiantGasbag' || DamageType == class'DamTypeIceKrall' || DamageType == class'DamTypeIceMercenary' || DamageType == class'DamTypeIceQueen' || DamageType == class'DamTypeIceSkaarjTrooper' || DamageType == class'DamTypeIceSkaarjFreezing' || DamageType == class'DamTypeIceSlith' || DamageType == class'DamTypeIceSlug' || DamageType == class'DamTypeIceTentacle' || DamageType == class'DamTypeIceTitan' || DamageType == class'DamTypeIceWarlord')
	{
		Damage *= IceBeamMultiplier;
	}
	if (DamageType == class'DamTypeFireBall' || DamageType == class'DamTypeDEKSolarTurretBeam' || DamageType == class'DamTypeDEKSolarTurretHeatWave' || DamageType == class'DamTypeWildfireTrap')
	{
		Damage *= FireDamageMultiplier;
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
     IceDamageMultiplier=1.500000
     FireDamageMultiplier=0.500000
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
