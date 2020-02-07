class EarthRazorfly extends DCRazorfly;

var config float IceDamageMultiplier, FireDamageMultiplier;
var config float HealInterval, HealRadius;
var config int HealAmount;

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
	default.ScoringValue *= class'ElementalConfigure'.default.EarthScoreMultiplier;
	default.GroundSpeed *= class'ElementalConfigure'.default.EarthGroundSpeedMultiplier;
	default.AirSpeed *= class'ElementalConfigure'.default.EarthAirSpeedMultiplier;
	default.WaterSpeed *= class'ElementalConfigure'.default.EarthWaterSpeedMultiplier;
	default.Mass *= class'ElementalConfigure'.default.EarthMassMultiplier;
	default.DrawScale *= class'ElementalConfigure'.default.EarthDrawscaleMultiplier;
	default.CollisionHeight *= class'ElementalConfigure'.default.EarthDrawscaleMultiplier;
	default.CollisionRadius *= class'ElementalConfigure'.default.EarthDrawscaleMultiplier;
	
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
	local FriendlyMonsterInv FInv;
	
	C = Level.ControllerList;	
	while (C != None)
	{
		if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn != Instigator && C.Pawn.IsA('Monster') && C.SameTeamAs(Instigator.Controller)
		&& VSize(C.Pawn.Location - Location) < HealRadius && FastTrace(C.Pawn.Location, Instigator.Location))
		{
			if (!C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow'))
			{
				FInv = FriendlyMonsterInv(C.Pawn.FindInventoryType(class'FriendlyMonsterInv'));
				if (FInv == None)
				{
					C.Pawn.GiveHealth(HealAmount, C.Pawn.default.HealthMax);
					C.Pawn.PlayOwnedSound(Sound'PickupSounds.HealthPack', SLOT_None, C.Pawn.TransientSoundVolume*0.75);	//Just so I know this is really working
				}
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
