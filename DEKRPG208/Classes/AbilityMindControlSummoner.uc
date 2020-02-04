class AbilityMindControlSummoner extends CostRPGAbility
	abstract;
	
var config float SummonChance;

//static function ModifyPawn(Pawn Other, int AbilityLevel)
//{
//	local MindControlInv Inv;
//	
//	Inv = MindControlInv(Other.FindInventoryType(class'MindControlInv'));
//	if (Inv == None)
//	{
//		Inv = Other.Spawn(class'MindControlInv', Other);
//		Inv.GiveTo(Other);
//	}
//}
	
static function ScoreKill(Controller Killer, Controller Killed, bool bOwnedByKiller, int AbilityLevel)
{
	local class<Monster> KilledMonster;
	//local MindControlInv Inv;
	
	if (!bOwnedByKiller)
		return;

	if ( Killed == Killer || Killed == None || Killer == None || Killed.Level == None || Killed.Level.Game == None || !Killed.IsA('Monster') || Killer.IsA('Monster'))
		return;
		
	//if (Killer != None && Killer.Pawn != None)
	//{
	//	Inv = MindControlInv(Killer.Pawn.FindInventoryType(class'MindControlInv'));
	//}
	//if (Inv == None)
	//	return;
	
	if (!Killed.SameTeamAs(Killer) && Killed.Pawn.IsA('Monster') && Rand(99) <= default.SummonChance)
	{
		KilledMonster = Monster(Killed.Pawn).Class;
		SummonMonster(KilledMonster, Killer.Pawn);
	}
}

static function Monster SummonMonster(class<Monster> ChosenMonster, Pawn Master)
{
	Local Monster M;
	Local Vector SpawnLocation;
	local rotator SpawnRotation;
	local FriendlyMonsterInv FriendlyInv;
	local MonsterPointsInv MPInv;
	local DEKFriendlyMonsterController C;

	MPInv = MonsterPointsInv(Master.FindInventoryType(class'MonsterPointsInv'));
	if (MPInv == None)
		return None;
	SpawnLocation = getSpawnLocation(ChosenMonster, Master);
	SpawnRotation = getSpawnRotator(SpawnLocation, Master);
	
	M = Master.Spawn(ChosenMonster,,, SpawnLocation, SpawnRotation);
	if(M == None)
	{
		return None;
	}
	else
	{
		if (M.Controller != None)
			M.Controller.Destroy();
		
		FriendlyInv = M.spawn(class'FriendlyMonsterInv');
		FriendlyInv.giveTO(M);
		FriendlyInv.MasterPRI = Master.PlayerReplicationInfo;
		FriendlyInv.MonsterPointsInv = MPInv;

		if(FriendlyInv == None)
		{
			M.Died(None, class'DamageType', vect(0,0,0)); //whatever.
			//M.Destroy();
			return None;
		}
		
		C = M.spawn(class'DEKFriendlyMonsterController',,, SpawnLocation, SpawnRotation);
		C.Possess(M); //do not call InitializeSkill before this line.
		C.SetMaster(Master.Controller);
		if(C == None)
		{
			M.Died(None, class'DamageType', vect(0,0,0)); //whatever.
			FriendlyInv.Destroy();
			M.Destroy();
			return None;
		}
	}
}

static function vector getSpawnLocation(Class<Monster> ChosenMonster, Pawn Master)
{
	local vector SpawnLocation;

	SpawnLocation = Master.Location + ChosenMonster.default.CollisionHeight * vect(0,0,40); //is this why monsters spawn on heads?

	return SpawnLocation;	
}

static function rotator getSpawnRotator(Vector SpawnLocation, Pawn Master)
{
	local rotator SpawnRotation;

	SpawnRotation.Yaw = rotator(SpawnLocation - Master.Location).Yaw;
	return SpawnRotation;
}

defaultproperties
{
	 SummonChance=75.0000000
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityHordeSummoner'
     ExcludingAbilities(1)=Class'DEKRPG208.AbilityBeastSummoner'
     AbilityName="Niche: Mind Control"
     Description="Further increases the damage dealt by your pets by 25%, but also reduces your maximum monster points by 5.|You must be level 180 and have maxed out Monster Points before buying this niche. You can not be in more than one niche at a same time.||Cost(per level): 50"
     StartingCost=50
     MaxLevel=1
}
