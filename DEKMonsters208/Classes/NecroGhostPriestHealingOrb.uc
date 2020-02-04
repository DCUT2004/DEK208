class NecroGhostPriestHealingOrb extends UntargetedProjectile
	config(satoreMonsterPack);

var class<Emitter> OrbEffectClass;
var Emitter OrbEffect;
var config float HealInterval, OrbHealRadius;
var config int HealAmount;
var vector initialDir;

#exec obj load file=GeneralAmbience.uax

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
	
	if (Level.NetMode != NM_DedicatedServer)
	{
		OrbEffect = Spawn(OrbEffectClass, Self);
		OrbEffect.SetBase(Self);
	}
	Velocity = Vector(Rotation) * Speed;
	SetTimer(HealInterval, true);
}

simulated function PostNetBeginPlay() 
  {
  	SetTimer(HealInterval, true);
  	Super.PostNetBeginPlay();
}

simulated function Timer() 
{
	Heal();
	OrbEffect = Spawn(OrbEffectClass, Self);
	OrbEffect.SetBase(Self);
}

simulated function Heal()
{
	local Controller C;
	local FriendlyMonsterInv FInv;
	local NecroGhostPriestHealingMarker HealMarker;
	
	C = Level.ControllerList;	
	while (C != None)
	{
		if ( C != None && C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && C.Pawn.IsA('Monster')
		&& VSize(C.Pawn.Location - Location) < OrbHealRadius)
		{
			if (!C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('NecroGhostPriest') && !C.Pawn.IsA('MissionCow'))
			{
				FInv = FriendlyMonsterInv(C.Pawn.FindInventoryType(class'FriendlyMonsterInv'));
				if (FInv == None)
				{
					C.Pawn.GiveHealth(HealAmount, C.Pawn.default.Health);
				}
			}
		}
		C = C.NextController;
	}
	
	if (C != None && C.Pawn != None && C.Pawn.Health > 0 && VSize(C.Pawn.Location - Location) < OrbHealRadius)
	{
		HealMarker = Spawn(class'NecroGhostPriestHealingMarker',C.Pawn,,C.Pawn.Location,C.Pawn.Rotation);
		if (HealMarker != None)
		{
			HealMarker.SetBase(C.Pawn);
			HealMarker.RemoteRole = ROLE_SimulatedProxy;
		}
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
 //do nothing.
}

simulated function DestroyTrails()
{
	if (OrbEffect != None)
		OrbEffect.Destroy();
}

simulated function Destroyed()
{
	if (OrbEffect != None)
	{
		if (bNoFX)
			OrbEffect.Destroy();
		else
			OrbEffect.Kill();
	}
	Super.Destroyed();
}

defaultproperties
{
     OrbEffectClass=Class'DEKMonsters208.NecroGhostPriestHealingOrbEffect'
     HealInterval=1.000000
     OrbHealRadius=900.000000
     HealAmount=10
     MaxSpeed=0.000000
     DrawType=DT_None
     Physics=PHYS_Flying
     AmbientSound=Sound'GeneralAmbience.texture32'
     LifeSpan=15.000000
     bFullVolume=True
     SoundVolume=232
     SoundRadius=900.000000
     TransientSoundVolume=1000.000000
}
