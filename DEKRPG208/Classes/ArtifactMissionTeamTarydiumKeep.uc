class ArtifactMissionTeamTarydiumKeep extends ArtifactMission
		config(UT2004RPG);

#exec  AUDIO IMPORT NAME="MPSelect" FILE="C:\UT2004\Sounds\MPSelect.WAV" GROUP="MissionSounds"

function Activate()
{
	local Controller C;
	local NavigationPoint Dest;
	local TarydiumCrystal TC;
	
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
		if (MMPI.TarydiumKeepActive)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		Dest = Instigator.Controller.FindRandomDest();
		if (MMPI != None && MMPI.stopped && !MMPI.TarydiumKeepActive)
		{
			TC = Instigator.spawn(class'TarydiumCrystal',,,Dest.Location + vect(0,0,40));
			if (TC != None)
			{
				TC.SetTeamNum(Instigator.GetTeamNum());
				if (TC.Controller != None)
					TC.Controller.Destroy();
				TC.SetTimer(1, True);
				TC.Spawner = Instigator;
				TC.Health = TC.HealthMax;
				MMPI.Stopped = False;
				MMPI.MasterMMPI = True;
				MMPI.default.MMPIOwner = Instigator;
				MMPI.TC = TC;
				MMPI.TCHealth = TC.Health;
				MMPI.TarydiumKeepActive = True;
				MMPI.MissionName = default.ItemName;
				MMPI.Description = default.Description;
				MMPI.SetTimer(MMPI.CheckInterval, True);
				MMPI.TimeLimit = default.TimeLimit;
				MMPI.MissionXP = XPReward;
				MMPI.MissionGoal = MissionGoal;
				for ( C = Level.ControllerList; C != None; C = C.NextController )
					if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(Instigator.Controller) )
						PlayerController(C).ClientPlaySound(Sound'DEKRPG208.MissionSounds.MPSelect');
				SetTimer(0.5,True);
				MMPI.TeamMissionBroadcast();
			}
			else
			{
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
		return "Tarydium could not spawn. Try again.";
}

defaultproperties
{
     XPReward=50
     MissionGoal=120	//time in seconds to defend tarydium
	 TimeLimit=130		//this MUST be kept equal to or greater than MissionGoal.
	 TeamMission=True
     PickupClass=Class'DEKRPG208.ArtifactMissionTeamTarydiumKeepPickup'
     IconMaterial=Texture'MissionsTex4.TeamMissions.TarydiumKeep'
     ItemName="Tarydium Keep"
	 Description="(T)Defend the tarydium crystals!"
}
