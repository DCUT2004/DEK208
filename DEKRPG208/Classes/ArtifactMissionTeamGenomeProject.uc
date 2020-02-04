class ArtifactMissionTeamGenomeProject extends ArtifactMission
		config(UT2004RPG);

#exec  AUDIO IMPORT NAME="MPSelect" FILE="C:\UT2004\Sounds\MPSelect.WAV" GROUP="MissionSounds"

function Activate()
{
	local Controller C;
	local NavigationPoint Dest1, Dest2, Dest3;
	local GenomeProjectNode GPN;
	local GenomeVialCosmicPickup GVC;
	local GenomeVialTechPickup GVT;
	local GenomeVialFirePickup GVF;
	local GenomeVialIcePickup GVI;
	local GenomeVialGhostPickup GVG;
	local int Rand1, Rand2;
	
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
		if (MMPI.GenomeProjectActive)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		if (MMPI != None && MMPI.stopped && !MMPI.GenomeProjectActive)
		{
			Dest1 = Instigator.Controller.FindRandomDest();
			Dest2 = Instigator.Controller.FindRandomDest();
			Dest3 = Instigator.Controller.FindRandomDest();
			Rand1 = Rand(99);
			Rand2 = Rand(99);
			GPN = Instigator.spawn(class'GenomeProjectNode',,,Dest1.Location + vect(0,0,40));
			if (Rand1 <= 20)			
				GVC = Instigator.spawn(class'GenomeVialCosmicPickup',,,Dest2.Location + vect(0,0,20));
			else if (Rand1 <= 40)
				GVT = Instigator.spawn(class'GenomeVialTechPickup',,,Dest2.Location + vect(0,0,20));
			else if (Rand1 <= 60)
				GVF = Instigator.spawn(class'GenomeVialFirePickup',,,Dest2.Location + vect(0,0,20));
			else if (Rand1 <= 80)
				GVI = Instigator.spawn(class'GenomeVialIcePickup',,,Dest2.Location + vect(0,0,20));
			else
				GVG = Instigator.spawn(class'GenomeVialGhostPickup',,,Dest2.Location + vect(0,0,20));
			if (Rand2 <= 20)			
				GVC = Instigator.spawn(class'GenomeVialCosmicPickup',,,Dest3.Location + vect(0,0,20));
			else if (Rand2 <= 40)
				GVT = Instigator.spawn(class'GenomeVialTechPickup',,,Dest3.Location + vect(0,0,20));
			else if (Rand2 <= 60)
				GVF = Instigator.spawn(class'GenomeVialFirePickup',,,Dest3.Location + vect(0,0,20));
			else if (Rand2 <= 80)
				GVI = Instigator.spawn(class'GenomeVialIcePickup',,,Dest3.Location + vect(0,0,20));
			else
				GVG = Instigator.spawn(class'GenomeVialGhostPickup',,,Dest3.Location + vect(0,0,20));
			if (GPN != None && (GVC != None || GVT != None || GVF != None || GVI != None || GVG != None))
			{
				GPN.SetTeamNum(Instigator.GetTeamNum());
				if (GPN.Controller != None)
					GPN.Controller.Destroy();
				GPN.Spawner = Instigator;
				MMPI.Stopped = False;
				MMPI.MasterMMPI = True;
				MMPI.default.MMPIOwner = Instigator;
				MMPI.GenomeProjectActive = True;
				MMPI.MissionName = default.ItemName;
				MMPI.Description = default.Description;
				MMPI.SetTimer(MMPI.CheckInterval, True);
				MMPI.TimeLimit = default.TimeLimit;
				MMPI.MissionXP = XPReward;
				MMPI.MissionGoal = MissionGoal;
				MMPI.GPN = GPN;
				MMPI.GenomeXPPerVial = XPReward;
				for ( C = Level.ControllerList; C != None; C = C.NextController )
					if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(Instigator.Controller) )
						PlayerController(C).ClientPlaySound(Sound'DEKRPG208.MissionSounds.MPSelect');
				SetTimer(0.5,True);
				MMPI.TeamMissionGenomeBroadcast();
			}
			else
			{
				if (GPN != None)
					GPN.Destroy();
				if (GVC != None)
					GVC.Destroy();
				if (GVT != None)
					GVT.Destroy();
				if (GVF != None)
					GVF.Destroy();
				if (GVI != None)
					GVI.Destroy();
				if (GVG != None)
					GVG.Destroy();
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
		return "Genome node could not spawn. Try again.";
}

defaultproperties
{
     XPReward=5		//XP per vial
     MissionGoal=0	//Keep at 0
	 TimeLimit=120
	 TeamMission=True
     PickupClass=Class'DEKRPG208.ArtifactMissionTeamGenomeProjectPickup'
     IconMaterial=Texture'MissionsTex4.TeamMissions.GenomeProject'
     ItemName="Genome Project"
	 Description="(T)Find and return vials to the node for study!"
}
