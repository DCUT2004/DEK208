class ArtifactMissionTeamPortalBall extends ArtifactMission
		config(UT2004RPG);
		
var config int XPPerScore;

#exec  AUDIO IMPORT NAME="MPSelect" FILE="C:\UT2004\Sounds\MPSelect.WAV" GROUP="MissionSounds"

function Activate()
{
	local NavigationPoint Dest;
	local Controller C;
	local MissionPortalBallSpawnerInv SpawnerInv;
	
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
		if (MMPI.PortalBallActive)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		Dest = Instigator.Controller.FindRandomDest();
		SpawnerInv = MissionPortalBallSpawnerInv(Instigator.FindInventoryType(class'MissionPortalBallSpawnerInv'));
		if (SpawnerInv == None)
		{
			SpawnerInv = Spawn(class'MissionPortalBallSpawnerInv', Instigator);
			SpawnerInv.GiveTo(Instigator);
			if (SpawnerInv != None)
			{
				SpawnerInv.XPPerScore = XPPerScore;
				if (MMPI != None && MMPI.stopped && !MMPI.PortalBallActive)
				{
					MMPI.Stopped = False;
					MMPI.MasterMMPI = True;
					MMPI.default.MMPIOwner = Instigator;
					MMPI.PortalBallActive = True;
					MMPI.MissionName = default.ItemName;
					MMPI.Description = default.Description;
					MMPI.SetTimer(MMPI.CheckInterval, True);
					MMPI.TimeLimit = default.TimeLimit;
					MMPI.MissionXP = XPReward;
					MMPI.MissionGoal = MissionGoal;
					for ( C = Level.ControllerList; C != None; C = C.NextController )
						if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(Instigator.Controller) )
							PlayerController(C).ClientPlaySound(Sound'DEKRPG208.MissionSounds.MPSelect');
				}
				SetTimer(0.5,True);
				MMPI.TeamMissionBroadcast();
			}
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
	else if (Switch == 3000)
		return "Portal could not spawn. Try again.";
}

defaultproperties
{
	 XPPerScore=5
     XPReward=25
     MissionGoal=15
	 TimeLimit=120
	 TeamMission=True
     PickupClass=Class'DEKRPG208.ArtifactMissionTeamPortalBallPickup'
     IconMaterial=Texture'MissionsTex4.TeamMissions.PortalBall'
     ItemName="Portal Ball"
	 Description="(T)Shoot the ball into the portal!"
}
