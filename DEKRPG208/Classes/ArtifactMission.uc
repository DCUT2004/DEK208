class ArtifactMission extends RPGArtifact
		config(UT2004RPG);

var config int XPReward;
var config int MissionGoal;
var config int TimeLimit;
var MissionInv Inv;
var Mission1Inv M1Inv;
var Mission2Inv M2Inv;
var Mission3Inv M3Inv;
var MissionMultiplayerInv MMPI;
var localized string Description;
var config int LowLevelThreshold, MediumLevelThreshold;
var config float LowLevelMultiplier, MediumLevelMultiplier;
var config bool TeamMission;

#exec OBJ LOAD FILE=..\Sounds\AssaultSounds.uax
#exec OBJ LOAD FILE=..\Textures\MissionsTex4.utx

function BotConsider()
{
	return;		// the chance of a bot using this correctly is soo low as to be not worth it.
}

static function bool ArtifactIsAllowed(GameInfo Game)
{
	if (Invasion(Game) != None)
		return true;
	else
		return false;
}

function Activate()
{
	local int PlayerLevel;

	PlayerLevel = GetRPGLevel(Instigator);
	
	if (PlayerLevel <= default.LowLevelThreshold)
	{
		if (XPReward > default.XPReward * default.LowLevelMultiplier)
			XPReward *= default.LowLevelMultiplier;
		if (MissionGoal > default.MissionGoal * default.LowLevelMultiplier)
			MissionGoal *= default.LowLevelMultiplier;
		if (MissionGoal < 1)
			MissionGoal = 1;
	}
	else if (PlayerLevel <= default.MediumLevelThreshold)
	{
		if (XPReward > default.XPReward * default.MediumLevelMultiplier)
			XPReward *= default.MediumLevelMultiplier;
		if (MissionGoal > default.MissionGoal * default.MediumLevelMultiplier)
			MissionGoal *= default.MediumLevelMultiplier;
		if (MissionGoal < 1)
			MissionGoal = 1;
	}
}

function int GetRPGLevel(Pawn NewTarget)
{
	local RPGPlayerDataObject DataObj;
	local RPGStatsInv StatsInv;

	if (NewTarget == None || NewTarget.Controller == None)
		return 1;

	StatsInv = class'DruidLinkTurret'.static.GetStatsInvFor(NewTarget.Controller);
	if (StatsInv != None)
		DataObj = StatsInv.DataObject;
	if (DataObj != None)
		return DataObj.Level;

	return 1;
}

function Timer()
{
	setTimer(0, false);

	Destroy();
	Instigator.NextItem();
}

defaultproperties
{
	 LowLevelThreshold=40	//Players this level and under are considered low level
	 MediumLevelThreshold=70	//Players this level and under are considered medium level
	 LowLevelMultiplier=0.50000	//Percentage of normal XP and Mission Goal requirements for low levels
	 MediumLevelMultiplier=0.75000	//Percentage of normal XP and Mission Goal requirements for medium levels
	 TeamMission=False
     CostPerSec=1
     MinActivationTime=0.000001
     ItemName="Mission"
}
