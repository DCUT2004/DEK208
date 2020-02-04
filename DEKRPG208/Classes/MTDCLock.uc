class MTDCLock extends MTDC;

var bool IsLockedForSelf;
var Controller PlayerSpawner;

function float BotDesireability(Actor S, int TeamIndex, Actor Objective)
{
	local Bot B;
	local SquadAI Squad;
	local int Num;

	if ( Level.Game.JustStarted(20) && !Level.Game.IsA('ASGameInfo') )
		return Super.BotDesireability(S, TeamIndex, Objective);

	Squad = SquadAI(S);

	if (Squad.Size == 1)
	{
		if ( (Squad.Team != None) && (Squad.Team.Size == 1) && Level.Game.IsA('ASGameInfo') )
			return Super.BotDesireability(S, TeamIndex, Objective);
		return 0;
	}

	for (B = Squad.SquadMembers; B != None; B = B.NextSquadMember)
		if (Vehicle(B.Pawn) == None && (B.RouteGoal == self || B.Pawn == None || VSize(B.Pawn.Location - Location) < Squad.MaxVehicleDist(B.Pawn)))
			Num++;

	if ( Num < 0 )
		return 0;

	return Super.BotDesireability(S, TeamIndex, Objective);
}

function SetPlayerSpawner(Controller PlayerC)
{
	PlayerSpawner = PlayerC;
}

function bool TryToDrive(Pawn P)
{
	if ( (P.Controller == None) || !P.Controller.bIsPlayer || Health <= 0 )
		return false;

	// Check for Locking by engineer....
	if ( IsEngineerLocked() && P.Controller != PlayerSpawner )
	{
		if (PlayerController(P.Controller) != None)
		{
		    if (PlayerSpawner != None)
				PlayerController(P.Controller).ReceiveLocalizedMessage(class'VehicleEngLockedMessage', 0, PlayerSpawner.PlayerReplicationInfo);
			else
				PlayerController(P.Controller).ReceiveLocalizedMessage(class'VehicleEngLockedMessage', 0);
		}
		return false;
	}
	else
	{
		return super.TryToDrive(P);
	}
}

function EngineerLock()
{
    IsLockedForSelf = True;
}

function EngineerUnlock()
{
    IsLockedForSelf = False;
}

function bool IsEngineerLocked()
{
    return IsLockedForSelf;
}

defaultproperties
{
     RedSkin1=Texture'MTII.MTBlue'
     PassengerWeapons(0)=(WeaponPawnClass=Class'DEKRPG208.MTRearGunPawnBlue')
}
