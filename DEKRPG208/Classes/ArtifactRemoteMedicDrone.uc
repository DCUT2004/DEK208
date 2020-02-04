class ArtifactRemoteMedicDrone extends EnhancedRPGArtifact
		config(UT2004RPG);

var int DroneCount, MaxDroneNum;
var config float TargetRange;
var bool bDroneTargetSet;
var Pawn DroneTarget;

replication
{
	reliable if (Role == ROLE_Authority)
		DroneTarget,bDroneTargetSet;
}

function BotConsider()
{
	if ( !bActive && NoArtifactsActive() && FRand() < 0.3 && BotFireBeam())
		Activate();
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');
}

function bool BotFireBeam()
{
	local Vector FaceDir;
	local Vector BeamEndLocation;
	local Vector StartTrace;
	local vector HitLocation;
	local vector HitNormal;
	local Pawn  HitPawn;
	local Actor AHit;

	FaceDir = Vector(Instigator.Controller.GetViewRotation());
	StartTrace = Instigator.Location + Instigator.EyePosition();
	BeamEndLocation = StartTrace + (FaceDir * TargetRange);

	AHit = Trace(HitLocation, HitNormal, BeamEndLocation, StartTrace, true);
	if ((AHit == None) || (Pawn(AHit) == None) || (Pawn(AHit).Controller == None))
		return false;

	HitPawn = Pawn(AHit);
	if ( HitPawn != Instigator && HitPawn.Health > 0 && HitPawn.Controller.SameTeamAs(Instigator.Controller)
		&& VSize(HitPawn.Location - StartTrace) < TargetRange && HitPawn.Controller.bGodMode == False)
	{
		return true;
	}

	return false;
}

function Activate()
{
	local Vehicle V;
	local Vector FaceDir;
	local Vector BeamEndLocation;
	local vector HitLocation;
	local vector HitNormal;
	local Actor AHit;
	local Pawn  HitPawn;
	local Vector StartTrace;
	local MedicDrone Drone;
	
	Super(EnhancedRPGArtifact).Activate();
	
	Drone=MedicDrone(Owner);

	if ((Instigator == None) || (Instigator.Controller == None))
	{
		bActive = false;
		GotoState('');
		return;	// really corrupt
	}

	V = Vehicle(Instigator);
	if (V != None )
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
		bActive = false;
		GotoState('');
		return;	// can't use in a vehicle
	}
	if (DroneCount == MaxDroneNum)
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
		bActive = false;
		GotoState('');
		return;	// reached maximum number of drain targets
	}

	// lets see what we hit then
	FaceDir = Vector(Instigator.Controller.GetViewRotation());
	StartTrace = Instigator.Location + Instigator.EyePosition();
	BeamEndLocation = StartTrace + (FaceDir * TargetRange);

	// See if we hit something.
	AHit = Trace(HitLocation, HitNormal, BeamEndLocation, StartTrace, true);
	if ((AHit == None) || (Pawn(AHit) == None) || (Pawn(AHit).Controller == None))
	{
		bActive = false;
		GotoState('');
		return;	// didn't hit an enemy
	}

	HitPawn = Pawn(AHit);
	if (HitPawn != Instigator && HitPawn.Health > 0
	     && VSize(HitPawn.Location - StartTrace) < TargetRange)
	{
		if (!HitPawn.Controller.SameTeamAs(Instigator.Controller))
		{
			Drone.DroneTarget = Instigator;
			bDroneTargetSet = false;
		}
		else
		{
			//Got it. Set the Drone owner to new target.
			DroneTarget = HitPawn;
			if (Drone.DroneTarget != DroneTarget)
			{
				Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
				Drone.DroneTarget = HitPawn;
				bDroneTargetSet = True;
				HitPawn.ReceiveLocalizedMessage(MessageClass, 6000, None, None, Class);
			}
			else
			{
				Instigator.ReceiveLocalizedMessage(MessageClass, 5000, None, None, Class);
				Drone.DroneTarget = Instigator;
				bDroneTargetSet = false;
				return;
			}
		}
	}
	bActive = false;
	GotoState('');
	return;
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle.";
	else if (Switch == 4000)
		return "Drone target set.";
	else if (Switch == 5000)
		return "Drone returned.";
	else if (Switch == 6000)
		return "You have been given a healing drone!";
}

exec function TossArtifact()
{
	//do nothing. This artifact cant be thrown
}

function DropFrom(vector StartLocation)
{
	if (bActive)
		GotoState('');
	bActive = false;

	Destroy();
	Instigator.NextItem();
}

defaultproperties
{
     MaxDroneNum=1
     TargetRange=4000.000000
     MinActivationTime=0.000001
     IconMaterial=Texture'AW-2004Particles.Cubes.RedS1'
     ItemName="Remote Drone"
}
