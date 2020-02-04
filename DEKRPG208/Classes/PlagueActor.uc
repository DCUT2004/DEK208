class PlagueActor extends Actor;

var PlagueDeathSmoke FX;
var Controller Necromancer;
var config float InfectRadius;
var config float PlagueLifespan;
var config float WaitTime;
var int Counter;
var int SpreadCounter;

replication
{
	reliable if (Role == ROLE_Authority)
		SpreadCounter;
}

simulated function PostBeginPlay()
{
	FX = Spawn(class'PlagueDeathSmoke', Self,, Self.Location, Self.Rotation);
	if (FX != None)
	{
		FX.Lifespan=PlagueLifespan;
		FX.SetBase(Self);
	}
    SetTimer(1, true);
	Counter = 0;
	SpreadCounter = 0;
	Super.PostBeginPlay();
}

simulated function Timer()
{
	local Controller C;
	local PlagueInv Inv;
	local PlagueSpreader PInv;
	
	if (Necromancer == None || Necromancer.Pawn == None || Necromancer.Pawn.Health <= 0)
	{
		Destroy();
		return;
	}
	
	for ( C = Level.ControllerList; C != None; C = C.NextController )
	{
		if (C != None && C.Pawn != None && C.Pawn.Health > 0 && Necromancer != None && VSize(C.Pawn.Location - Self.Location) <= InfectRadius
		&& FastTrace(C.Pawn.Location, Self.Location) && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow'))
		{
			Inv = PlagueInv(C.Pawn.FindInventoryType(class'PlagueInv'));
			PInv = PlagueSpreader(C.Pawn.FindInventoryType(class'PlagueSpreader'));
			if (C.SameTeamAs(Necromancer) && PInv != None)
			{
				SpreadCounter++;
				if (SpreadCounter >= WaitTime)
				{
					if (Inv == None)
					{
						Inv = C.Pawn.Spawn(class'PlagueInv', C.Pawn, , C.Pawn.Location, C.Pawn.Rotation);
						Inv.Necromancer = C; //Everyone who comes to the plague cloud becomes the Necromancer spreader
						Inv.GiveTo(C.Pawn);
					}
					else if (Inv != None)
					{
						Inv.PlagueLifespan += 5;
						if (Inv.PlagueLifespan > Inv.MaxLifespan)
							Inv.PlagueLifespan = Inv.MaxLifespan;
					}
					SpreadCounter = 0;
				}
			}
			else if (!C.SameTeamAs(Necromancer))
			{
				if (Inv == None)
				{
					Inv = C.Pawn.Spawn(class'PlagueInv', C.Pawn, , C.Pawn.Location, C.Pawn.Rotation);
					Inv.Necromancer = Necromancer;
					Inv.GiveTo(C.Pawn);
				}
				else if (Inv != None)
				{
					if (Inv.Necromancer != Necromancer)
					{
						if (Inv.InfectorOne == None)
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
	if (FX == None)
	{
		FX = Spawn(class'PlagueDeathSmoke', Self,, Self.Location, Self.Rotation);
		if (FX != None)
		{
			FX.Lifespan=PlagueLifespan;
			FX.SetBase(Self);
		}
	}
	Counter++;
	if (Counter >= PlagueLifespan)
	{
		Destroy();
		return;
	}
}

simulated function Destroyed()
{
	if (FX != None)
		FX.Destroy();
	Super.Destroyed();
}

defaultproperties
{
	WaitTime=3.00000
	PlagueLifespan=10.00000
	InfectRadius=400.000000
    DrawType=DT_None
	Texture=Texture'XEffectMat.Shock.shock_core'
	DrawScale=0.080000
}
