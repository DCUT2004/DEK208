class ArtifactMassHeal extends EnhancedRPGArtifact
	config(UT2004RPG);

var config int RegenAmount, CostPerPlayer, RegenTime;
var int HealthMaxPlus;
var float EXPMultiplier;
var ArtifactMakeSuperHealer AMSH; //set on construction. Used to obtain health and exp bonus numbers.
var config float MinimumAdren, AdrenPerPlayer;
var RPGRules Rules;
var Controller Controller1, Controller2, Controller3;

function PostBeginPlay()
{
	super.PostBeginPlay();
	CheckRPGRules();
	disable('Tick');
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

function BotConsider()
{
	if (bActive && Instigator.Health > 200)
	{
		Activate();		// switch off when not required
		return;
	}
		
	if (Instigator.Controller.Adrenaline < 30)
		return;

	if ( !bActive && Instigator.Health < 125 && NoArtifactsActive() && FRand() < 0.6 )
		Activate();
}

function Activate()
{
	local Vehicle V;
	
	Super(EnhancedRPGArtifact).Activate();
		
	if ((Instigator == None) || (Instigator.Controller == None))
	{
		bActive = false;
		GotoState('');
		return;	// really corrupt
	}
	
	if (Instigator.Controller.Adrenaline < AdrenalineRequired*AdrenalineUsage)
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, AdrenalineRequired*AdrenalineUsage, None, None, Class);	
		bActive = false;
		GotoState('');
		return;
	}
	
	V = Vehicle(Instigator);
	if (V != None )
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
		bActive = false;
		GotoState('');
		return;	// can't use in a vehicle
	}
	if (LastUsedTime + TimeBetweenUses > Instigator.Level.TimeSeconds)
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
		bActive = false;
		GotoState('');
		return;	// cannot use yet
	}
	
	//Reset all controllers
	Controller1 = None;
	Controller2 = None;
	Controller3 = None;
	
	//Loop around finding players with lowest HP
	GetController1();

	bActive = false;
	GotoState('');
	return;
}

function GetController1()
{
	local Controller C;
	local int LeastHealth;
	
	LeastHealth = 10000;
	C = Level.ControllerList;
	while (C != None)
	{
		// loop round finding strongest enemy to attack
		if ( C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && C.SameTeamAs(Instigator.Controller)
			&& DruidHealthRegenInv(C.Pawn.FindInventoryType(class'DruidHealthRegenInv')) == None
			&& !C.Pawn.IsA('Monster') && HardCoreInv(C.Pawn.FindInventoryType(class'HardCoreInv')) == None && C != Controller2 && C != Controller3)
		{
			if (C.Pawn.Health < LeastHealth)
			{
				LeastHealth = C.Pawn.Health;
				Controller1 = C;
			}
		}
		C = C.NextController;
	}
	
	GetController2();
}

function GetController2()
{
	local Controller C;
	local int LeastHealth;
	
	LeastHealth = 10000;
	C = Level.ControllerList;
	while (C != None)
	{
		// loop round finding strongest enemy to attack
		if ( C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && C.SameTeamAs(Instigator.Controller)
			&& DruidHealthRegenInv(C.Pawn.FindInventoryType(class'DruidHealthRegenInv')) == None
			&& !C.Pawn.IsA('Monster') && HardCoreInv(C.Pawn.FindInventoryType(class'HardCoreInv')) == None && C != Controller1 && C != Controller3)
		{
			if (C.Pawn.Health < LeastHealth)
			{
				LeastHealth = C.Pawn.Health;
				Controller2 = C;
			}
		}
		C = C.NextController;
	}
	
	GetController3();
}

function GetController3()
{
	local Controller C;
	local int LeastHealth;
	
	LeastHealth = 10000;
	C = Level.ControllerList;
	while (C != None)
	{
		// loop round finding strongest enemy to attack
		if ( C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && C.SameTeamAs(Instigator.Controller)
			&& DruidHealthRegenInv(C.Pawn.FindInventoryType(class'DruidHealthRegenInv')) == None
			&& !C.Pawn.IsA('Monster') && HardCoreInv(C.Pawn.FindInventoryType(class'HardCoreInv')) == None && C != Controller1 && C != Controller2)
		{
			if (C.Pawn.Health < LeastHealth)
			{
				LeastHealth = C.Pawn.Health;
				Controller3 = C;
			}
		}
		C = C.NextController;
	}
	
	ProvideHealing();
}

function ProvideHealing()
{
	local DruidHealthRegenInv Inv1, Inv2, Inv3;
	
	ExpMultiplier = getExpMultiplier();
	HealthMaxPlus = getMaxHealthBonus();
	
	if (Controller1 != None && Controller1.Pawn != None)
	{
		if (Controller1.Pawn.Health < Controller1.Pawn.HealthMax + HealthMaxPlus)
		{
			Inv1 = DruidHealthRegenInv(Controller1.Pawn.FindInventoryType(class'DruidHealthRegenInv'));
			if (Inv1 == None)
			{
				Inv1 = Spawn(class'DruidHealthRegenInv', Controller1.Pawn);
				Inv1.Rules = Rules;
				Inv1.ExpMultiplier = ExpMultiplier;
				Inv1.RegenAmount = RegenAmount;
				Inv1.RegenTime = RegenTime;
				Inv1.HealthMaxPlus = HealthMaxPlus;
				Inv1.InvPlayerController = Instigator.Controller;
				Inv1.ShamanActivated = True;
				Inv1.GiveTo(Controller1.Pawn);
			}
		}
	}
	if (Controller2 != None && Controller2.Pawn != None)
	{
		if (Controller2.Pawn.Health < Controller2.Pawn.HealthMax + HealthMaxPlus)
		{
			Inv2 = DruidHealthRegenInv(Controller2.Pawn.FindInventoryType(class'DruidHealthRegenInv'));
			if (Inv2 == None)
			{
				Inv2 = Spawn(class'DruidHealthRegenInv', Controller2.Pawn);
				Inv2.Rules = Rules;
				Inv2.ExpMultiplier = ExpMultiplier;
				Inv2.RegenAmount = RegenAmount;
				Inv2.RegenTime = RegenTime;
				Inv2.HealthMaxPlus = HealthMaxPlus;
				Inv2.InvPlayerController = Instigator.Controller;
				Inv2.ShamanActivated = True;
				Inv2.GiveTo(Controller2.Pawn);
			}
		}
	}
	if (Controller3 != None && Controller3.Pawn != None)
	{
		if (Controller3.Pawn.Health < Controller3.Pawn.HealthMax + HealthMaxPlus)
		{
			Inv3 = DruidHealthRegenInv(Controller3.Pawn.FindInventoryType(class'DruidHealthRegenInv'));
			if (Inv3 == None)
			{
				Inv3 = Spawn(class'DruidHealthRegenInv', Controller3.Pawn);
				Inv3.Rules = Rules;
				Inv3.ExpMultiplier = ExpMultiplier;
				Inv3.RegenAmount = RegenAmount;
				Inv3.RegenTime = RegenTime;
				Inv3.HealthMaxPlus = HealthMaxPlus;
				Inv3.InvPlayerController = Instigator.Controller;
				Inv3.ShamanActivated = True;
				Inv3.GiveTo(Controller3.Pawn);
			}
		}
	}
	SetRecoveryTime(TimeBetweenUses*TimeUsage);
	Instigator.Controller.Adrenaline -= AdrenalineRequired*AdrenalineUsage;
	if (Instigator.Controller.Adrenaline < 0)
		Instigator.Controller.Adrenaline = 0;
	
	Instigator.Spawn(class'MassHealEffect', Instigator,, Instigator.Location, Instigator.Rotation);
}

function float getExpMultiplier()
{
	if(AMSH == None)
		AMSH = ArtifactMakeSuperHealer(Instigator.FindInventoryType(class'ArtifactMakeSuperHealer'));
	if(AMSH != None)
		return AMSH.EXPMultiplier;
	else
		return class'RW_Healer'.default.EXPMultiplier;
}

function int getMaxHealthBonus()
{
	if(AMSH == None)
		AMSH = ArtifactMakeSuperHealer(Instigator.FindInventoryType(class'ArtifactMakeSuperHealer'));
	if(AMSH != None)
		return AMSH.MaxHealth;
	else
		return class'RW_Healer'.default.MaxHealth;
}

exec function TossArtifact()
{
	//do nothing. This artifact cant be thrown
}

function DropFrom(vector StartLocation)
{
	if (bActive)
		GotoState('');
	bActive = false;

	Destroy();
	Instigator.NextItem();
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle";
	else if (Switch == 4000)
		return "Cannot use this artifact yet.";
	else
		return "At least" @ switch @ "adrenaline is required to use this artifact";
}

defaultproperties
{
	 AdrenalineRequired=25
	 TimeBetweenUses=15
	 RegenAmount=10
     RegenTime=15
     IconMaterial=FinalBlend'AWGlobal.Shaders.ColdFinal'
     ItemName="Sacrificial Heal"
}
