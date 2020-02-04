class ArtifactMissionCowCare extends ArtifactMission
		config(UT2004RPG);

var MissionCowCareInv MInv;

function Activate()
{
	Super(ArtifactMission).Activate();
	Inv = MissionInv(Instigator.FindInventoryType(class'MissionInv'));
	M1Inv = Mission1Inv(Instigator.FindInventoryType(class'Mission1Inv'));
	M2Inv = Mission2Inv(Instigator.FindInventoryType(class'Mission2Inv'));
	M3Inv = Mission3Inv(Instigator.FindInventoryType(class'Mission3Inv'));
	MInv = MissionCowCareInv(Instigator.FindInventoryType(class'MissionCowCareInv'));
	
	if ((Instigator != None) && (Instigator.Controller != None))
	{
		if (Inv == None || M1Inv == None || M2Inv == None || M3Inv == None)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 1000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		MInv = spawn(class'MissionCowCareInv', Instigator,,, rot(0,0,0));
		if (MInv != None)
		{
			MInv.GiveTo(Instigator);
			MInv.SpawnCow();
			MInv.MissionXP = XPReward;
			if (PlayerController(Instigator.Controller) != None)
				PlayerController(Instigator.Controller).ClientPlaySound(Sound'AssaultSounds.HumanShip.HnShipFireReadyl01');
		}
	}
	bActive = false;
	GotoState('');
	return;			
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 1000)
		return "Cannot access mission.";
	if (Switch == 4000)
		return "Mission is already active.";
}

defaultproperties
{
     XPReward=15
     Description="Keep your cow alive each wave."
     PickupClass=Class'DEKRPG208.ArtifactMissionCowCarePickup'
     IconMaterial=Texture'MissionsTex4.MiscellaneousMissions.CowCareMission'
     ItemName="Cow Care"
}
