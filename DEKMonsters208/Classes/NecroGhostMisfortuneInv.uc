class NecroGhostMisfortuneInv extends Inventory;

var Controller InstigatorController;
var Pawn PawnOwner;
var bool stopped;
var Pawn Ghost;
var config float MisfortuneRadius;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		stopped;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Instigator != None)
		InstigatorController = Instigator.Controller;

	SetTimer(0.1, true);
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local Pawn OldInstigator;

	if(Other == None)
	{
		destroy();
		return;
	}
	

	stopped = false;
	if (InstigatorController == None)
		InstigatorController = Other.Controller;

	//want Instigator to be the one that caused the freeze
	OldInstigator = Instigator;
	Super.GiveTo(Other);
	PawnOwner = Other;

	Instigator = OldInstigator;
}

simulated function Timer()
{
	local Pickup P;
	local Actor A;
	
	if(!stopped)
	{
		if (PawnOwner != None)
		{
			PawnOwner.ReceiveLocalizedMessage(class'NecroGhostMisfortuneMessage');
		}
		if (Role == ROLE_Authority)
		{
			if (PawnOwner == None || PawnOwner.Health <= 0)
			{
				Destroy();
				return;
			}
			
			if(!class'RW_Freeze'.static.canTriggerPhysics(PawnOwner))
			{
				stopEffect();
				return;
			}
			if (PawnOwner != None)
			{
				foreach PawnOwner.CollidingActors(class'Pickup', P, MisfortuneRadius)
				if ( P.ReadyToPickup(0) && WeaponLocker(P) == None )
				{
					A = spawn(class'RocketExplosion',,, P.Location);
					if (A != None)
					{
						A.RemoteRole = ROLE_SimulatedProxy;
						A.PlaySound(sound'WeaponSounds.BExplosion3',,2.5*P.TransientSoundVolume,,P.TransientSoundRadius);
					}
					if (!P.bDropped && WeaponPickup(P) != None && WeaponPickup(P).bWeaponStay && P.RespawnTime != 0.0)
						P.GotoState('Sleeping');
					else
						P.SetRespawn();
				}
			}
			if (Instigator == None && InstigatorController != None)
				Instigator = InstigatorController.Pawn;
		}
	}
}

function stopEffect()
{
	if(stopped)
		return;
	else
		stopped = true;
}

function destroyed()
{
	stopEffect();
	super.destroyed();
}

defaultproperties
{
     MisfortuneRadius=300.000000
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
     LifeSpan=15.000000
}
