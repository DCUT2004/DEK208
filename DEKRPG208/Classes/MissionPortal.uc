class MissionPortal extends Actor;

var Pawn Spawner;
var int XPPerScore;
var RPGRules Rules;
var RPGStatsInv StatsInv;
var MutUT2004RPG RPGMut;
var MissionPortalFX FX;

#exec  AUDIO IMPORT NAME="PortalBallScore" FILE="C:\UT2004\Sounds\PortalBallScore.WAV" GROUP="MissionSounds"

replication
{
	reliable if (Role == ROLE_Authority)
		Spawner;
}

simulated function PostBeginPlay()
{
	local Mutator m;

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
	CheckRPGRules();
	FX = Spawn(class'MissionPortalFX',,,Self.Location);
	if (FX != None)
	{
		FX.SetBase(Self);
		FX.RemoteRole = ROLE_SimulatedProxy;
	}
	SetTimer(1, True);
	Super.PostBeginPlay();
}

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}
	}

	if(Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

function Touch(Actor Other)
{
    local MissionPortalBall Ball;
    //local MissionPortalBallRed Red;
    //local MissionPortalBallOrange Orange;
    //local MissionPortalBallGreen Green;
    //local MissionPortalBallBlue Blue;
    //local MissionPortalBallPurple Purple;
    //local MissionPortalBallPink Pink;
	local MissionMultiplayerInv MMPI;
	local MissionPortalBallSpawnerInv SpawnerInv;
	local Controller C, NextC;
	local Pawn P;
	local Actor A;

    //Red = MissionPortalBallRed(Other);
    //Orange = MissionPortalBallOrange(Other);
    //Green = MissionPortalBallGreen(Other);
    //Blue = MissionPortalBallBlue(Other);
    //Purple = MissionPortalBallPurple(Other);
    //Pink = MissionPortalBallPink(Other);
	if (Spawner != None && Spawner.Health > 0)
		SpawnerInv = MissionPortalBallSpawnerInv(Spawner.FindInventoryType(class'MissionPortalBallSpawnerInv'));

    if (Other != None && Spawner != None && Spawner.Health > 0)
	{
		if (ClassIsChildOf(Other.Class, class'MissionPortalBall'))
		{
			Ball = MissionPortalBall(Other);
			if (Ball != None)
			{
				MMPI = MissionMultiplayerInv(Spawner.FindInventoryType(class'MissionMultiplayerInv'));
				if (MMPI != None)
				{
					MMPI.UpdateCounts(1);	//GGGGGGOOOOOOAAAAAAAAAAAAALLLLLLLLL!!!
					C = Level.ControllerList;
					while (C != None)
					{
						NextC = C.NextController;
						if(C == None)
						{
							C = NextC;
							break;
						}
				
						if (C != None && C.Pawn != None && C.Pawn.Health > 0)
						{
							P = C.Pawn;
							if(P != None && P.isA('Vehicle'))
								P = Vehicle(P).Driver;
							if (P != None && P.Health > 0 && !P.IsA('Monster') && (P.GetTeam() == Spawner.GetTeam() && Spawner.GetTeam() != None) )
							{			
								if (Rules != None)
								{
									Rules.ShareExperience(RPGStatsInv(P.FindInventoryType(class'RPGStatsInv')), XPPerScore);
								}
							}
						}
						C = NextC;
					}
				}
				Self.PlaySound(Sound'DEKRPG208.MissionSounds.PortalBallScore',,100.0);
				A = Spawn(class'MissionPortalBallScoreFX');
				if (A != None)
					A.RemoteRole = ROLE_SimulatedProxy;
				Ball.Destroy();
				SpawnerInv.PortalBallCount--;
				if (SpawnerInv.PortalBallCount < 0)
					SpawnerInv.PortalBallCount = 0;
			}
		}
	}
}

simulated function Timer()
{
	local MissionMultiplayerInv MMPI;
	
	if (Spawner != None && Spawner.Health > 0)
	{
		MMPI = MissionMultiplayerInv(Spawner.FindInventoryType(class'MissionMultiplayerInv'));
		if (MMPI != None)
		{
			if (MMPI.Stopped || !MMPI.PortalBallActive || !MMPI.MasterMMPI)
				Destroy();
		}
	}
	else
		Destroy();
}

simulated function Destroyed()
{
	if (FX != None)
		FX.Destroy();
	Super.Destroyed();
}
defaultproperties
{
	 bCanBeDamaged=False
	 Mass=2000.00
	 bIgnoreVehicles=True
	 Physics=PHYS_Falling
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XGame_StaticMeshes.GameObjects.BombGateCol'
	 Skins(0)=FinalBlend'XEffectMat.Shield.BlueShell'
     bStatic=False
     bHidden=False
     CollisionRadius=60.000000
     CollisionHeight=60.000000
     bCollideActors=True
	 bCollideWorld=True
	 bDynamicLight=True
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=135
     LightSaturation=0
     LightBrightness=255.000000
     LightRadius=15.000000
}
