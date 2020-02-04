class ImmobilizeInv extends Inventory;

var Pawn PawnOwner;		//The player that caused immobilize
var bool stopped;
var int RegenAmount;
var ImmobilizeBubble ImmobilizeFX;
var Sound ImmobilizedSound;

#exec  AUDIO IMPORT NAME="ImmobilizeAmbient" FILE="C:\UT2004\Sounds\ImmobilizeAmbient.WAV" GROUP="ArtifactSounds"

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		stopped;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if(Other == None)
	{
		destroy();
		return;
	}
	
	stopped = false;

	enable('Tick');
	SetTimer(0.2, true);
	
	if (Other != None)
	{
		Other.SetPhysics(PHYS_None);
		if(Other.Controller != None && PlayerController(Other.Controller) != None)
			PlayerController(Other.Controller).ReceiveLocalizedMessage(class'ImmobilizedConditionMessage', 0);
		ImmobilizeFX = PawnOwner.spawn(class'ImmobilizeBubble', Other,, Other.Location, Other.Rotation);
		if (ImmobilizeFX != None)
		{
			ImmobilizeFX.RemoteRole = ROLE_SimulatedProxy;
			ImmobilizeFX.SetBase(Other);
			ImmobilizeFX.Lifespan = Lifespan;
			Other.AmbientSound = ImmobilizedSound;
			Other.AmbientSoundScaling = 2.5000;
			Other.SoundRadius=400.00;
		}
	}

	Super.GiveTo(Other);
}

function Tick(float deltaTime)
{
	if (Instigator != None)
	{
		if(!class'RW_Freeze'.static.canTriggerPhysics(Instigator))
			return;

		if(Instigator.Physics != PHYS_NONE)
			Instigator.setPhysics(PHYS_NONE);
	}
}

function destroyed()
{
	stopEffect();
	disable('Tick');
	if(Instigator != None && Instigator.Physics == PHYS_NONE)
		Instigator.SetPhysics(PHYS_Falling);
	super.destroyed();
}

function stopEffect()
{
	if(stopped)
		return;
	else
		stopped = true;
	if (ImmobilizeFX != None)
		ImmobilizeFX.Destroy();	
	Instigator.SetPhysics(PHYS_Falling);
	ImmobilizedSound = None;
}

simulated function Timer()
{
	if (Lifespan <= 0.4)
		ImmobilizedSound = None;
	if (PawnOwner != None && PawnOwner.Health > 0)
		PawnOwner.GiveHealth(RegenAmount, PawnOwner.HealthMax);
}

defaultproperties
{
	 ImmobilizedSound=Sound'DEKRPG208.ArtifactSounds.ImmobilizeAmbient'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
