class ArtifactImmobilize extends EnhancedRPGArtifact
		config(UT2004RPG);

var config float MaxRange, ImmobilizeLifespan, RegenAmount;

function BotConsider()
{
	if (Instigator.Controller.Adrenaline < 20)
		return;

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
	BeamEndLocation = StartTrace + (FaceDir * MaxRange);

	AHit = Trace(HitLocation, HitNormal, BeamEndLocation, StartTrace, true);
	if ((AHit == None) || (Pawn(AHit) == None) || (Pawn(AHit).Controller == None))
		return false;

	HitPawn = Pawn(AHit);
	if ( HitPawn != Instigator && HitPawn.Health > 0 && !HitPawn.Controller.SameTeamAs(Instigator.Controller)
		&& VSize(HitPawn.Location - StartTrace) < MaxRange)
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
	local ImmobilizeInv Inv;
	
	Super(EnhancedRPGArtifact).Activate();

	if ((Instigator == None) || (Instigator.Controller == None))
	{
		bActive = false;
		GotoState('');
		return;	// really corrupt
	}
	
	if(Instigator.Controller.Adrenaline < AdrenalineRequired*AdrenalineUsage)
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
	// lets see what we hit then
	FaceDir = Vector(Instigator.Controller.GetViewRotation());
	StartTrace = Instigator.Location + Instigator.EyePosition();
	BeamEndLocation = StartTrace + (FaceDir * MaxRange);

	// See if we hit something.
	AHit = Trace(HitLocation, HitNormal, BeamEndLocation, StartTrace, true);
	if ((AHit == None) || (Pawn(AHit) == None) || (Pawn(AHit).Controller == None))
	{
		bActive = false;
		GotoState('');
		return;	// didn't hit an enemy
	}

	HitPawn = Pawn(AHit);
	if ( HitPawn != None && HitPawn != Instigator && HitPawn.Health > 0 && !HitPawn.Controller.SameTeamAs(Instigator.Controller)
	     && VSize(HitPawn.Location - StartTrace) < MaxRange && HitPawn.Controller.bGodMode == False)
	{
		Inv = ImmobilizeInv(HitPawn.FindInventoryType(class'ImmobilizeInv'));
		if (Inv == None)
		{
			Inv = spawn(class'ImmobilizeInv', HitPawn,,, rot(0,0,0));
			Inv.PawnOwner = Instigator;
			Inv.Lifespan = ImmobilizeLifespan;
			Inv.RegenAmount = RegenAmount;
			Inv.GiveTo(HitPawn);
			Instigator.PlaySound(Sound'DEKRPG208.TurretSounds.SolarTurretAltCharge', SLOT_None, Instigator.TransientSoundVolume*1.75);
			SetRecoveryTime(TimeBetweenUses*TimeUsage);
			Instigator.Controller.Adrenaline -= AdrenalineRequired*AdrenalineUsage;
			if (Instigator.Controller.Adrenaline < 0)
				Instigator.Controller.Adrenaline = 0;
		}
		else
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 6000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// didn't hit an enemy
		}
	}
	bActive = false;
	GotoState('');
	return;
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle";
	else if (Switch == 5000)
		return "Cannot use this artifact again yet";
	else if (Switch == 6000)
		return "Target is already immobilized.";
	else
		return "At least" @ switch @ "adrenaline is required to use this artifact";
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
	 RegenAmount=1.000
	 ImmobilizeLifespan=7.000
	 AdrenalineRequired=30
     MaxRange=2000.000000
     TimeBetweenUses=10.000000
     CostPerSec=1
     MinActivationTime=0.000001
     IconMaterial=Texture'DEKRPGTexturesMaster207P.Artifacts.Immobilize'
     ItemName="Immobilize"
}
