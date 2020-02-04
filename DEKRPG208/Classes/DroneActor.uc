class DroneActor extends Actor;

var MutUT2004RPG RPGMut;
var RPGStatsInv StatsInv;
var config float TimeBetweenShots;
var Drone Drone;
var float TargetRadius;
var int TargetDelay, TargetCounter;
var Pawn targetPawn;

var int ShotDelay, ShootCounter;
var int TrailCounter;
var config int TrailThreshold;

var xEmitter Trail, DoubleTrail;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		Drone;
	reliable if (Role == ROLE_Authority)
		targetPawn;
}

simulated function PostBeginPlay()
{
	local Mutator m;
	
	Super.PostBeginPlay();
	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
	shootCounter = FRand()*ShotDelay;
	targetCounter = FRand()*TargetDelay;
    SetTimer(TimeBetweenShots, true);
	TrailCounter = 0;
}

function Timer()
{
	local Monster cTarget;
	local int protTeam;
	local DroneProj dp;
	local DroneDoubleProj DDP;
	
	if (Drone == None || Drone.protPawn == None || Drone.protPawn.Health <= 0)
		Destroy();
	
	//Targeting
	if(targetCounter>=TargetDelay && Drone.protPawn.Health>0)
	{
		protTeam = Drone.protPawn.GetTeamNum();
		targetPawn = None;
		foreach VisibleCollidingActors(class'Monster',cTarget,TargetRadius)
		{
			if(cTarget != None && cTarget.Controller != None && cTarget != Drone.protPawn && cTarget.Health>0 && !cTarget.Controller.SameTeamAs(Drone.protPawn.Controller) && cTarget.ControllerClass != class'DEKFriendlyMonsterController' && !cTarget.IsA('HealerNali') && !cTarget.IsA('MissionCow') && !ClassIsChildOf(cTarget.Class, class'SMPNaliRabbit'))
			{
				if(VSize(cTarget.Location-Drone.protPawn.Location) < TargetRadius && FastTrace(cTarget.Location, Drone.protPawn.Location))
					targetPawn=cTarget;
			}
		}
				
		targetCounter=0;
	}
	targetCounter++;
			
	//Shooting
	if(shootCounter>=ShotDelay)
	{
		if(targetPawn!=None)
		{
			// omg shoot at it
			if (Drone.protPawn.HasUDamage())
			{
				DDP = Spawn(class'DroneDoubleProj',Drone.protPawn,,Location + Normal(targetPawn.Location - Location)*32,rotator(targetPawn.Location-Location));
				if(DDP != None)
				{
					// set projectile instigator so owner gets kill credit
					DDP.Instigator = Drone.protPawn;
					PlaySound(Sound'DEKRPG208.TurretSounds.PlasmaTurretFire');
				}
			}
			else
			{
				dp = Spawn(class'DroneProj',Drone.protPawn,,Location + Normal(targetPawn.Location-Location)*32,rotator(targetPawn.Location-Location));
				if(dp != None)
				{
					// set projectile instigator so owner gets kill credit
					dp.Instigator = Drone.protPawn;
					PlaySound(Sound'WeaponSounds.LinkGun.BLinkedFire');
				}
			}
		}
		shootCounter=0;
	}
	shootCounter++;
			
	if(TrailCounter>=TrailThreshold)
	{
		if (Drone.protPawn.HasUDamage())
		{
			if (Trail != None)
				Trail.Destroy();
			DoubleTrail = Spawn(class'DroneDoubleTrail',Drone,,Drone.Location,Drone.Rotation);
			DoubleTrail.SetBase(Drone);
			DoubleTrail.LifeSpan = 4.000000;
		}
		else
		{
			if (DoubleTrail != None)
				DoubleTrail.Destroy();
			Trail = Spawn(class'DroneTrail',Drone,,Drone.Location,Drone.Rotation);
			Trail.SetBase(Drone);
			Trail.LifeSpan = 4.00000000;
		}
		TrailCounter=0;
	}
	TrailCounter++;
}

simulated function Destroyed()
{
	if(Trail != None)
		Trail.Destroy();
	if (DoubleTrail != None)
		DoubleTrail.Destroy();
	Super.Destroyed();
}

defaultproperties
{
     TimeBetweenShots=0.100000
     TargetRadius=1500.000000
     TargetDelay=15
     ShotDelay=6
     TrailThreshold=10
     DrawType=DT_None
     bHidden=True
     Physics=PHYS_Trailer
}
