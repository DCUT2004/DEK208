class ArtifactPhantom extends EnhancedRPGArtifact;

var config float PhantomLifespan;
var config int RegenAmount;

function BotConsider()
{
	if (Instigator.Controller.Adrenaline < 30)
		return;

	if (bActive && (Instigator.Controller.Enemy == None || !Instigator.Controller.CanSee(Instigator.Controller.Enemy)))
		Activate();
	else if ( !bActive && Instigator.Controller.Enemy != None
		  && Instigator.Health < 70 && Instigator.Controller.CanSee(Instigator.Controller.Enemy) && NoArtifactsActive() && FRand() < 0.7 )
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
	local PhantomGhostInv PInv;
	
	Super(EnhancedRPGArtifact).Activate();

	if (Instigator != None)
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
		PInv = PhantomGhostInv(Instigator.FindInventoryType(class'PhantomGhostInv'));
		
		if (PInv != None) //Already in Phantom mode.
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		else
		{
			PInv = spawn(class'PhantomGhostInv', Instigator,,, rot(0,0,0));
			PInv.Lifespan = PhantomLifespan;
			PInv.RegenAmount = RegenAmount;
			PInv.GiveTo(Instigator);
			Instigator.Controller.Adrenaline -= AdrenalineRequired;
			if (Instigator.Controller.Adrenaline < 0)
				Instigator.Controller.Adrenaline = 0;
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
		return "Already in Phantom state.";
	else if (Switch == 5000)
		return "Cannot use this artifact again yet.";
	else
		return switch @ "Adrenaline is required to use this artifact";
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
     PhantomLifespan=10.000000
     AdrenalineRequired=75
     RegenAmount=5
     CostPerSec=1
     PickupClass=Class'DEKRPG208.DruidArtifactInvulnerabilityPickup'
     IconMaterial=FinalBlend'AW-2k4XP.Weapons.ShockShieldFallbackFinal'
     ItemName="Phantom"
}
