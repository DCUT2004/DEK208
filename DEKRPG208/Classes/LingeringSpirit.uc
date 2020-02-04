class LingeringSpirit extends Actor
	config(UT2004RPG);

var LingeringSpiritFX FX;
var Controller Necromancer;
var RPGRules RPGRules;
var config float DrainInterval, DrainMultiplier;
var config int DrainAmount, DrainMin, DrainMax;
var config float SpiritRadius;
var config int DecayBonus;
var config float XPPerc;
var RPGStatsInv StatsInv;
var config float SpiritLifespan;

simulated function PostBeginPlay()
{
	Local GameRules G;
	
	if (Level.Game != None)
	{
		for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
		{
			if(G.isA('RPGRules'))
			{
				RPGRules = RPGRules(G);
				break;
			}
		}
	}

	if(RPGRules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
	FX = Self.Spawn(class'LingeringSpiritFX', Self,, Self.Location, Self.Rotation);
	if (FX != None)
		FX.SetBase(Self);
    SetTimer(DrainInterval, true);
	if (Invasion(Level.Game) == None)
	{
		Lifespan = default.SpiritLifespan;
	}
	Super.PostBeginPlay();
}

function Timer()
{
	local Controller C, NextC;
	local LifeDrainSoulParticle SFX;
	local LifeDrainSoulParticle SFX2;
	local vector FX2Radius;
	
	if (Necromancer != None)
	{
		if (Invasion(Level.Game) != None && Invasion(Level.Game).CheckMaxLives(Necromancer.PlayerReplicationInfo))
			Destroy();
		if (Instigator == None)
			Instigator = Necromancer.Pawn;
	}
	if (Necromancer == None || Necromancer != None && Necromancer.Pawn != None && PhantomDeathGhostInv(Necromancer.Pawn.FindInventoryType(class'PhantomDeathGhostInv')) == None)
		Destroy();
	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;
		
		//Is this just some sort of weird unreal script bug? Sometimes C is None
		if(C == None)
		{
			C = NextC;
			break;
		}
		if (C.Pawn != None && C.Pawn.Health > 0 && Necromancer != None && C != Necromancer && !C.SameTeamAs(Necromancer) && Vsize(C.Pawn.Location - Self.Location) <= SpiritRadius && FastTrace(C.Pawn.Location, Self.Location) && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !ClassIsChildOf(C.Pawn.Class, class'SMPNaliRabbit') && C.Pawn.DrivenVehicle == None)
		{
			// got it. Damage the targets
			if(C == None)
			{
				C = NextC;
				break;
			}
			C.Pawn.SetDelayedDamageInstigatorController(Necromancer);
			DrainAmount = max(min(DrainMultiplier * C.Pawn.HealthMax, DrainMax), DrainMin);
			if (DrainAmount < DrainMin)
				DrainAmount = DrainMin;
			if (DrainAMount > DrainMax)
				DrainAmount = DrainMax;
			C.Pawn.TakeDamage(DrainAmount, Instigator, C.Pawn.Location, vect(0,0,0), class'DamTypeLingeringSpirit');
			if(C == None)
			{
				C = NextC;
				break;
			}
			if (RPGRules != None && Necromancer.Pawn == None)
				RPGRules.AwardEXPForDamage(Necromancer, StatsInv, C.Pawn, DrainAmount*default.XPPerc);
			
			//Do the effects.
			if(C == None)
			{
				C = NextC;
				break;
			}
			FX2Radius.X=C.Pawn.Location.X+-5+FRand();
			FX2Radius.Y=C.Pawn.Location.Y+-5+FRand();
			FX2Radius.Z=C.Pawn.Location.Z+-5+FRand();
			SFX = Spawn(class'LifeDrainSoulParticle',,,C.Pawn.Location,Rotation);
			SFX.Seeking = Self;
			SFX2 = Spawn(class'LifeDrainSoulParticle',,,FX2Radius,Rotation);
			SFX2.Seeking = Self;
		}
		C = NextC;
	}
}

simulated function Destroyed()
{
	if (FX != None)
		FX.Destroy();
	Super.Destroyed();
}

defaultproperties
{
	 XPPerc=0.3000
	 SpiritLifespan=30.0000
	 DecayBonus=50
     DrainInterval=1.000000
     DrainMultiplier=0.030000
     DrainMin=10
     DrainMax=20
	 SpiritRadius=800.00
     DrawType=DT_Sprite
     Texture=Texture'XEffects.Shark.PainterDecalMark'
     DrawScale=1.000000
	 LightHue=0
	 LightSaturation=0
	 bDynamicLight=True
}
