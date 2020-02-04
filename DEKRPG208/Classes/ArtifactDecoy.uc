class ArtifactDecoy extends EnhancedRPGArtifact
	config(UT2004RPG);

var config float HolographLifespan;
var config int HolographDistance;

function BotConsider()
{
	return;	// bots cannot sensibly use, and it wastes adrenaline
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');
}

function Activate()
{	
	local Vehicle V;
	local Vector FaceDir;
	local HolographActor H;
	local vector HitLocation;
	local vector HitNormal;
	local Vector HolographLocation;
	
	Super(EnhancedRPGArtifact).Activate();

	if ((Instigator != None) && (Instigator.Controller != None))
	{
		if(Instigator.Controller.Adrenaline < (AdrenalineRequired*AdrenalineUsage))
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, AdrenalineRequired*AdrenalineUsage, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		if (LastUsedTime  + (TimeBetweenUses*AdrenalineUsage) > Instigator.Level.TimeSeconds)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 5000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// cannot use yet
		}
		V = Vehicle(Instigator);
		if (V != None )
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// can't use in a vehicle
		}
		
		FaceDir = Vector(Instigator.Controller.GetViewRotation());
		HolographLocation = Instigator.Location + (FaceDir * HolographDistance);
		if (!FastTrace(Instigator.Location, HolographLocation ))
		{
			// can't get directly to where we want to be. Spawn explosion where we collide.
       			Trace(HitLocation, HitNormal, HolographLocation, Instigator.Location, true);
			// then lets just step back a touch
			HolographLocation = HitLocation - (30*Normal(FaceDir));
		}
		
		H = Instigator.Spawn(class'HolographActor', , , HolographLocation);
		if (H != None)
		{
			H.SetTeamNum(Instigator.GetTeamNum());
			if (H.Controller != None)
				H.Controller.Destroy();
			H.PlayerSpawner = Instigator;
			H.Lifespan = HolographLifespan;
			SetRecoveryTime(TimeBetweenUses*AdrenalineUsage);
			Instigator.Controller.Adrenaline -= AdrenalineRequired*AdrenalineUsage;
			if (Instigator.Controller.Adrenaline < 0)
				Instigator.Controller.Adrenaline = 0;
		}
	}
	bActive = false;
	GotoState('');
	return;	// cannot use yet
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

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle";
	else if (Switch == 5000)
		return "Cannot use this artifact again yet";
	else
		return switch @ "Adrenaline is required to use this artifact";
}

defaultproperties
{
	 HolographDistance=600
	 AdrenalineRequired=20
	 TimeBetweenUses=20.000000
	 HolographLifespan=15.00
     CostPerSec=1
	 MinActivationTime=0.000001
     IconMaterial=Texture'DEKRPGTexturesMaster207P.Artifacts.Decoy'
     ItemName="Decoy"
}
