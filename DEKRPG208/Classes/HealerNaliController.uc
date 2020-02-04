class HealerNaliController extends MonsterController
	config(satoreMonsterPack);

function bool FindNewEnemy()
{
	local Pawn BestEnemy;
	local bool bSeeNew, bSeeBest;
	local float BestDist, NewDist;
	local Controller C;
	local PhantomDeathGhostInv Inv;

	if ( Level.Game.bGameEnded )
		return false;
	for ( C=Level.ControllerList; C!=None; C=C.NextController )
		if ( C.bIsPlayer && (C.Pawn != None) )
		{
			if ( BestEnemy == None )
			{
				BestEnemy = C.Pawn;
				BestDist = VSize(BestEnemy.Location - Pawn.Location);
				bSeeBest = CanSee(BestEnemy);
			}
			else
			{
				NewDist = VSize(C.Pawn.Location - Pawn.Location);
				if ( !bSeeBest || (NewDist < BestDist) )
				{
					bSeeNew = CanSee(C.Pawn);
					if ( bSeeNew || (!bSeeBest && (NewDist < BestDist))  )
					{
						BestEnemy = C.Pawn;
						BestDist = NewDist;
						bSeeBest = bSeeNew;
					}
				}
			}
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
	local float EnemyDist;
	local bool bNewMonsterEnemy;
	local PhantomDeathGhostInv Inv;

	if ( (NewEnemy == None) || (NewEnemy.Health <= 0) || (NewEnemy.Controller == None) || (NewEnemy == Enemy) )
		return false;
		
	Inv = PhantomDeathGhostInv(NewEnemy.FindInventoryType(class'PhantomDeathGhostInv'));
	if (Inv != None)
		return false;

	bNewMonsterEnemy = bHateMonster && (Level.Game.NumPlayers < 4) && !Monster(Pawn).SameSpeciesAs(NewEnemy) && !NewEnemy.Controller.bIsPlayer;
	if ( !NewEnemy.Controller.bIsPlayer	&& !bNewMonsterEnemy )
			return false;

	if ( (bNewMonsterEnemy && LineOfSightTo(NewEnemy)) || (Enemy == None) || !EnemyVisible() )
	{
		ChangeEnemy(NewEnemy,CanSee(NewEnemy));
		return true;
	}

	if ( !CanSee(NewEnemy) )
		return false;

	if ( !bHateMonster && (Monster(Enemy) != None) && NewEnemy.Controller.bIsPlayer )
		return false;

	EnemyDist = VSize(Enemy.Location - Pawn.Location);
	if ( EnemyDist < Pawn.MeleeRange )
		return false;

	if ( EnemyDist > 1.7 * VSize(NewEnemy.Location - Pawn.Location))
	{
		ChangeEnemy(NewEnemy,CanSee(NewEnemy));
		return true;
	}
	return false;
}

defaultproperties
{
}
