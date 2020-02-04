class DEKFriendlyMonsterController extends FriendlyMonsterController;

function bool FindNewEnemy()
{
	local Pawn BestEnemy;
	local float BestDist;
	local Controller C;

	BestDist = 50000.f;
	for (C = Level.ControllerList; C != None; C = C.NextController)
		if ( C != Master && C != self && C.Pawn != None && (DEKFriendlyMonsterController(C) == None || DEKFriendlyMonsterController(C).Master != Master) && !C.SameTeamAs(Master)
		     && VSize(C.Pawn.Location - Pawn.Location) < BestDist && !Monster(Pawn).SameSpeciesAs(C.Pawn) && CanSee(C.Pawn) && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') )
		{
			BestEnemy = C.Pawn;
			BestDist = VSize(C.Pawn.Location - Pawn.Location);
		}

	if ( BestEnemy == Enemy )
		return false;

	if ( BestEnemy != None )
	{
		ChangeEnemy(BestEnemy, true);
		return true;
	}
	return false;
}

function bool SetEnemy(Pawn NewEnemy, optional bool bThisIsNeverUsed)
{
	local float EnemyDist;

	if (NewEnemy == None || NewEnemy.Health <= 0 || NewEnemy.Controller == None || NewEnemy == Enemy)
		return false;
	if ( Master != None && ( (Master.Pawn != None && NewEnemy == Master.Pawn)
				 || (DEKFriendlyMonsterController(NewEnemy.Controller) != None && DEKFriendlyMonsterController(NewEnemy.Controller).Master == Master) ) )
		return false;
	if (NewEnemy.Controller.SameTeamAs(Master) || !CanSee(NewEnemy))
		return false;

	if (Enemy == None)
	{
		ChangeEnemy(NewEnemy, CanSee(NewEnemy));
		return true;
	}

	EnemyDist = VSize(Enemy.Location - Pawn.Location);
	if ( EnemyDist < Pawn.MeleeRange )
		return false;

	if ( EnemyDist > 1.7 * VSize(NewEnemy.Location - Pawn.Location))
	{
		ChangeEnemy(NewEnemy, CanSee(NewEnemy));
		return true;
	}
	
	if (ClassIsChildOf(NewEnemy.class, class'SMPNali') || ClassIsChildOf(NewEnemy.class, class'SMPNaliCow'))
		return false;
	return false;
}

defaultproperties
{
}
