class ArtifactLetterB extends RPGArtifact
		config(UT2004RPG);
		
var config int ScoreAdd;

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');
}

function Activate()
{
	local Vehicle V;
	local ArtifactLetterO O;
	local ArtifactLetterN N;
	local ArtifactLetterU U;
	local ArtifactLetterS S;
	local PlayerReplicationInfo PRI;
	
	O = ArtifactLetterO(Instigator.FindInventoryType(class'ArtifactLetterO'));
	N = ArtifactLetterN(Instigator.FindInventoryType(class'ArtifactLetterN'));
	U = ArtifactLetterU(Instigator.FindInventoryType(class'ArtifactLetterU'));
	S = ArtifactLetterS(Instigator.FindInventoryType(class'ArtifactLetterS'));
	
	PRI = Instigator.PlayerReplicationInfo;

	if (Instigator != None)
	{
		
		V = Vehicle(Instigator);
		if (V != None )
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// can't use in a vehicle

		}
		
		if (O == None || N == None || U == None || S == None)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// can't use in a vehicle
		}

		if (Invasion(Level.Game) != None && O != None && N != None && U != None && S != None)
		{
			Invasion(Level.Game).FinalWave = 17;
			BroadcastLocalizedMessage(class'BonusWaveMessage',, PRI);
			PRI.Score += default.ScoreAdd;
			Instigator.PlaySound(Sound'PwrNodeBuilt01', SLOT_None);
		}
		setTimer(0.6, true);
	}
}

function Timer()
{
	local ArtifactLetterO O;
	local ArtifactLetterN N;
	local ArtifactLetterU U;
	local ArtifactLetterS S;
	
	O = ArtifactLetterO(Instigator.FindInventoryType(class'ArtifactLetterO'));
	N = ArtifactLetterN(Instigator.FindInventoryType(class'ArtifactLetterN'));
	U = ArtifactLetterU(Instigator.FindInventoryType(class'ArtifactLetterU'));
	S = ArtifactLetterS(Instigator.FindInventoryType(class'ArtifactLetterS'));
	
	Destroy();			// was a one shot artifact
	Instigator.NextItem();
	if (O != None)
	{
		O.Destroy();
		Instigator.NextItem();
	}
	if (N != None)
	{
		N.Destroy();
		Instigator.NextItem();
	}
	if (U != None)
	{
		U.Destroy();
		Instigator.NextItem();
	}
	if (S != None)
	{
		S.Destroy();
		Instigator.NextItem();
	}
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle";
	if (Switch == 4000)
		return "You do not have all letters that spell BONUS.";
	else
		return switch @ "Adrenaline is required to use this artifact";
}

defaultproperties
{
     ScoreAdd=10
     MinActivationTime=0.000001
     PickupClass=Class'DEKRPG208.ArtifactLetterBPickup'
     IconMaterial=Texture'DEKRPGTexturesMaster207P.Artifacts.BONUS_B'
     ItemName="B"
}
