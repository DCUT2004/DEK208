class DCMonsterController extends MonsterController
	config(satoreMonsterPack);

var config int RangeLevelCheck;		// set to zero for old behaviour

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

function bool NewEnemyBetterTarget(int NewLevel, int OldLevel, int NewDist, int OldDist) 
{
	if (NewLevel > OldLevel)
	{
		if (NewDist < (OldDist+RangeLevelCheck))
		{	// switch unless Old is in Meleerange and New isnt
			if (( NewDist < Pawn.MeleeRange ) || ( OldDist > Pawn.MeleeRange ))
			{
				return true;
			}
		}
	}
	else if (NewLevel == OldLevel) 
	{
		if (NewDist < OldDist)
		{
			return true;
		}
	}
	else 	// NewLevel < OldLevel
	{
		if ((NewDist+RangeLevelCheck) < OldDist) 
		{	// lower level but a lot closer
			return true;
		}
		else
		{
			if (( NewDist < Pawn.MeleeRange ) && ( OldDist > Pawn.MeleeRange ))
			{	// new one is in melee range
				return true;
			}
		}
	}
	return false;
}

function bool FindNewEnemy()
{
	// modified version for more intelligent targetting
	// if cannot see any enemies, goes for closest
	// of the enemies it can see, will target highest level player, provided within a certain distance.
	local Pawn BestEnemy;
	local bool bSeeNew, bSeeBest;
	local bool bLoSNew, bLoSBest;
	local float BestDist, NewDist;
	local int BestLevel, NewLevel;
	local Controller C;
	local int LoopCount;
	local PhantomDeathGhostInv Inv;

	if ( Level.Game.bGameEnded )
		return false;

	// LineOfSightTo checks to see if the direct line between them is blocked
	// CanSee        checks for LineOfSightTo and then checks if in Field of View
	// historically, monsters use CanSee, but let's spice it up a bit

	LoopCount = 0;
	for ( C=Level.ControllerList; C != None && LoopCount < 1000; C = C.NextController )
	{
		LoopCount++;
		if ( C != None && C.bIsPlayer && C.Pawn != None)
		{
			if ( BestEnemy == None )
			{
				BestEnemy = C.Pawn;
				BestDist = VSize(BestEnemy.Location - Pawn.Location);
				bSeeBest = CanSee(BestEnemy);
				bLoSBest = LineOfSightTo(BestEnemy);
				BestLevel = GetRPGLevel(BestEnemy);
			}
			else
			{
				bSeeNew = CanSee(C.Pawn);
				bLoSNew = LineOfSightTo(C.Pawn);
				NewDist = VSize(C.Pawn.Location - Pawn.Location);
				if (bSeeNew)
				{
					if ( !bSeeBest )
					{	// ensure if we can see an enemy, we target it
						BestEnemy = C.Pawn;
						BestDist = NewDist;
						bSeeBest = bSeeNew;
						bLoSBest = bLoSNew;
						BestLevel = GetRPGLevel(BestEnemy);
					}
					else 
					{	// can see both
						NewLevel = GetRPGLevel(C.Pawn);
						// if higher level not more too much further away than low level, then target
						if (NewEnemyBetterTarget(NewLevel, BestLevel, NewDist, BestDist))
						{
							BestEnemy = C.Pawn;
							BestDist = NewDist;
							bSeeBest = bSeeNew;
							bLoSBest = bLoSNew;
							BestLevel = NewLevel;
						}
					}
				}
				else 
				{	// cannot see new enemy
					if (!bSeeBest)
					{
						if (bLoSNew && !bLoSBest)
						{	// can see neither, but direct unobstructed line to new
							BestEnemy = C.Pawn;
							BestDist = NewDist;
							bSeeBest = bSeeNew;
							bLoSBest = bLoSNew;
							BestLevel = GetRPGLevel(BestEnemy);		// do not bother getting level - saves processing. Cannot see done on closest.
						}
						else
						{
							if (bLoSNew)
							{	// direct route to both - so choose highest level
								NewLevel = GetRPGLevel(C.Pawn);
								if (NewEnemyBetterTarget(NewLevel, BestLevel, NewDist, BestDist))
								{
									BestEnemy = C.Pawn;
									BestDist = NewDist;
									bSeeBest = bSeeNew;
									bLoSBest = bLoSNew;
									BestLevel = NewLevel;
								}
							}
							else if (!bLoSBest)
							{	// direct route to neither - so choose closest
								if (NewDist < BestDist)
								{
									BestEnemy = C.Pawn;
									BestDist = NewDist;
									bSeeBest = bSeeNew;
									bLoSBest = bLoSNew;
									BestLevel = GetRPGLevel(BestEnemy);
								}
							}
						}
					}
				}
			}
		}
	}
	if ( LoopCount >= 1000)
	{
		Log("DCMonsterController in FindNewEnemy looping more than 1000 times. Terminating search.");
		return false;
	}
		
	if ( BestEnemy == Enemy )
		return false;
	if ( BestEnemy != None )
	{
		Inv = PhantomDeathGhostInv(BestEnemy.FindInventoryType(class'PhantomDeathGhostInv'));
		if (Inv != None)
			return false;
		else
		{
			ChangeEnemy(BestEnemy,CanSee(BestEnemy));
			return true;
		}
	}
	else
		return false;
}

function bool SetEnemy( Pawn NewEnemy, optional bool bHateMonster )
{
	local float EnemyDist, NewDist;
	local bool bNewMonsterEnemy;
	local int EnemyLevel, NewLevel;
	local PhantomDeathGhostInv Inv;

	if ( (NewEnemy == None) || (NewEnemy.Health <= 0) || (NewEnemy.Controller == None) || (NewEnemy == Enemy) )
		return false;

	bNewMonsterEnemy = bHateMonster && (Level.Game.NumPlayers < 4) && !Monster(Pawn).SameSpeciesAs(NewEnemy) && !NewEnemy.Controller.bIsPlayer;
	if ( !NewEnemy.Controller.bIsPlayer && !bNewMonsterEnemy )	//
			return false;
	
	Inv = PhantomDeathGhostInv(NewEnemy.FindInventoryType(class'PhantomDeathGhostInv'));
	if (Inv != None)
		return false;

	// so, NewEnemy is a valid target
	if ( Enemy == None || Enemy.Controller == None)
	{
		ChangeEnemy(NewEnemy,CanSee(NewEnemy));
		return true;
	}

	if ( !LineOfSightTo(NewEnemy) )
		return false;		// cannot attack it so what's the point

	if ( !EnemyVisible() )
	{	// lost track of the enemy we were following, and know we can get to NewEnemy
		ChangeEnemy(NewEnemy,CanSee(NewEnemy));
		return true;
	}

	EnemyDist = VSize(Enemy.Location - Pawn.Location);
	if ( EnemyDist < Pawn.MeleeRange )
		return false;	// currently in a melee, so do not break out

	// so can access both, which do we hit
	if ( !bHateMonster && (Monster(Enemy) != None) && NewEnemy.Controller.bIsPlayer )
	{	// enemy is currently a monster, which we like, and the alternative is a player
		ChangeEnemy(NewEnemy,CanSee(NewEnemy));
		return true;
	}

	NewDist = VSize(NewEnemy.Location - Pawn.Location);

	// want to change if NewEnemy is a player, and is higher level than Enemy
	NewLevel = 1;
	EnemyLevel = 1;
	if (NewEnemy.Controller.bIsPlayer)
		NewLevel = GetRPGLevel(NewEnemy);
	if (Enemy.Controller.bIsPlayer)
		EnemyLevel = GetRPGLevel(Enemy);

	if (NewEnemyBetterTarget(NewLevel, EnemyLevel, NewDist, EnemyDist) && FRand() < 0.8 )
	{
		ChangeEnemy(NewEnemy,CanSee(NewEnemy));
		return true;
	}
	return false;
}

//function bool EnemyVisible()
//{
//	local PhantomDeathGhostInv Inv;
//	
//	if (Enemy != None)
//	{
//		Inv = PhantomDeathGhostInv(Enemy.FindInventoryType(class'PhantomDeathGhostInv'));
//		if (Inv != None)
//		{
//			bEnemyIsVisible = False;
//			return false;
//		}
//		else
//		{
//			if ( (EnemyVisibilityTime == Level.TimeSeconds) && (VisibleEnemy == Enemy) )
//				return bEnemyIsVisible;
//			VisibleEnemy = Enemy;
//			EnemyVisibilityTime = Level.TimeSeconds;
//			bEnemyIsVisible = LineOfSightTo(Enemy);
//			return bEnemyIsVisible;		
//		}
//	}
//	else
//	{
//		return false;
//		bEnemyIsVisible = False;
//	}
//}

defaultproperties
{
     RangeLevelCheck=2000
}
