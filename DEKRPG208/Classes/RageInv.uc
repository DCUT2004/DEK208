class RageInv extends Inventory;

var Controller InstigatorController;
var Pawn PawnOwner;

var bool stopped;
var int TheHealth;

#exec OBJ LOAD FILE=..\Textures\DEKMonstersTexturesMaster206E.utx


replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		stopped, TheHealth;
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
	
	SetTimer(1.0, true);
}

simulated function Timer()
{	
	if(!stopped)
	{
		if (Role == ROLE_Authority)
		{
			if (Owner == None || PawnOwner == None || PawnOwner.Health <= 0)
			{
				Destroy();
				return;
			}

			if (Instigator == None && InstigatorController != None)
				Instigator = InstigatorController.Pawn;
			else if(PawnOwner != None)
			{
				TheHealth = PawnOwner.Health;
			}
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
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
