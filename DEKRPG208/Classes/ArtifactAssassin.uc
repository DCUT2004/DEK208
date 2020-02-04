class ArtifactAssassin extends EnhancedRPGArtifact
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
	local Vector FaceDir;
	local Vector BeamEndLocation;
	local vector HitLocation;
	local vector HitNormal;
	local Actor AHit;
	local Pawn  HitPawn;
	local Vector StartTrace;
	local AssassinInv Inv;

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
	if ( HitPawn != Instigator && HitPawn.Health > 0 && !HitPawn.Controller.SameTeamAs(Instigator.Controller)
	     && VSize(HitPawn.Location - StartTrace) < TargetRange)
	{
		if (HitPawn.IsA('HealerNali') || HitPawn.IsA('MissionCow'))
		{
			bActive = false;
			GotoState('');
			return;
		}
		//Got it
		Inv = AssassinInv(Instigator.FindInventoryType(class'AssassinInv'));
		if (Inv != None)
		{
			if (Inv.Target != None)
			{
				Instigator.ReceiveLocalizedMessage(MessageClass, 6000, None, None, Class);
				bActive = false;
				GotoState('');
				return;
			}
			else
			{
				Inv.Target = HitPawn;
				Inv.SpawnFX();
				Inv.SetTimer(1, True);
			}
		}
		else	//something wrong
		{
				bActive = false;
				GotoState('');
				return;
		}
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
     ItemName="Assassin Mark"
}
