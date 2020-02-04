class ArtifactMissionTeamMusicalWeapons extends ArtifactMission
		config(UT2004RPG);

#exec  AUDIO IMPORT NAME="MPSelect" FILE="C:\UT2004\Sounds\MPSelect.WAV" GROUP="MissionSounds"

function Activate()
{
	local Controller C;
	
	Inv = MissionInv(Instigator.FindInventoryType(class'MissionInv'));
	MMPI = MissionMultiplayerInv(Instigator.FindInventoryType(class'MissionMultiplayerInv'));
	
	if ((Instigator != None) && (Instigator.Controller != None))
	{
		if (Inv == None || MMPI == None)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 1000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		if (!MMPI.Stopped)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		if (MMPI.MusicalWeaponsActive)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}

		if (MMPI != None && MMPI.stopped && !MMPI.MusicalWeaponsActive)
		{
			MMPI.Stopped = False;
			MMPI.MasterMMPI = True;
			MMPI.default.MMPIOwner = Instigator;
			MMPI.MusicalWeaponsActive = True;
			MMPI.MissionName = default.ItemName;
			MMPI.Description = default.Description;
			MMPI.SetTimer(MMPI.CheckInterval, True);
			MMPI.TimeLimit = default.TimeLimit;
			MMPI.MissionXP = XPReward;
			MMPI.MissionGoal = MissionGoal;
			//Let's start off with setting a random weapon, then let MMPI handle the rest.
			if (Rand(99) <= 12.5)
				MMPI.AVRiLActive = True;
			else if (Rand(99) <= 25)
				MMPI.BioActive = True;
			else if (Rand(99) <= 37.5)
				MMPI.ShockActive = True;
			else if (Rand(99) <= 50)
				MMPI.LinkActive = True;
			else if (Rand(99) <= 62.5)
				MMPI.MinigunActive = True;
			else if (Rand(99) <= 75)
				MMPI.FlakActive = True;
			else if (Rand(99) <= 87.5)
				MMPI.RocketActive = True;
			else
				MMPI.LightningActive = True;
			for ( C = Level.ControllerList; C != None; C = C.NextController )
				if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(Instigator.Controller) )
					PlayerController(C).ClientPlaySound(Sound'DEKRPG208.MissionSounds.MPSelect');
			SetTimer(0.5,True);
			MMPI.TeamMissionBroadcast();
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
	else if (Switch == 2000)
		return "A team mission or minigame is already currently active.";
}

defaultproperties
{
     XPReward=50
     MissionGoal=20
	 TimeLimit=120
	 TeamMission=True
     PickupClass=Class'DEKRPG208.ArtifactMissionTeamMusicalWeaponsPickup'
     IconMaterial=Texture'MissionsTex4.TeamMissions.MusicalWeapons'
     ItemName="Musical Weapons"
	 Description="(T)Make kills with the correct weapon."
}
