class MindControlInv extends Inventory;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if(Other == None)
	{
		destroy();
		return;
	}
	Super.GiveTo(Other);

}

static function Monster SummonMonster(class<Monster> ChosenMonster, Pawn Master)
{
	Local Monster M;
	Local Vector SpawnLocation;
	local rotator SpawnRotation;
	local FriendlyMonsterInv FriendlyInv;
	local MonsterPointsInv MPInv;
	local DEKFriendlyMonsterController C;

	if (Master != None && Master.Health > 0)
	{
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
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
