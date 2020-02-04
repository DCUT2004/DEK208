class DEKPlasmaTurretWeapon extends Weapon_Turret;

function byte BestMode()
{
	local float			EnemyDist;
	local bot			B;
	//local Controller	C;

	B = Bot(Instigator.Controller);
	if ( B == None )
	{
		return 0;
		/*
		C = Instigator.Controller;
		if ( C.Enemy == None || C.Enemy.IsA('Vehicle')
			|| VSize(C.Enemy.Location - C.Pawn.Location) > 1000 ) // probably a bit out of range. Go with primary fire.
			return 0;

		return 1;
		*/
	}

	if ( DestroyableObjective(B.Squad.SquadObjective) != None && DestroyableObjective(B.Squad.SquadObjective).TeamLink(B.GetTeamNum())
	     && VSize(B.Squad.SquadObjective.Location - B.Pawn.Location) < FireMode[1].MaxRange() && (B.Enemy == None || !B.CanSee(B.Enemy)) )
		return 1;

	if ( B.Enemy == None )
		return 0;

	EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
	if ( EnemyDist > 1000 )
		return 0;
	return 1;
}

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208.DEKPlasmaTurretFire'
     FireModeClass(1)=Class'DEKRPG208.DEKPlasmaTurretAltFire'
     AttachmentClass=Class'DEKRPG208.DEKPlasmaTurretAttachment'
}
