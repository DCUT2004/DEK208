//-----------------------------------------------------------
//
//-----------------------------------------------------------
class NullEntropyInv extends Inventory;

var Pawn PawnOwner;
var Material ModifierOverlay;
var int Modifier;
var Sound NullEntropySound;
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

	if(Other == None)
	{
		destroy();
		return;
	}
	
	PawnOwner = Other;
	
	stopped = false;

	enable('Tick');
	
	if(Modifier < 7)
	{
		LifeSpan = (Modifier / 3) + ((7 - Modifier) * 0.1);
		SetTimer(0.1, true);
	}
	else
		LifeSpan = (Modifier / 3);
	
	if (PawnOwner != None)
	{
		PawnOwner.SetPhysics(PHYS_None);
		NInv = NecroInv(PawnOwner.FindInventoryType(class'NecroInv'));
		if(NInv != None)
		{
			return;
		}
	
		MiInv = MissionInv(PawnOwner.FindInventoryType(class'MissionInv'));
		M1Inv = Mission1Inv(PawnOwner.FindInventoryType(class'Mission1Inv'));
		M2Inv = Mission2Inv(PawnOwner.FindInventoryType(class'Mission2Inv'));
		M3Inv = Mission3Inv(PawnOwner.FindInventoryType(class'Mission3Inv'));
	
		if (MiInv != None && !MiInv.WizardryComplete)
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
		PawnOwner.PlaySound(NullEntropySound,,1.5 * PawnOwner.TransientSoundVolume,,PawnOwner.TransientSoundRadius);
		PawnOwner.setOverlayMaterial(ModifierOverlay, LifeSpan, true);
		if(PawnOwner.Controller != None && PlayerController(PawnOwner.Controller) != None)
			PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'NullEntropyConditionMessage', 0);
	}

	Super.GiveTo(Other);
}

function Tick(float deltaTime)
{
	if (PawnOwner != None)
	{
		if(!class'RW_Freeze'.static.canTriggerPhysics(PawnOwner))
			return;

		if(PawnOwner.Physics != PHYS_NONE)
			PawnOwner.setPhysics(PHYS_NONE);
	}
}

function destroyed()
{
	stopEffect();
	disable('Tick');
	if(PawnOwner != None && PawnOwner.Physics == PHYS_NONE)
		PawnOwner.SetPhysics(PHYS_Falling);
	super.destroyed();
}

function stopEffect()
{
	if(stopped)
		return;
	else
		stopped = true;
}

function Timer()
{
	if(LifeSpan <= (7 - Modifier) * 0.1)
	{
		SetTimer(0, true);
		disable('Tick');		
		PawnOwner.SetPhysics(PHYS_Falling);
	}
}

defaultproperties
{
     ModifierOverlay=Shader'MutantSkins.Shaders.MutantGlowShader'
     NullEntropySound=SoundGroup'WeaponSounds.Translocator.TranslocatorModuleRegeneration'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
