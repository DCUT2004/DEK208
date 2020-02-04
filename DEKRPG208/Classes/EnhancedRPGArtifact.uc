class EnhancedRPGArtifact extends RPGArtifact
		abstract;

var config float AdrenalineUsage, ExtremeUsage, WizardUsage, PowerUsage;				// set to 0.5 means only uses half adrenaline
var config float TimeUsage;
var config float TimeBetweenUses;		// the time required between uses of this artifact
var float LastUsedTime;					// time this artifact was last used
var float RecoveryTime;					// time this artifact can be used again. Clientside only.
var config int AdrenalineRequired;

replication
{
	reliable if (Role == ROLE_Authority)
		SetClientRecoveryTime;
}

function Activate()
{
	local WizardInv WInv;
	local ExtremeAMInv EInv;
	local PowerAMInv PInv;
	
	WInv = WizardInv(Instigator.FindInventoryType(class'WizardInv'));
	EInv = ExtremeAMInv(Instigator.FindInventoryType(class'ExtremeAMInv'));
	PInv = PowerAMInv(Instigator.FindInventoryType(class'PowerAMInv'));

	if (WInv != None)
	{
		AdrenalineUsage = WizardUsage;
		TimeUsage = WizardUsage;
	}
	else if (PInv != None)	//increase adren cost, but don't increase time between uses
	{
		AdrenalineUsage = PowerUsage;
		TimeUsage = ExtremeUsage;
	}
	else if (EInv != None && WInv == None && PInv == None)
	{
		AdrenalineUsage = ExtremeUsage;
		TimeUsage = ExtremeUsage;
	}
	Super.Activate();
}

function SetRecoveryTime(float RecoveryPeriod)
{
	LastUsedTime = Level.TimeSeconds;
	SetClientRecoveryTime(RecoveryPeriod);
}

simulated function SetClientRecoveryTime(int RecoveryPeriod)
{
	// set the recoverytime on the client side for the hud display
	if(Level.NetMode != NM_DedicatedServer)
	{
		RecoveryTime = Level.TimeSeconds + RecoveryPeriod;
	}
}

simulated function int GetRecoveryTime()
{
	if (RecoveryTime > 0 && RecoveryTime > Level.TimeSeconds)
		return max(int(RecoveryTime - Level.TimeSeconds),1);
	else
		return 0;
}

function EnhanceArtifact(float Adusage)
{
	AdrenalineUsage = AdUsage;
}

simulated function Tick(float deltaTime)
{
	if (bActive)
	{
		if (Instigator != None && Instigator.Controller != None)	// not ghosting
		{
			Instigator.Controller.Adrenaline -= deltaTime * CostPerSec;
			if (Instigator.Controller.Adrenaline <= 0.0)
			{
				Instigator.Controller.Adrenaline = 0.0;
				UsedUp();
			}
		}
	}
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 1000)
		return "Cannot use this artifact inside a vehicle";
	else if (Switch == 2000)
		return "Cannot use this artifact again yet";
	else
		return switch @ "Adrenaline is required to use this artifact";
}

defaultproperties
{
	 TimeUsage=1.0000
     AdrenalineUsage=1.000000
	 WizardUsage=0.25000
	 ExtremeUsage=0.5000
	 PowerUsage=1.250000
}
