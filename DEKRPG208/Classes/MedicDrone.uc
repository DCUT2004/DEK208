class MedicDrone extends Actor;

// stuff from Projectile that we can't use 'cos it makes it get destroyed by movers
var float Speed;


var Pawn DroneTarget;	//The player the drone is following, set by the artifact. Drone doesn't always belong to this guy, but it can.
var Pawn DroneMaster; //The player that spawns the drone with the ability(permanent), not the artifact(temporary). Drone belongs to this guy.
var int OrbitDist; // distance at which drone orbits when pawn's not moving

var xEmitter Trail;

var float curOsc; // oscillation counter

var int CircleSpeed; // orbital speed
var int OscHeight; // several times the actual weave height
var float OscInc; // increment of oscillation - rate of weaving
var vector toProt;


var int orbitHeight; // vertical offset from player's center - randomized when player has more than one

var MedicDroneActor M;
var config float TimeBetweenShots, XPPerHealing;
var config int HealthHealingLevel;
var config float HealthHealingAmount;


replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		curOsc,orbitHeight,M,DroneMaster,TimeBetweenShots,XPPerHealing;
	reliable if (Role == ROLE_Authority)
		DroneTarget,toProt;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	// randomize everything so drones behave a little bit differently
	if(Role==ROLE_Authority)
	{
		curOsc = FRand()*3.14159;
		orbitHeight = FRand()*95 - 40;
	}
	Trail = Spawn(class'MedicDroneTrail',self,,Location,Rotation);
	Trail.SetBase(self);
	Trail.LifeSpan = 9999;
	Velocity = vector(Rotation)*Speed;
	SetTimer(0.1,true);
	M=Spawn(class'MedicDroneActor',self);
	M.SetBase(self);
	XPPerHealing = M.XPPerHealing;
	TimeBetweenShots = M.TimeBetweenShots;
}

simulated function Timer()
{
	local float dist;
	local ArtifactRemoteMedicDrone ARMD;
	
	ARMD = ArtifactRemoteMedicDrone(DroneMaster.FindInventoryType(class'ArtifactRemoteMedicDrone'));
	if (ARMD != None)
	{
		if (ARMD.bDroneTargetSet)
			DroneTarget = ARMD.DroneTarget; //If there is a target set with the artifact, tell the Drone to follow it.
		else
			DroneTarget = DroneMaster; //Otherwise if no target set, follow the master spawner.
		if (DroneMaster != None && DroneTarget == None) //If sometime the target dies or leaves, return the Drone to the master spawner.
			DroneTarget = DroneMaster;
	}
	
	if (DroneTarget == None || DroneTarget.Health <= 0) //Same as above.
		DroneTarget = DroneMaster;
	
	if(DroneMaster == None || DroneMaster.Health <= 0) //If the master spawner is gone, destroy the drone.
		Destroy();
	else
	{
		//Movement
		curOsc += OscInc;
		toProt = (DroneTarget.Location+vect(0,0,1)*orbitHeight) - Location; //Always follow the target(which can be another person, or the Master).
		dist = VSize(toProt);
		Velocity = 0.1 * Velocity + 0.3 * ((Normal(toProt) cross vect(0,0,1)) * CircleSpeed) + 0.2 * cos(curOsc) * vect(0,0,1) * OscHeight + 0.4 * Normal(toProt) * Speed * (dist - OrbitDist)/OrbitDist;
		SetRotation(rotator(Velocity)+rotator(vect(1,0,0))+rotator(vect(0,1,0)));
	}
}

simulated function HitWall(vector HitNormal, actor Wall)
{
	// bounce off. this makes for some weirdness with the homing but it's not too bad
	Velocity = -(Velocity dot HitNormal) * HitNormal;
	SetRotation(rotator(Velocity));
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{

}

simulated function Destroyed()
{
	if(Trail != None)
		Trail.Destroy();
	if (M!=None)
		M.Destroy();
}

defaultproperties
{
     Speed=700.000000
     OrbitDist=64
     CircleSpeed=-420
     OscHeight=240
     OscInc=0.500000
     TimeBetweenShots=1.000000
     HealthHealingLevel=1
     HealthHealingAmount=1.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XGame_rc.BallMesh'
     bAlwaysRelevant=True
     bReplicateInstigator=True
     Physics=PHYS_Projectile
     RemoteRole=ROLE_SimulatedProxy
     DrawScale=1.500000
     Skins(0)=FinalBlend'D-E-K-HoloGramFX.NonWireframe.FunkyStuff_1'
     bUnlit=True
     bDisturbFluidSurface=True
     SoundVolume=255
     SoundRadius=50.000000
     CollisionRadius=20.000000
     CollisionHeight=20.000000
     bCollideActors=True
     bCollideWorld=True
     bUseCylinderCollision=True
     bBounce=True
     bFixedRotationDir=True
     RotationRate=(Yaw=24000)
     DesiredRotation=(Yaw=30000)
}
