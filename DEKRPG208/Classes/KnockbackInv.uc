class KnockbackInv extends Inventory;

var Pawn PawnOwner;
var int Modifier;
var bool stopped;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		stopped;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local NecroInv NInv;
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	
	PawnOwner = Other;

	if(PawnOwner == None)
	{
		destroy();
		return;
	}
	
	NInv = NecroInv(PawnOwner.FindInventoryType(class'NecroInv'));
	if(NInv != None)
	{
		return;
	}
	
	stopped = false;
	
	MiInv = MissionInv(PawnOwner.FindInventoryType(class'MissionInv'));
	M1Inv = Mission1Inv(PawnOwner.FindInventoryType(class'Mission1Inv'));
	M2Inv = Mission2Inv(PawnOwner.FindInventoryType(class'Mission2Inv'));
	M3Inv = Mission3Inv(PawnOwner.FindInventoryType(class'Mission3Inv'));
	
	if (PawnOwner != None && MiInv != None && !MiInv.WizardryComplete)
	{
		if (M1Inv != None && !M1Inv.Stopped && M1Inv.WizardryActive)
		{
			M1Inv.MissionCount++;
		}
		if (M2Inv != None && !M2Inv.Stopped && M2Inv.WizardryActive)
		{
			M2Inv.MissionCount++;
		}
		if (M3Inv != None && !M3Inv.Stopped && M3Inv.WizardryActive)
		{
			M3Inv.MissionCount++;
		}
	}

	SetTimer(1/Modifier, true);
	Super.GiveTo(Other);
}

function stopEffect()
{
	if(stopped)
		return;
	else
		stopped = true;
}

function Destroyed()
{
	if(PawnOwner == None)
		return;

	if(PawnOwner.Physics != PHYS_Walking && PawnOwner.Physics != PHYS_Falling) //still going?
		PawnOwner.setPhysics(PHYS_Falling);
	stopEffect();
	super.destroyed();
}

function Timer()
{
	local DruidGhostInv dgInv;
	local GhostInv gInv;

	//if ghost is running destroying this is a really bad thing. let the timer tick till they're done.
	dgInv = DruidGhostInv(PawnOwner.FindInventoryType(class'DruidGhostInv'));
	if(dgInv != None && !dgInv.bDisabled)
		return;

	gInv = GhostInv(PawnOwner.FindInventoryType(class'GhostInv'));
	if(gInv != None && !gInv.bDisabled)
		return;

	if(PawnOwner.Physics != PHYS_Hovering && PawnOwner.Physics != PHYS_Falling)
		Destroy();
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
