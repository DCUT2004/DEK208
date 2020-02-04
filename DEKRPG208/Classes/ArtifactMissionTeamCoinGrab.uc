class ArtifactMissionTeamCoinGrab extends ArtifactMission
		config(UT2004RPG);

#exec  AUDIO IMPORT NAME="MPSelect" FILE="C:\UT2004\Sounds\MPSelect.WAV" GROUP="MissionSounds"

function Activate()
{
	local Controller C;
	local MissionCoinSpawnerInv CoinInv;
	local bool bCanSpawn;
	
	Inv = MissionInv(Instigator.FindInventoryType(class'MissionInv'));
	MMPI = MissionMultiplayerInv(Instigator.FindInventoryType(class'MissionMultiplayerInv'));
	CoinInv = MissionCoinSpawnerInv(Instigator.FindInventoryType(class'MissionCoinSpawnerInv'));
	
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
		if (MMPI.CoinGrabActive)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		bCanSpawn = GetSpawnHeight(Instigator.Location);
		if (bCanSpawn)
		{
			if (MMPI != None && MMPI.stopped && !MMPI.CoinGrabActive)
			{
				MMPI.Stopped = False;
				MMPI.MasterMMPI = True;
				MMPI.default.MMPIOwner = Instigator;
				MMPI.CoinGrabActive = True;
				MMPI.MissionName = default.ItemName;
				MMPI.Description = default.Description;
				MMPI.SetTimer(MMPI.CheckInterval, True);
				MMPI.TimeLimit = default.TimeLimit;
				MMPI.CoinGrabXPPerCoin = XPReward;
				MMPI.MissionGoal = MissionGoal;
				for ( C = Level.ControllerList; C != None; C = C.NextController )
					if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(Instigator.Controller) )
						PlayerController(C).ClientPlaySound(Sound'DEKRPG208.MissionSounds.MPSelect');
				if (CoinInv == None)
				{
					CoinInv = spawn(class'MissionCoinSpawnerInv', Instigator,,, rot(0,0,0));
					CoinInv.GiveTo(Instigator);
				}
			}
			SetTimer(0.5,True);
			MMPI.TeamMissionBroadcast();
		}
		else
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 7000, None, None, Class);
			bActive = false;
			GotoState('');
			return;		
		}
	}
	bActive = false;
	GotoState('');
	return;		
}

function bool GetSpawnHeight(Vector MyLocation)
{
	local Vector UpEndLocation;
	local vector HitLocation;
	local vector HitNormal;
	local Actor AHit;
	
	UpEndLocation = MyLocation + vect(0,0,1500);

    	AHit = Trace(HitLocation, HitNormal, UpEndLocation, MyLocation, true);
	if (AHit == None || !AHit.bWorldGeometry)
		return True;	
	else 
		return False;
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 1000)
		return "Cannot access mission.";
	else if (Switch == 2000)
		return "A team mission or minigame is already currently active.";
	else if (Switch == 7000)
		return "There is not enough room above you for this mission.";
}

defaultproperties
{
     XPReward=1	//XP per Coin
     MissionGoal=0	//Keep at 0
	 TimeLimit=90
	 TeamMission=True
     PickupClass=Class'DEKRPG208.ArtifactMissionTeamCoinGrabPickup'
     IconMaterial=Texture'MissionsTex4.TeamMissions.CoinGrab'
     ItemName="Coin Grab"
	 Description="(T)Catch the coins before they reach the ground!"
}
