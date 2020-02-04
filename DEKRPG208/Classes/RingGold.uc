class RingGold extends DruidBlock;

var Pawn Spawner;
var config float TargetRadius;
var RingRed RR;
var RingBlue RB;
var bool Active;
var RingActiveFX FX;

#exec OBJ LOAD FILE=..\StaticMeshes\E_Pickups.usx

replication
{
	reliable if (Role == ROLE_Authority)
		Active;
}

simulated function PostBeginPlay()
{
	SetTimer(1, True);
	SetCollision(false,false,false);
	bCollideWorld = true;
	Active = False;
	Super.PostBeginPlay();
}

simulated function Timer()
{
	local MissionMultiplayerInv MMPI;
	
	MMPI = MissionMultiplayerInv(Spawner.FindInventoryType(class'MissionMultiplayerInv'));
	
	if (!CheckRadius() || !RR.CheckRadius() || !RB.CheckRadius())
		MMPI.MissionCount = 0;

	if (Spawner != None && MMPI != None && !MMPI.stopped && MMPI.Countdown <= 0 && MMPI.RingAndHoldActive)
	{
		if (CheckRadius() && RR.CheckRadius() && RB.CheckRadius())	
			MMPI.UpdateCounts(1);
	}
	if (Spawner == None || Spawner.Health <= 0)
	{
		if (RR != None)
			RR.Destroy();
		if (RB != None)
			RB.Destroy();
		Destroy();
	}
	SpawnEffect();
}

simulated function bool CheckRadius()
{
	local Pawn P;
	local float Dist;
	
	foreach VisibleCollidingActors(class'Pawn', P, TargetRadius, Self.Location)
	{
		if ( P == None)
			return False;
		if (P != None && P.Controller != None && P.Health > 0 && P.GetTeamNum() == GetTeamNum() && !P.IsA('Monster') && P.IsA('xPawn'))
		{
			Dist = VSize(P.Location - Self.Location);
			if (Dist <= TargetRadius && FastTrace(P.Location, Self.Location))
				return True;
			else
				return False;
			P = None;
		}
		else
		{
			return False;
			P = None;
		}
	}
}

simulated function SpawnEffect()
{	
	if (CheckRadius())
	{
		if (FX == None)
		{
			FX = Self.spawn(class'DEKRPG208.RingActiveFX', Self,,Self.Location);
			if (FX != None)
			{
				FX.SetCollision(False,False,False);
				FX.RemoteRole = ROLE_SimulatedProxy;
			}
		}
		else
			return;
	}
	else
	{
		if (FX != None)
		{
			FX.Destroy();
		}
		else
			return;
	}
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	return;
}

simulated function destroyed()
{
	if (FX != None)
		FX.Destroy();
	super.Destroyed();
}

defaultproperties
{
    bCanBeBaseForPawns=True
    bNoTeamBeacon=True
    ControllerClass=None
    DrawScale=4.250000
    CollisionRadius=40.000000
    CollisionHeight=40.000000
	StaticMesh=StaticMesh'E_Pickups.BombBall.BombRing'
	Skins(0)=Shader'XGameShaders.BRShaders.BombIconYS'
	TargetRadius=250.00
}
