class ArtifactMissionTeamBalloonPop extends ArtifactMission
		config(UT2004RPG);

#exec  AUDIO IMPORT NAME="MPSelect" FILE="C:\UT2004\Sounds\MPSelect.WAV" GROUP="MissionSounds"

function PostBeginPlay()
{
	TeamMission = True;
	Super.PostBeginPlay();
}

function Activate()
{
	local Controller C;
	local MissionBalloonSpawnerInv BalloonInv;
	
	Inv = MissionInv(Instigator.FindInventoryType(class'MissionInv'));
	MMPI = MissionMultiplayerInv(Instigator.FindInventoryType(class'MissionMultiplayerInv'));
	BalloonInv = MissionBalloonSpawnerInv(Instigator.FindInventoryType(class'MissionBalloonSpawnerInv'));
	
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
		if (MMPI.BalloonPopActive)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		if (MMPI != None && MMPI.stopped && !MMPI.BalloonPopActive)
		{
			MMPI.Stopped = False;
			MMPI.MasterMMPI = True;
			MMPI.default.MMPIOwner = Instigator;
			MMPI.BalloonPopActive = True;
			MMPI.MissionName = default.ItemName;
			MMPI.Description = default.Description;
			MMPI.SetTimer(MMPI.CheckInterval, True);
			MMPI.TimeLimit = default.TimeLimit;
			MMPI.MissionXP = XPReward;
			MMPI.MissionGoal = MissionGoal;
			for ( C = Level.ControllerList; C != None; C = C.NextController )
				if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(Instigator.Controller) )
					PlayerController(C).ClientPlaySound(Sound'DEKRPG208.MissionSounds.MPSelect');
			if (BalloonInv == None)
			{
				BalloonInv = spawn(class'MissionBalloonSpawnerInv', Instigator,,, rot(0,0,0));
				BalloonInv.GiveTo(Instigator);
			}
		}
		SetTimer(0.5,True);
		MMPI.TeamMissionBroadcast();
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
     XPReward=25
     MissionGoal=40
	 TimeLimit=80
	 TeamMission=True
     PickupClass=Class'DEKRPG208.ArtifactMissionTeamBalloonPopPickup'
     IconMaterial=Texture'MissionsTex4.TeamMissions.BalloonPop'
     ItemName="Balloon Pop"
	 Description="(T)Pop the balloons!"
}
