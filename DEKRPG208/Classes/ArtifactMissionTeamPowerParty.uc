class ArtifactMissionTeamPowerParty extends ArtifactMission
		config(UT2004RPG);
		
var config int TitanWave1;
var config int TitanWave2;
var config int XPRewardTitanWave;
var config int MissionGoalTitanWave;
var config int TimeLimitTitanWave;

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
		if (MMPI.PowerPartyActive)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}

		if (MMPI != None && MMPI.stopped && !MMPI.PowerPartyActive)
		{
			MMPI.Stopped = False;
			MMPI.MasterMMPI = True;
			MMPI.default.MMPIOwner = Instigator;
			MMPI.PowerPartyActive = True;
			MMPI.MissionName = default.ItemName;
			MMPI.Description = default.Description;
			MMPI.SetTimer(MMPI.CheckInterval, True);
			if (Invasion(Level.Game) != None)
			{
				if (Invasion(Level.Game).WaveNum == default.TitanWave1 || Invasion(Level.Game).WaveNum == default.TitanWave2)
				{
					MMPI.TimeLimit = default.TimeLimitTitanWave;
					MMPI.MissionXP = XPRewardTitanWave;
					MMPI.MissionGoal = MissionGoalTitanWave;
				}
				else
				{
					MMPI.TimeLimit = default.TimeLimit;
					MMPI.MissionXP = XPReward;
					MMPI.MissionGoal = MissionGoal;
				}
			}
			else
			{
				MMPI.TimeLimit = default.TimeLimit;
				MMPI.MissionXP = XPReward;
				MMPI.MissionGoal = MissionGoal;
			}
			for ( C = Level.ControllerList; C != None; C = C.NextController )
				if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(Instigator.Controller) )
					PlayerController(C).ClientPlaySound(Sound'DEKRPG208.MissionSounds.MPSelect');
			SetTimer(0.5,True);
			MMPI.TeamMissionBroadcast();
		}
		else if (MMPI.PowerPartyActive)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
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
     MissionGoal=5000
	 TimeLimit=60
	 TitanWave1=5
	 TitanWave2=13
	 XPRewardTitanWave=20
	 MissionGoalTitanWave=10000
	 TimeLimitTitanWave=120
	 TeamMission=True
     PickupClass=Class'DEKRPG208.ArtifactMissionTeamPowerPartyPickup'
     IconMaterial=Texture'MissionsTex4.TeamMissions.PowerParty'
     ItemName="Power Party"
	 Description="(T)Do as much damage as a team."
}
