class ArtifactAmplifierDummy extends EnhancedRPGArtifact
		config(UT2004RPG);

var config float TargetRange;
var int AbilityLevel;
var config float MaxRecoveryTime;

function BotConsider()
{
	return;
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');
}

function Activate()
{
	local Vehicle V;
	local AmplifierInv Inv;

	if ((Instigator == None) || (Instigator.Controller == None))
	{
		bActive = false;
		GotoState('');
		return;	// really corrupt
	}
	
	if (LastUsedTime + (TimeBetweenUses*AdrenalineUsage) > Instigator.Level.TimeSeconds)
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
	Inv = AmplifierInv(Instigator.FindInventoryType(class'AmplifierInv'));
	if (Inv == None)
	{
		Inv = spawn(class'AmplifierInv', Instigator);
		Inv.AmplifierPlayerController = Instigator.Controller;
		Inv.Countdown = 20;
		Inv.GiveTo(Instigator);
	}
	else
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
		bActive = false;
		GotoState('');
		return;	// can't use in a vehicle
	}
	bActive = false;
	GotoState('');
	return;	// cannot use yet

}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle.";
	else if (Switch == 6000)
		return "A target already exists.";
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
     TargetRange=50000.000000
     MinActivationTime=0.000001
     IconMaterial=Texture'Crosshairs.HUD.Crosshair_Cross5'
     ItemName="Amplifier Durrdur"
}
