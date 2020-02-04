class GiantPoisonBunnyCharger extends Actor;

var xEmitter ChargeEmitter;
var AvoidMarker Fear;
var Controller InstigatorController;

var float ChargeTime;
var float MaxDrain;
var float MinDrain;
var float DrainTime;
var float DamageRadius;
var RPGRules RPGRules;

function DoDamage(float Radius)
{
	local float damageScale, dist;
	local vector dir;
	local Controller C, NextC;
	Local PoisonBlastInv Inv;

	if (Instigator == None && InstigatorController != None)
		Instigator = InstigatorController.Pawn;

	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;
		if ( C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) )
		{
			dir = C.Pawn.Location - Location;
			dist = FMax(1,VSize(dir));
			damageScale = 1 - FMax(0,dist/Radius);

			if(!C.Pawn.isA('Vehicle') && (C.Pawn.FindInventoryType(class'PoisonBlastInv') == None))
			{
				Inv = spawn(class'PoisonBlastInv', C.Pawn,,, rot(0,0,0));
				if(Inv != None)
				{
					Inv.LifeSpan = DrainTime;
					Inv.DrainAmount = MinDrain+(damageScale * (MaxDrain - MinDrain));
					Inv.RPGRules = RPGRules;
					Inv.GiveTo(C.Pawn);
				}
			}
		}

		C = NextC;
	}
}

simulated function PostBeginPlay()
{
	Local GameRules G;
	
	if (Level.NetMode != NM_DedicatedServer)
	{
		ChargeEmitter = spawn(class'PoisonBlastChargeEmitter');
	}

	if (Role == ROLE_Authority)
		InstigatorController = Controller(Owner);
		
	super.PostBeginPlay();
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

	Super.PostBeginPlay();
}

simulated function Destroyed()
{
	if (ChargeEmitter != None)
		ChargeEmitter.Destroy();

	Super.Destroyed();
}

auto state Charging
{
Begin:
	Fear = spawn(class'AvoidMarker');
	Fear.SetCollisionSize(DamageRadius, 200);
	Fear.StartleBots();

	Sleep(ChargeTime);
	spawn(class'GiantPoisonBunnyChargerExplosion');
	bHidden = true; //for netplay - makes it irrelevant
	if (ChargeEmitter != None)
		ChargeEmitter.Destroy();
	MakeNoise(1.0);
	PlaySound(sound'WeaponSounds.redeemer_explosionsound');
	DoDamage(DamageRadius);

	if (Fear != None)
		Fear.Destroy();
	Destroy();
}

defaultproperties
{
     ChargeTime=3.000000
     MaxDrain=50.000000
     MinDrain=30.000000
     DrainTime=5.000000
     DamageRadius=1000.000000
     DrawType=DT_None
     TransientSoundVolume=1.000000
     TransientSoundRadius=5000.000000
}
