class GiantIceBunnyCharger extends Actor;

var xEmitter ChargeEmitter;
var float ChargeTime;
var float FreezeRadius;
var AvoidMarker Fear;
var Controller InstigatorController;
var float MaxFreezeTime;

function Freeze(float Radius)
{
	local float damageScale, dist;
	local vector dir;
	local Controller C, NextC;
	Local NullEntropyInv Inv;

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

			if(!C.Pawn.isA('Vehicle') && class'RW_Freeze'.static.canTriggerPhysics(C.Pawn) 
				&& (C.Pawn.FindInventoryType(class'NullEntropyInv') == None))
			{
				Inv = spawn(class'NullEntropyInv', C.Pawn,,, rot(0,0,0));
				if(Inv != None)
				{
					Inv.LifeSpan = (damageScale * MaxFreezeTime * 3);	
					Inv.Modifier = (damageScale * MaxFreezeTime * 3);	// *3 because the NullEntropyInv divides by 3
					Inv.GiveTo(C.Pawn);
				}
			}
		}

		C = NextC;
	}
}

simulated function PostBeginPlay()
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		ChargeEmitter = spawn(class'FreezeBombChargeEmitter');
	}

	if (Role == ROLE_Authority)
		InstigatorController = Controller(Owner);

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
	Fear.SetCollisionSize(FreezeRadius, 200);
	Fear.StartleBots();

	Sleep(ChargeTime);
	spawn(class'GiantIceBunnyChargerExplosion');
	bHidden = true; //for netplay - makes it irrelevant
	if (ChargeEmitter != None)
		ChargeEmitter.Destroy();
	MakeNoise(1.0);
	PlaySound(sound'WeaponSounds.redeemer_explosionsound');

	Freeze(FreezeRadius);

	if (Fear != None)
		Fear.Destroy();
	Destroy();
}

defaultproperties
{
     ChargeTime=3.000000
     FreezeRadius=1000.000000
     MaxFreezeTime=20.000000
     DrawType=DT_None
     TransientSoundVolume=1.000000
     TransientSoundRadius=5000.000000
}
