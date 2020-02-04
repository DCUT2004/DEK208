class GuardianHealInv extends Inventory;

var Controller InstigatorController;
var Pawn PawnOwner;
var RPGRules Rules;
var config float HealingRadius,ChargeTime;
var Controller GuardianController;
var ArtifactGuardianHeal AGH;
var float EXPMultiplier;
var int HealthMaxPlus;
var config int HealthThreshold, AdrenalineRequired;
var GuardianMarker Marker;
var ArtifactMakeSuperHealer AMSH; //set on construction. Used to obtain health and exp bonus numbers.

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner, GuardianController;
}

simulated function PostBeginPlay()
{
	if (Instigator != None)
		InstigatorController = Instigator.Controller;
	CheckRPGRules();
		
	Super.PostBeginPlay();
}

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}
	}

	if(Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local Pawn OldInstigator;

	if(Other == None)
	{
		destroy();
		return;
	}

	if (InstigatorController == None)
		InstigatorController = Other.Controller;

	//want Instigator to be the one that caused the freeze
	OldInstigator = Instigator;
	Super.GiveTo(Other);
	PawnOwner = Other;

	Instigator = OldInstigator;
	
	if (GuardianController.Pawn != None)
	{
		Marker = PawnOwner.spawn(class'GuardianMarker',PawnOwner,,PawnOwner.Location,PawnOwner.Rotation);
		if (Marker != None)
		{
			Marker.SetBase(PawnOwner);
			Marker.RemoteRole = ROLE_SimulatedProxy;
		}
	}
	if (PawnOwner != None)
		PawnOwner.ReceiveLocalizedMessage(class'GuardianGrantedMessage', 0, GuardianController.PlayerReplicationInfo);
	SetTimer(0.5, true);
}

simulated function Timer()
{
	local HealingBlastCharger HBC;
	local ArtifactHealingBlast AHB;
	
	AHB = ArtifactHealingBlast(GuardianController.Pawn.FindInventoryType(class'ArtifactHealingBlast'));
	ExpMultiplier = getExpMultiplier();
	HealthMaxPlus = getMaxHealthBonus();
	
	if (Instigator == None && InstigatorController != None)
		Instigator = InstigatorController.Pawn;
	if (PawnOwner == None || PawnOwner.Health <= 0)
	{
		PlayerController(GuardianController).ReceiveLocalizedMessage(class'GuardianRemoveMessage', 1);
		Destroy();
		return;
	}
	if (GuardianController.PlayerReplicationInfo != None && GuardianController.PlayerReplicationInfo.bOutofLives)
	{
		PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'GuardianRemoveMessage', 0);
		Destroy();
		return;
	}
	if (Role == ROLE_Authority)
	{
		if(PawnOwner != None)
		{
			if (PawnOwner.Health < HealthThreshold && GuardianController.Adrenaline >= AdrenalineRequired)
			{
				HBC = GuardianController.Pawn.spawn(class'HealingBlastCharger', GuardianController,,PawnOwner.Location);
				if(HBC != None)
				{
					HBC.InstigatorController = GuardianController;
					HBC.RPGRules = Rules;
					HBC.HealingRadius = HealingRadius;
					HBC.ChargeTime = ChargeTime;
					HBC.EXPMultiplier = EXPMultiplier;
					HBC.MaxHealth = HealthMaxPlus;

					GuardianController.Adrenaline -= AdrenalineRequired;
					if (GuardianController.Adrenaline < 0)
						GuardianController.Adrenaline = 0;
						
					GuardianController.Pawn.ReceiveLocalizedMessage(class'GuardianHealMessage', 0, PawnOwner.Controller.PlayerReplicationInfo);
				}
			}
		}
	}
}

function int getMaxHealthBonus()
{
	if(AMSH == None)
		AMSH = ArtifactMakeSuperHealer(GuardianController.Pawn.FindInventoryType(class'ArtifactMakeSuperHealer'));
	if(AMSH != None)
		return AMSH.MaxHealth;
	else
		return class'RW_Healer'.default.MaxHealth;
}

function float getExpMultiplier()
{
	if(AMSH == None)
		AMSH = ArtifactMakeSuperHealer(GuardianController.Pawn.FindInventoryType(class'ArtifactMakeSuperHealer'));
	if(AMSH != None)
		return AMSH.EXPMultiplier;
	else
		return class'RW_Healer'.default.EXPMultiplier;
}

function stopEffect()
{
	if (GuardianController.Pawn != None)
	{
		AGH = ArtifactGuardianHeal(GuardianController.Pawn.FindInventoryType(class'ArtifactGuardianHeal'));
		if (AGH != None)
		{
			AGH.NumPlayers = 0;		//If any time guardian heal gets destroyed, num players should reset to 0.
			if (AGH.NumPlayers < 0)
				AGH.NumPlayers = 0;
			AGH.TargetPlayer = None;
		}
		
	}
	if (Marker != None)
		Marker.Destroy();
}

function destroyed()
{
	stopEffect();
	super.destroyed();
}

defaultproperties
{
     HealingRadius=1100.000000
     ChargeTime=0.050000
     HealthThreshold=50
     AdrenalineRequired=50
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
