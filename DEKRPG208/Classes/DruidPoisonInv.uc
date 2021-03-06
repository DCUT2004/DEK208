class DruidPoisonInv extends PoisonInv
	config(UT2004RPG);

var RPGRules RPGRules;

var config float BasePercentage;
var config float Curve;
var config float AdrenLost;
var bool stopped;

replication
{
	reliable if (Role == ROLE_Authority)
		stopped;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local Pawn OldInstigator;
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	
	if (InstigatorController == None)
		InstigatorController = Other.DelayedDamageInstigatorController;

	//want Instigator to be the one that caused the poison
	OldInstigator = Instigator;
	Super.GiveTo(Other);
	PawnOwner = Other;
	Instigator = OldInstigator;
	
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
}

static function AddHealableDamage(int Damage, Pawn Injured)
{
	Local HealableDamageInv Inv;

	if(Injured == None || Injured.Controller == None || Injured.Health <= 0 || Damage < 1)
		return; // Not EXP Healable

	if(Injured.isA('Monster') && !Injured.Controller.isA('DEKFriendlyMonsterController'))
		return; 	// No tracking for not friendly monsters.

	Inv = HealableDamageInv(Injured.FindInventoryType(class'HealableDamageInv'));
	if(Inv == None)
	{
		Inv = Injured.spawn(class'HealableDamageInv');
		Inv.giveTo(Injured);
	}

	if(Inv == None)
	    return;

	Inv.Damage += Damage;

	if(Inv.Damage > Injured.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus)
		Inv.Damage = Injured.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus;
}

simulated function Timer()
{
	local int PoisonDamage;

	if (Role == ROLE_Authority)
	{
		if (Owner == None)
		{
			Destroy();
			return;
		}

		if (PawnOwner == None)
		    return;     // cant do anything

		if (Instigator == None && InstigatorController != None)
			Instigator = InstigatorController.Pawn;

		PoisonDamage = int(float(PawnOwner.Health) * (Curve **(float(Modifier-1))*BasePercentage));

		if(PoisonDamage > 0)
		{
			if(PawnOwner.Controller != None && PawnOwner.Controller.bGodMode == False
				&& InvulnerabilityInv(PawnOwner.FindInventoryType(class'InvulnerabilityInv')) == None)
			{
				if (PawnOwner.Controller.Adrenaline > 0)
					PawnOwner.Controller.Adrenaline -= (Modifier*AdrenLost);
				if (PawnOwner.Controller.Adrenaline < 0)
					PawnOwner.Controller.Adrenaline = 0;
					
		    	if (PawnOwner.Health <= PoisonDamage)
		        	PoisonDamage = PawnOwner.Health -1;
				PawnOwner.Health -= PoisonDamage;
				
				if(Instigator != None && Instigator != PawnOwner.Instigator) //exp only for harming others.
				{
				    if (RPGRules != None)
						RPGRules.AwardEXPForDamage(Instigator.Controller, RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv')), PawnOwner, PoisonDamage);
					// and add the damage as healable
					class'DruidPoisonInv'.static.AddHealableDamage(PoisonDamage, PawnOwner);
				}
			}
		}
	}

	if (Level.NetMode != NM_DedicatedServer && PawnOwner != None)
	{
		PawnOwner.Spawn(class'GoopSmoke');
		if (PawnOwner.IsLocallyControlled() && PlayerController(PawnOwner.Controller) != None)
			PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'PoisonBlastConditionMessage', 0);
	}
	//dont call super. Bad things will happen.
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
	stopEffect();
	super.destroyed();
}

defaultproperties
{
     BasePercentage=0.035000
     curve=1.300000
     AdrenLost=1.500000
}
