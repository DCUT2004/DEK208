class ArtifactGlowStreak extends EnhancedRPGArtifact
		config(UT2004RPG);

var config float MaxRange;
var config float LockAim;

function BotConsider()
{
	if (Instigator.Controller.Adrenaline < AdrenalineRequired)
		return;

	if ( !bActive && Instigator.Controller.Enemy != None
		   && Instigator.Controller.CanSee(Instigator.Controller.Enemy) && NoArtifactsActive() && FRand() < 0.3 )	// fairly rare
		Activate();
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');
}

function Activate()
{
	local Vehicle V;
	local Rotator rot1, rot2, rot3, rot4, rot5, rot6, rot1Target, rot2Target, rot3Target, rot4Target, rot5Target, rot6Target;
	local CometRed CR;
	local CometOrange CO;
	local CometYellow CY;
	local CometGreen CG;
	local CometBlue CB;
	local CometPurple CP;
	local vector FX2Radius, FX3Radius, FX4Radius, FX5Radius, FX6Radius;
	local float BestAim, BestDist;

	Super(EnhancedRPGArtifact).Activate();

	if (Instigator != None && Instigator.Controller != None)
	{
		if(Instigator.Controller.Adrenaline < (AdrenalineRequired*AdrenalineUsage))
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, AdrenalineRequired*AdrenalineUsage, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		
		if (LastUsedTime  + (TimeBetweenUses*TimeUsage) > Instigator.Level.TimeSeconds)
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
		FX2Radius.X=Instigator.Location.X+-5+FRand();
		FX2Radius.Y=Instigator.Location.Y+-5+FRand();
		FX2Radius.Z=Instigator.Location.Z+-5+FRand();

		FRand();

		FX3Radius.X=Instigator.Location.X+5+FRand();
		FX3Radius.Y=Instigator.Location.Y+5+FRand();
		FX3Radius.Z=Instigator.Location.Z+5+FRand();

		FRand();

		FX4Radius.X=Instigator.Location.X+-10+FRand();
		FX4Radius.Y=Instigator.Location.Y+-10+FRand();
		FX4Radius.Z=Instigator.Location.Z+-10+FRand();

		FRand();

		FX5Radius.X=Instigator.Location.X+-10+FRand();
		FX5Radius.Y=Instigator.Location.Y+-10+FRand();
		FX5Radius.Z=Instigator.Location.Z+-10+FRand();
		
		FRand();

		FX6Radius.X=Instigator.Location.X+-15+FRand();
		FX6Radius.Y=Instigator.Location.Y+-15+FRand();
		FX6Radius.Z=Instigator.Location.Z+-15+FRand();
		
		rot1 = Instigator.Controller.GetViewRotation();
		rot1.yaw += FRand()*12000-6000;
		rot1.roll += FRand()*12000-6000;
		rot1Target = rot1;
		rot1Target.pitch -= 10000;
		
		rot2 = Instigator.Controller.GetViewRotation();
		rot2.yaw -= FRand()*12000-6000;
		rot2.roll -= FRand()*12000-6000;
		rot2Target = rot2;
		rot2Target.pitch -= 10000;		
		
		rot3 = Instigator.Controller.GetViewRotation();
		rot3.yaw += FRand()*12000-6000;
		rot3.roll += FRand()*12000-6000;
		rot3Target = rot3;
		rot3Target.pitch -= 10000;
		
		rot4 = Instigator.Controller.GetViewRotation();
		rot4.yaw -= FRand()*12000-6000;
		rot4.roll -= FRand()*12000-6000;
		rot4Target = rot4;
		rot4Target.pitch -= 10000;
		
		rot5 = Instigator.Controller.GetViewRotation();
		rot5.yaw += FRand()*12000-6000;
		rot5.roll += FRand()*12000-6000;
		rot5Target = rot5;
		rot5Target.pitch -= 10000;
		
		rot6 = Instigator.Controller.GetViewRotation();
		rot6.yaw -= FRand()*12000-6000;
		rot6.roll -= FRand()*12000-6000;
		rot6Target = rot6;
		rot6Target.pitch -= 10000;
		
		BestAim = LockAim;
		
		CR = Spawn(class'CometRed',,,Instigator.Location ,rot1);
		CR.Seeking = Instigator.Controller.PickTarget(BestAim, BestDist, vector(rot1target), Instigator.Location, MaxRange);
		CO = Spawn(class'CometOrange',,,Instigator.Location,rot2);
		CO.Seeking = Instigator.Controller.PickTarget(BestAim, BestDist, vector(rot2target), Instigator.Location, MaxRange);
		CY = Spawn(class'CometYellow',,,Instigator.Location,rot3);
		CY.Seeking = Instigator.Controller.PickTarget(BestAim, BestDist, vector(rot3target), Instigator.Location, MaxRange);
		CG = Spawn(class'CometGreen',,,Instigator.Location,rot4);
		CG.Seeking = Instigator.Controller.PickTarget(BestAim, BestDist, vector(rot4target), Instigator.Location, MaxRange);
		CB = Spawn(class'CometBlue',,,Instigator.Location,rot5);
		CB.Seeking = Instigator.Controller.PickTarget(BestAim, BestDist, vector(rot5target), Instigator.Location, MaxRange);
		CP = Spawn(class'CometPurple',,,Instigator.Location,rot6);
		CP.Seeking = Instigator.Controller.PickTarget(BestAim, BestDist, vector(rot6target), Instigator.Location, MaxRange);
		
		SetRecoveryTime(TimeBetweenUses*TimeUsage);
		Instigator.Controller.Adrenaline -= AdrenalineRequired*AdrenalineUsage;
		if (Instigator.Controller.Adrenaline < 0)
			Instigator.Controller.Adrenaline = 0;
	}
	bActive = false;
	GotoState('');
	return;
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
	 LockAim=0.0000100
	 MaxRange=90000.00
     AdrenalineRequired=30
     TimeBetweenUses=5
     CostPerSec=1
     MinActivationTime=0.000001
     IconMaterial=Texture'DEKRPGTexturesMaster207P.Artifacts.GlowStreak'
     ItemName="Glow Streak"
}
