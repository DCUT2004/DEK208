class ArtifactMissionTeamRingAndHold extends ArtifactMission
		config(UT2004RPG);

#exec  AUDIO IMPORT NAME="MPSelect" FILE="C:\UT2004\Sounds\MPSelect.WAV" GROUP="MissionSounds"

function Activate()
{
	local Controller C;
	local NavigationPoint Dest1, Dest2, Dest3;
	local RingRed RR;
	local RingBlue RB;
	local RingGold RG;
	
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
		if (MMPI.RingAndHoldActive)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		
		if (MMPI != None && MMPI.stopped && !MMPI.RingAndHoldActive)
		{
			Dest1 = Instigator.Controller.FindRandomDest();
			Dest2 = Instigator.Controller.FindRandomDest();
			Dest3 = Instigator.Controller.FindRandomDest();
		
			RR = Instigator.spawn(class'RingRed',,,Dest1.Location + vect(0,0,40));
			if (RR != None)
			{
				RR.SetTeamNum(Instigator.GetTeamNum());
				if (RR.Controller != None)
					RR.Controller.Destroy();
			}
			RB = Instigator.spawn(class'RingBlue',,,Dest2.Location + vect(0,0,40));
			if (RB != None)
			{
				RB.SetTeamNum(Instigator.GetTeamNum());
				if (RB.Controller != None)
					RB.Controller.Destroy();
			}
			RG = Instigator.spawn(class'RingGold',,,Dest3.Location + vect(0,0,40));
			if (RG != None)
			{
				RG.Spawner = Instigator;
				RG.SetTeamNum(Instigator.GetTeamNum());
				if (RG.Controller != None)
					RG.Controller.Destroy();
			}
			if (RR != None && RG != None && RB != None)
			{
				MMPI.Stopped = False;
				MMPI.MasterMMPI = True;
				MMPI.default.MMPIOwner = Instigator;
				MMPI.RingAndHoldActive = True;
				MMPI.MissionName = default.ItemName;
				MMPI.Description = default.Description;
				MMPI.SetTimer(MMPI.CheckInterval, True);
				MMPI.TimeLimit = default.TimeLimit;
				MMPI.MissionXP = XPReward;
				MMPI.MissionGoal = MissionGoal;
				MMPI.RR = RR;
				MMPI.RB = RB;
				MMPI.RG = RG;
				RG.RR = RR;
				RG.RB = RB;
				for ( C = Level.ControllerList; C != None; C = C.NextController )
					if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(Instigator.Controller) )
						PlayerController(C).ClientPlaySound(Sound'DEKRPG208.MissionSounds.MPSelect');
				SetTimer(0.5,True);
				MMPI.TeamMissionBroadcast();
			}
			else
			{
				if (RR != None)
					RR.Destroy();
				if (RB != None)
					RB.Destroy();
				if (RG != None)
					RG.Destroy();
				Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
				bActive = false;
				GotoState('');
				return;
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
		return "One or more rings could not spawn. Try again.";
}

defaultproperties
{
     XPReward=50
     MissionGoal=10
	 TimeLimit=130
	 TeamMission=True
     PickupClass=Class'DEKRPG208.ArtifactMissionTeamRingAndHoldPickup'
     IconMaterial=Texture'MissionsTex4.TeamMissions.RingAndHold'
     ItemName="Ring and Hold"
	 Description="(T)Hold position at each of three rings simultaneously!"
}
