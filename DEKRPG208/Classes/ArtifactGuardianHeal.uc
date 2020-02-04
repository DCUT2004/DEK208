class ArtifactGuardianHeal extends EnhancedRPGArtifact
		config(UT2004RPG);

var RPGRules Rules;
var int NumPlayers;
var config int MaxNumPlayers;
var class<xEmitter> HitEmitterClass;
var config float MaxRange, HealingRadius, ChargeTime;
var float EXPMultiplier;
var int HealthMaxPlus;
var ArtifactMakeSuperHealer AMSH; //set on construction. Used to obtain health and exp bonus numbers.
var config int HealthThreshold;
var Pawn TargetPlayer;

replication
{
	reliable if (Role == ROLE_Authority)
		TargetPlayer;	
}

function BotConsider()
{
	return;		// the chance of a bot using this correctly is soo low as to be not worth it.
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');

	CheckRPGRules();
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

function Activate()
{
	local Vehicle V;
	local Vector FaceDir;
	local Vector BeamEndLocation;
	local vector HitLocation;
	local vector HitNormal;
	local Actor AHit;
	local Pawn  HitPawn;
	local Vector StartTrace;
	local GuardianHealInv Inv;
	local xEmitter HitEmitter;

	if ((Instigator == None) || (Instigator.Controller == None))
	{
		bActive = false;
		GotoState('');
		return;	// really corrupt
	}

	V = Vehicle(Instigator);
	if (V != None )
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
		bActive = false;
		GotoState('');
		return;	// can't use in a vehicle
	}
	// lets see what we hit then
	FaceDir = Vector(Instigator.Controller.GetViewRotation());
	StartTrace = Instigator.Location + Instigator.EyePosition();
	BeamEndLocation = StartTrace + (FaceDir * MaxRange);

	// See if we hit something.
	AHit = Trace(HitLocation, HitNormal, BeamEndLocation, StartTrace, true);
	if ((AHit == None) || (Pawn(AHit) == None) || (Pawn(AHit).Controller == None))
	{
		bActive = false;
		GotoState('');
		return;	// didn't hit an enemy
	}

	HitPawn = Pawn(AHit);
	if (HitPawn != None && HitPawn != Instigator && HitPawn.Health > 0 && VSize(HitPawn.Location - StartTrace) < MaxRange && Vehicle(HitPawn) == None && HardCoreInv(HitPawn.FindInventoryType(class'HardCoreInv')) == None)
	{
		if (HitPawn.Controller.SameTeamAs(Instigator.Controller))
		{
			//Got it.
			ExpMultiplier = getExpMultiplier();
			HealthMaxPlus = getMaxHealthBonus();
			Inv = GuardianHealInv(HitPawn.FindInventoryType(class'GuardianHealInv'));
			if (Inv == None && NumPlayers < MaxNumPlayers)
			{
				Inv = spawn(class'GuardianHealInv', HitPawn,,, rot(0,0,0));
				Inv.GuardianController = Instigator.Controller;
				Inv.Rules = Rules;
				Inv.HealthThreshold = HealthThreshold;
				Inv.HealingRadius = HealingRadius;
				Inv.ChargeTime = ChargeTime;
				Inv.EXPMultiplier = EXPMultiplier;
				Inv.HealthMaxPlus = HealthMaxPlus;
				Inv.AdrenalineRequired = AdrenalineRequired;
				Inv.GiveTo(HitPawn);
				TargetPlayer = HitPawn;
				Instigator.ReceiveLocalizedMessage(MessageClass, 5000, None, None, Class);
				HitEmitter = spawn(HitEmitterClass,,, (StartTrace + Instigator.Location)/2, rotator(HitLocation - ((StartTrace + Instigator.Location)/2)));
				if (HitEmitter != None)
				{
					HitEmitter.mSpawnVecA = HitPawn.Location;
				}
				NumPlayers++;
			}
			else if (Inv == None && NumPlayers >= MaxNumPlayers)
			{
				Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
				return;
			}
			else if (Inv != None && Inv.GuardianController == Instigator.Controller && NumPlayers >= MaxNumPlayers)
			{
				NumPlayers = 0;
				Inv.Destroy();
				Instigator.ReceiveLocalizedMessage(MessageClass, 6000, None, None, Class);
				TargetPlayer = None;
			}
			else if (Inv != None && Inv.GuardianController != Instigator.Controller)
			{
				Instigator.ReceiveLocalizedMessage(MessageClass, 7000, None, None, Class);
				return;
			}
		}
	}
	bActive = false;
	GotoState('');
	return;
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

function float getExpMultiplier()
{
	if(AMSH == None)
		AMSH = ArtifactMakeSuperHealer(Instigator.FindInventoryType(class'ArtifactMakeSuperHealer'));
	if(AMSH != None)
		return AMSH.EXPMultiplier;
	else
		return class'RW_Healer'.default.EXPMultiplier;
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle";
	else if (Switch == 4000)
		return "You are already guarding someone. Activate artifact on that person again to remove the guard.";
	else if (Switch == 5000)
		return "Guard target selected.";
	else if (Switch == 6000)
		return "Guard target removed.";
	else if (Switch == 7000)
		return "This person is already guarded by someone else.";
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

defaultproperties
{
	 AdrenalineRequired=100
     MaxNumPlayers=1
     HitEmitterClass=Class'DEKRPG208.LightningBeamEmitter'
     MaxRange=2000.000000
     HealingRadius=1100.000000
     ChargeTime=0.050000
     HealthThreshold=50
     IconMaterial=Texture'ONSstructureTextures.CoreBreachGroup.CoreBreachShockRINGedge'
     ItemName="Guardian Heal"
}
