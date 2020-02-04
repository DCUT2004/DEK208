class Drone extends Actor;

var Pawn protPawn; // owner pawn
var DroneActor D;

var float Speed;
var int OrbitDist; // distance at which drone orbits when pawn's not moving
var float curOsc; // oscillation counter
var int CircleSpeed; // orbital speed
var int OscHeight; // several times the actual weave height
var float OscInc; // increment of oscillation - rate of weaving
var config float TargetRadius;

var int orbitHeight; // vertical offset from player's center - randomized when player has more than one

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		curOsc,orbitHeight, protPawn;
	reliable if (Role == ROLE_Authority)
		D;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if(Role==ROLE_Authority)
	{
		curOsc = FRand()*3.14159;
		orbitHeight = FRand()*95 - 40;
	}
	Velocity = vector(Rotation)*Speed;
	SetTimer(0.1,true);
	D=Spawn(class'DroneActor',self);
	if (D != None)
	{
		D.SetBase(Self);
		D.Drone = Self;
		D.TargetRadius = TargetRadius;
	}
}

simulated function Timer()
{
	local vector toProt;
	local float dist;
	
	if (protPawn == None || protPawn.Health <= 0 || protPawn.IsA('Monster'))
	{
		Destroy();
	}
	else
	{
		//Movement
		curOsc += OscInc;
		toProt = (protPawn.Location+vect(0,0,1)*orbitHeight) - Location;
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

simulated function Landed( vector HitNormal )
{

}


simulated function Destroyed()
{
	if (D != None)
		D.Destroy();
	Super.Destroyed();
}

defaultproperties
{
	 TargetRadius=1500.00
     Speed=700.000000
     OrbitDist=64
     CircleSpeed=-420
     OscHeight=240
     OscInc=0.500000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XGame_rc.BallMesh'
     bAlwaysRelevant=True
     bReplicateInstigator=True
     Physics=PHYS_Projectile
     RemoteRole=ROLE_SimulatedProxy
     DrawScale=1.500000
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
