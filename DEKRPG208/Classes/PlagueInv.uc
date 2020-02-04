class PlagueInv extends Inventory
	config(UT2004RPG);

var Pawn PawnOwner;
var Controller Necromancer;
var Pawn InfectorOne, InfectorTwo, InfectorThree;
var config int PlagueDamage;
var config float InfectRadius;
var config int PlagueLifespan, MaxLifespan;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner, Necromancer;

	reliable if (Role == ROLE_Authority)
		InfectorOne, InfectorTwo, InfectorThree;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other);
	PawnOwner = Other;
	SetTimer(1, True);
}

simulated function Timer()
{
	local Vehicle V;
	
	if (Necromancer == None || Necromancer.Pawn == None || Necromancer.Pawn.Health <= 0)
	{
		Destroy();
		return;
	}

	if (Owner == None)
	{
		Destroy();
		return;
	}

	if (PawnOwner == None)
	{
		Destroy();
		return;     // cant do anything
	}
	else
	{
		if(PlagueDamage > 0)
		{
			if (PawnOwner.Controller != None)
			{
				if (PawnOwner != Necromancer.Pawn)
				{
					V = Vehicle(PawnOwner);
					if (V != None)
					{
						V.Driver.TakeDamage(PlagueDamage, Necromancer.Pawn, V.Driver.Location, vect(0,0,0), class'DamTypePlague');
						if (InfectorOne != None)
							V.Driver.TakeDamage(PlagueDamage*0.85, InfectorOne, V.Driver.Location, vect(0,0,0), class'DamTypePlague');
						if (InfectorTwo != None)
							V.Driver.TakeDamage(PlagueDamage*0.65, InfectorTwo, V.Driver.Location, vect(0,0,0), class'DamTypePlague');	
						if (InfectorThree != None)
							V.Driver.TakeDamage(PlagueDamage*0.50, InfectorThree, V.Driver.Location, vect(0,0,0), class'DamTypePlague');								
					}
					else
					{
						PawnOwner.TakeDamage(PlagueDamage, Necromancer.Pawn, PawnOwner.Location, vect(0,0,0), class'DamTypePlague');
						if (InfectorOne != None)
							PawnOwner.TakeDamage(PlagueDamage*0.85, InfectorOne, PawnOwner.Location, vect(0,0,0), class'DamTypePlague');
						if (InfectorTwo != None)
							PawnOwner.TakeDamage(PlagueDamage*0.65, InfectorTwo, PawnOwner.Location, vect(0,0,0), class'DamTypePlague');
						if (InfectorThree != None)
							PawnOwner.TakeDamage(PlagueDamage*0.50, InfectorThree, PawnOwner.Location, vect(0,0,0), class'DamTypePlague');
					}
				}
				else if (PawnOwner == Necromancer.Pawn)
				{
					PlagueLifespan--;
					if (PlagueLifespan <= 0)
						Destroy();
				}
				PawnOwner.Spawn(class'PlagueSmoke', PawnOwner,, PawnOwner.Location, PawnOwner.Rotation);
				if (PawnOwner.IsLocallyControlled() && PlayerController(PawnOwner.Controller) != None)
					PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'PlagueMessage', PlagueLifespan);
				Infect(InfectRadius);
			}
		}
	}
}

simulated function Infect(float Radius)
{
	local Controller C;
	local PlagueInv Inv;
	
	if (Necromancer == None || Necromancer.Pawn == None || Necromancer.Pawn.Health <= 0)
	{
		Destroy();
		return;
	}
	
	if (PawnOwner == None || PawnOwner.Health <= 0)
	{
		Destroy();
		return;
	}
	
	for ( C = Level.ControllerList; C != None; C = C.NextController )
	{
		if (C != None && C.Pawn != None && C.Pawn.Health > 0 && PawnOwner != None && C.Pawn != PawnOwner && Necromancer != None && !C.SameTeamAs(Necromancer) && VSize(C.Pawn.Location - PawnOwner.Location) <= Radius
		&& FastTrace(C.Pawn.Location, PawnOwner.Location) && C.bGodMode == False && InvulnerabilityInv(C.Pawn.FindInventoryType(class'InvulnerabilityInv')) == None && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow'))
		{
			Inv = PlagueInv(C.Pawn.FindInventoryType(class'PlagueInv'));
			if (Inv == None)
			{
				Inv = C.Pawn.Spawn(class'PlagueInv', C.Pawn, , C.Pawn.Location, C.Pawn.Rotation);
				Inv.Necromancer = Necromancer;
				Inv.PlagueDamage = PlagueDamage;
				Inv.GiveTo(C.Pawn);
			}
			else if (Inv != None)
			{
				if (PawnOwner != Necromancer)	//this must be a monster. Humans/bots will never have this inventory and not be a Necromancer
				{
					if (InfectorOne != None && Inv.InfectorOne == None)	//When a monster is infecting another monster, transfer all infector pawns to that monster
					{
						Inv.InfectorOne = InfectorOne;
					}
					if (InfectorTwo != None && Inv.InfectorTwo == None)
					{
						Inv.InfectorTwo = InfectorTwo;
					}
					if (InfectorThree != None && Inv.InfectorThree == None)
					{
						Inv.InfectorThree = InfectorThree;
					}
				}
				else if (PawnOwner == Necromancer && Inv.Necromancer != Necromancer)	//this must be a human/bot.
				{
					if (Inv.InfectorOne == None)	//When infecting a monster, see if we can fill one of the infector slots and get a piece of the cake
						Inv.InfectorOne = Necromancer.Pawn;
					else if (Inv.InfectorTwo == None)
						Inv.InfectorTwo = Necromancer.Pawn;
					else if (Inv.InfectorThree == None)
						Inv.InfectorThree = Necromancer.Pawn;
				}
			}
		}
	}
}


simulated function SpawnInfection()
{
	local PlagueActor Plague;
	
	if (Necromancer == None || Necromancer.Pawn == None || Necromancer.Pawn.Health <= 0)
		return;
	if (PawnOwner != None && Necromancer != None)
	{
		Plague = PawnOwner.Spawn(class'PlagueActor', PawnOwner,, PawnOwner.Location, PawnOwner.Rotation);
		if (Plague != None)
		{
			Plague.Necromancer = Necromancer;
		}
	}
}

simulated function Destroyed()
{
	if (PawnOwner != None && Necromancer != None && PawnOwner != Necromancer.Pawn)
		SpawnInfection();
	super.destroyed();
}

defaultproperties
{
	 PlagueLifespan=10	//How long the Necromancer should carry the plague
	 MaxLifespan=20		//The max amount of time the Necromancer can carry the plague
	 PlagueDamage=5
	 InfectRadius=200.0000
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
