class ArtifactPaladin extends EnhancedRPGArtifact
		config(UT2004RPG);

var RPGRules Rules;
var class<xEmitter> HitEmitterClass;
var config float MaxRange;
var bool TargetChosen;
var Pawn TargetPlayer;
var config float ExpPerDamage;

replication
{
	reliable if (Role == ROLE_Authority)
		TargetChosen, TargetPlayer;	
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
	TargetChosen = False;
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
	local PaladinInv Inv;
	local RPGClassInv RPGInv;
	local xEmitter HitEmitter;
	local NecroInv NInv;
	
	Super(EnhancedRPGArtifact).Activate();

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
		if (!TargetChosen)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// didn't hit an enemy
		}
		else if (TargetChosen)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 6000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// didn't hit an enemy
		}
	}

	HitPawn = Pawn(AHit);
	if (HitPawn != None && HitPawn != Instigator && HitPawn.Health > 0 && VSize(HitPawn.Location - StartTrace) < MaxRange && Vehicle(HitPawn) == None && HardCoreInv(HitPawn.FindInventoryType(class'HardCoreInv')) == None)
	{
		if (HitPawn.Controller.SameTeamAs(Instigator.Controller))
		{
			//Got it.
			//First check to see if they have a class selected or if they are under resurrection
			NInv = NecroInv(HitPawn.FindInventoryType(class'NecroInv'));
			RPGInv = RPGClassInv(HitPawn.FindInventoryType(class'RPGClassInv'));
			if (RPGInv == None || NInv != None)
			{
				Instigator.ReceiveLocalizedMessage(MessageClass, 7000, None, None, Class);
				bActive = false;
				GotoState('');
				return;
			}		
			//Now check to see if they are already protected
			Inv = PaladinInv(HitPawn.FindInventoryType(class'PaladinInv'));
			if (Inv != None)
			{
				if (Inv.GuardianController == Instigator.Controller)	//we've already set protection on this player. let's remove
				{
					Instigator.ReceiveLocalizedMessage(MessageClass, 8000, None, None, Class);
					Inv.Destroy();
					TargetPlayer = None;
					TargetChosen = False;
				}
				else	//set by someone else, leave alone
				{
					Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
					bActive = false;
					GotoState('');
					return;
				}
			}
			//Good
			else if (Inv == None)
			{
				if (!TargetChosen)
				{
					Inv = spawn(class'PaladinInv', HitPawn,,, rot(0,0,0));
					Inv.GuardianController = Instigator.Controller;
					Inv.AdrenalineRequired = AdrenalineRequired;
					Inv.ExpPerDamage = ExpPerDamage;
					Inv.GiveTo(HitPawn);
					TargetPlayer = HitPawn;
					Instigator.ReceiveLocalizedMessage(MessageClass, 5000, None, None, Class);
					TargetChosen = True;
					HitEmitter = spawn(HitEmitterClass,,, (StartTrace + Instigator.Location)/2, rotator(HitLocation - ((StartTrace + Instigator.Location)/2)));
					if (HitEmitter != None)
					{
						HitEmitter.mSpawnVecA = HitPawn.Location;
					}
				}
				else
				{
					Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
					bActive = false;
					GotoState('');
					return;
				}
			}
		}
	}
	bActive = false;
	GotoState('');
	return;
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 2000)
		return "Select a teammate to automatically cast invulnerability on when their HP is low.";	
	else if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle";
	else if (Switch == 4000)
		return "This person is already guarded.";
	else if (Switch == 5000)
		return "Guard target selected.";
	else if (Switch == 6000)
		return "You have already selected a player. Deselect by activating artifact on that player again.";
	else if (Switch == 7000)
		return "Cannot grant protection to this player.";
	else if (Switch == 8000)
		return "Protection removed from player.";
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
     ExpPerDamage=0.030000
	 AdrenalineRequired=200
     HitEmitterClass=Class'DEKRPG208.LightningBeamEmitter'
     MaxRange=2000.000000
     IconMaterial=Texture'DEKRPGTexturesMaster207P.Artifacts.PaladinGuard'
     ItemName="Paladin Guard"
}
