class EarthManta extends DCManta;

var config float IceDamageMultiplier, FireDamageMultiplier;
var config float HealInterval, HealRadius;
var config int HealAmount;

//function bool SameSpeciesAs(Pawn P)
//{
//	if (SummonedMonster)
//		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield' || P.class == class'EarthBrute' || P.Class == class'EarthChildGasbag' || P.Class == class'EarthChildSkaarjPupae' || P.Class == class'EarthGasbag' || P.Class == class'EarthGiantGasbag' || P.Class == class'EarthKrall' || P.Class == class'EarthLord' || P.Class == class'EarthManta' || P.Class == class'EarthMercenary' || P.Class == class'EarthNali' || P.Class == class'EarthNaliFighter' || P.Class == class'EarthQueen' || P.Class == class'EarthRazorfly' || P.Class == class'EarthSkaarjPupae' || P.Class == class'EarthSkaarjSniper' || P.Class == class'EarthSkaarjSuperHeat' || P.Class == class'EarthSlith' || P.Class == class'EarthSlug' || P.Class == class'EarthTitan');
//	else
//		return ( P.class == class'EarthBrute' || P.Class == class'EarthChildGasbag' || P.Class == class'EarthChildSkaarjPupae' || P.Class == class'EarthGasbag' || P.Class == class'EarthGiantGasbag' || P.Class == class'EarthKrall' || P.Class == class'EarthLord' || P.Class == class'EarthManta' || P.Class == class'EarthMercenary' || P.Class == class'EarthNali' || P.Class == class'EarthNaliFighter' || P.Class == class'EarthQueen' || P.Class == class'EarthRazorfly' || P.Class == class'EarthSkaarjPupae' || P.Class == class'EarthSkaarjSniper' || P.Class == class'EarthSkaarjSuperHeat' || P.Class == class'EarthSlith' || P.Class == class'EarthSlug' || P.Class == class'EarthTitan');
//}

function PostBeginPlay()
{
	Health *= class'ElementalConfigure'.default.EarthHealthMultiplier;
	HealthMax *= class'ElementalConfigure'.default.EarthHealthMultiplier;
	ScoringValue *= class'ElementalConfigure'.default.EarthScoreMultiplier;
	GroundSpeed *= class'ElementalConfigure'.default.EarthGroundSpeedMultiplier;
	AirSpeed *= class'ElementalConfigure'.default.EarthAirSpeedMultiplier;
	WaterSpeed *= class'ElementalConfigure'.default.EarthWaterSpeedMultiplier;
	Mass *= class'ElementalConfigure'.default.EarthMassMultiplier;
	//Other.SetLocation(Other.Location+vect(0,0,1)*(Other.CollisionHeight*bigger/2));
	SetDrawScale(Drawscale*class'ElementalConfigure'.default.EarthDrawscaleMultiplier);
	SetCollisionSize(CollisionRadius*class'ElementalConfigure'.default.EarthDrawscaleMultiplier, default.CollisionHeight*class'ElementalConfigure'.default.EarthDrawscaleMultiplier);
	
	SetTimer(HealInterval, True);
	
	Super.PostBeginPlay();

}

simulated function Timer()
{
	Heal();
}

simulated function Heal()
{
	local Controller C;
	
	C = Level.ControllerList;	
	while (C != None)
	{
		if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn.Health < C.Pawn.HealthMax && C.Pawn != Self && ClassIsChildOf(C.Pawn.Class, class'Monster') && C.SameTeamAs(Instigator.Controller)
		&& VSize(C.Pawn.Location - Self.Location) <= HealRadius && FastTrace(C.Pawn.Location, Self.Location))
		{
			if (!C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow'))
			{
				C.Pawn.GiveHealth(HealAmount, C.Pawn.default.HealthMax);
				Log("Healing - EarthManta");
			}
		}
		C = C.NextController;
	}
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	if (DamageType == class'DamTypeIceBeam' || DamageType == class'DamTypeFrostTrap' || DamageType == class'DamTypeIceBrute' || DamageType == class'DamTypeGasbag' || DamageType == class'DamTypeIceGiantGasbag' || DamageType == class'DamTypeIceKrall' || DamageType == class'DamTypeIceMercenary' || DamageType == class'DamTypeIceQueen' || DamageType == class'DamTypeIceSkaarjTrooper' || DamageType == class'DamTypeIceSkaarjFreezing' || DamageType == class'DamTypeIceSlith' || DamageType == class'DamTypeIceSlug' || DamageType == class'DamTypeIceTentacle' || DamageType == class'DamTypeIceTitan' || DamageType == class'DamTypeIceWarlord')
	{
		Damage *= IceDamageMultiplier;
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
	HealAmount=5
	HealInterval=1.00
	HealRadius=800.00
	IceDamageMultiplier=1.500000
	FireDamageMultiplier=0.500000
	ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
