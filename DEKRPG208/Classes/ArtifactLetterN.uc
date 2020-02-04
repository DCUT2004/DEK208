class ArtifactLetterN extends RPGArtifact
		config(UT2004RPG);

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');
}

function Activate()
{
	local Vehicle V;

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
		Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
	}
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle";
	if (Switch == 4000)
		return "Collect letters BONUS and activate with B to unlock wave 17!";
}

defaultproperties
{
     MinActivationTime=0.000001
     PickupClass=Class'DEKRPG208.ArtifactLetterNPickup'
     IconMaterial=Texture'DEKRPGTexturesMaster207P.Artifacts.BONUS_N'
     ItemName="N"
}
