class MutElementalConfigure extends Mutator
    config(satoreMonsterPack);

var config Array<class<Monster>> EarthMonsters, FireMonsters, IceMonsters;

var config float EarthHealthMultiplier;
var config float EarthScoreMultiplier;
var config float EarthMassMultiplier;
var config float EarthDrawscaleMultiplier;
var config float EarthGroundSpeedMultiplier;
var config float EarthAirSpeedMultiplier;
var config float EarthWaterSpeedMultiplier;

var config float FireHealthMultiplier;
var config float FireScoreMultiplier;
var config float FireMassMultiplier;
var config float FireDrawscaleMultiplier;
var config float FireGroundSpeedMultiplier;
var config float FireAirSpeedMultiplier;
var config float FireWaterSpeedMultiplier;

var config float IceHealthMultiplier;
var config float IceScoreMultiplier;
var config float IceMassMultiplier;
var config float IceDrawscaleMultiplier;
var config float IceGroundSpeedMultiplier;
var config float IceAirSpeedMultiplier;
var config float IceWaterSpeedMultiplier;

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	local int x;
	local Monster M;
	local bool bEarth, bFire, bIce;
	
	if (Other.IsA('Monster'))
	{
		M = Monster(Other);
		for (x = 0; x < EarthMonsters.Length; x++)
		{
			bEarth = False;
			if (M.Class == EarthMonsters[x] && !bEarth)
			{
				M.default.Health *= EarthHealthMultiplier;
				M.default.HealthMax *= EarthHealthMultiplier;
				M.default.ScoringValue *= EarthScoreMultiplier;
				M.default.GroundSpeed *= EarthGroundSpeedMultiplier;
				M.default.AirSpeed *= EarthAirSpeedMultiplier;
				M.default.WaterSpeed *= EarthWaterSpeedMultiplier;
				M.default.Mass *= EarthMassMultiplier;
				M.default.DrawScale *= EarthDrawscaleMultiplier;
				M.default.CollisionHeight *= EarthDrawscaleMultiplier;
				M.default.CollisionRadius *= EarthDrawscaleMultiplier;
				M.bDynamicLight = True;
				M.LightHue=90;	//so I know this works
				M.LightSaturation=100;	//so I know this works
				M.LightRadius=8.00;	//so I know this works
				bEarth = True;
			}
			if (bEarth)
				break;
		}
		if (!bEarth)
		{
			for (x = 0; x < FireMonsters.Length; x++)
			{
				bFire = False;
				if (M.Class == FireMonsters[x] && !bFire)
				{
					M.default.Health *= FireHealthMultiplier;
					M.default.HealthMax *= FireHealthMultiplier;
					M.default.ScoringValue *= FireScoreMultiplier;
					M.default.GroundSpeed *= FireGroundSpeedMultiplier;
					M.default.AirSpeed *= FireAirSpeedMultiplier;
					M.default.WaterSpeed *= FireWaterSpeedMultiplier;
					M.default.Mass *= FireMassMultiplier;
					M.default.DrawScale *= FireDrawscaleMultiplier;
					M.default.CollisionHeight *= FireDrawscaleMultiplier;
					M.default.CollisionRadius *= FireDrawscaleMultiplier;
					M.LightHue=30;	//so I know this works
					M.LightSaturation=100;	//so I know this works
					M.LightRadius=8.00;	//so I know this works
					bFire = True;
				}
			}
			if (bFire)
				break;
		}
		if (!bEarth && !bFire)
		{
			for (x = 0; x < IceMonsters.Length; x++)
			{
				bIce = False;
				if (M.Class == IceMonsters[x] && !bIce)
				{
					M.default.Health *= IceHealthMultiplier;
					M.default.HealthMax *= IceHealthMultiplier;
					M.default.ScoringValue *= IceScoreMultiplier;
					M.default.GroundSpeed *= IceGroundSpeedMultiplier;
					M.default.AirSpeed *= IceAirSpeedMultiplier;
					M.default.WaterSpeed *= IceWaterSpeedMultiplier;
					M.default.Mass *= IceMassMultiplier;
					M.default.DrawScale *= IceDrawscaleMultiplier;
					M.default.CollisionHeight *= IceDrawscaleMultiplier;
					M.default.CollisionRadius *= IceDrawscaleMultiplier;
					M.LightHue=210;	//so I know this works
					M.LightSaturation=100;	//so I know this works
					M.LightRadius=8.00;	//so I know this works
					bIce = True;
				}
			}
			if (bIce)
				break;
		}
	}
	return true;	//only call true when everything is finished
}

defaultproperties
{
	EarthHealthMultiplier=3.70
	EarthScoreMultiplier=2.35
	EarthMassMultiplier=2.75
	EarthDrawscaleMultiplier=1.35
	EarthGroundSpeedMultiplier=0.55
	EarthAirSpeedMultiplier=0.55
	EarthWaterSpeedMultiplier=0.55
	FireHealthMultiplier=3.00
	FireScoreMultiplier=2.00
	FireMassMultiplier=0.75
	FireDrawscaleMultiplier=1.00
	FireGroundSpeedMultiplier=1.10
	FireAirSpeedMultiplier=1.10
	FireWaterSpeedMultiplier=1.10
	IceHealthMultiplier=2.00
	IceScoreMultiplier=2.00
	IceMassMultiplier=1.50
	IceDrawscaleMultiplier=1.00
	IceGroundSpeedMultiplier=0.70
	IceAirSpeedMultiplier=0.70
	IceWaterSpeedMultiplier=0.70
	EarthMonsters(0)=class'DEKMonsters208.EarthSkaarjPupae'
	EarthMonsters(1)=Class'DEKMonsters208.EarthRazorfly'
	EarthMonsters(2)=Class'DEKMonsters208.EarthManta'
	FireMonsters(0)=class'DEKMonsters208.FireSkaarjPupae'
	FireMonsters(1)=class'DEKMonsters208.FireRazorfly'
	FireMonsters(2)=class'DEKMonsters208.FireManta'
	IceMonsters(0)=class'DEKMonsters208.IceSkaarjPupae'
	IceMonsters(1)=class'DEKMonsters208.IceRazorfly'
	IceMonsters(2)=class'DEKMonsters208.IceManta'
	GroupName="ElementalConfigure"
	FriendlyName="Elemental Monster Configuration"
	Description="Adjusts health, size, scoring, mass, and speed values for Ice, Fire, and Earth monsters."
}
