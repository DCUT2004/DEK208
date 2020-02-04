class AbilityNecroPlague extends CostRPGAbility
	config(UT2004RPG);

var config float TimeDecrementPerLevel, MinSpawnInterval;
var int Chance;
var config int StartingChance, ChanceAddPerLevel, MaxChance;
var config int StartingLifespan, LifespanAddPerLevel, MaxLifespan;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local PlagueSpreader Inv;
	
	Inv = PlagueSpreader(Other.FindInventoryType(class'PlagueSpreader'));
	if (Inv == None)
	{
		Inv = Other.Spawn(class'PlagueSpreader', Other);
		Inv.GiveTo(Other);
	}
}

static function ScoreKill(Controller Killer, Controller Killed, bool bOwnedByKiller, int AbilityLevel)
{
	local int Chance;
	local PlagueActor Plague;
	local PlagueInv Inv;
	
	Chance = default.StartingChance;
	
	if (AbilityLevel > 1)
	{
		Chance = default.StartingChance + (AbilityLevel * default.ChanceAddPerLevel);
		if (Chance > default.MaxChance)
			Chance = default.MaxChance;
	}
	
	if (!bOwnedByKiller)
		return;

	if ( Killed == Killer || Killed == None || Killer == None || Killed.Level == None || Killed.Level.Game == None)
		return;
	
	if (Killed.Pawn != None && Killer.Pawn != None)
	{
		Inv = PlagueInv(Killed.Pawn.FindInventoryType(class'PlagueInv'));
		if (Inv != None)
			return;
		
		if ( rand(99) <= Chance && Killed.Pawn != None)
		{
			Plague = Killed.Pawn.Spawn(class'PlagueActor', Killer.Pawn,, Killed.Pawn.Location);
			if (Plague != None)
				Plague.Necromancer = Killer;
		}
	}


	if (Killed.Level.Game.bTeamGame)
	{
		if ( (Killer.PlayerReplicationInfo == None) || (Killed.PlayerReplicationInfo == None) || (Killer.PlayerReplicationInfo.Team == Killed.PlayerReplicationInfo.Team))
			return;	//no bonus for team kills
	}
}

defaultproperties
{
	 StartingChance=5
	 ChanceAddPerLevel=3
	 MaxChance=50
     AbilityName="Plague"
     Description="This ability provides a chance for producing a plague infection after killing a target. Enemies that come near the plague will become infected, and infected enemies can also infect other enemies.||You can also help spread the plague by standing near a plague cloud for several seconds. Once obtained, you can spread the plague by coming into contact with enemies.||Each level of this ability increases the chance of producing a plague by 3% per level.||Cost(per level): 5,10,15,20..."
     StartingCost=5
     CostAddPerLevel=5
     MaxLevel=20
}
