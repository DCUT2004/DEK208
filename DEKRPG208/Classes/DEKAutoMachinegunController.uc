class DEKAutoMachinegunController extends AutoGunController;

function SetPlayerSpawner(Controller PlayerC)
{
	PlayerSpawner = PlayerC;
	if (PlayerSpawner.PlayerReplicationInfo != None && (PlayerSpawner.PlayerReplicationInfo.Team != None || TeamGame(Level.Game) == None))
	{
		if (PlayerReplicationInfo == None)
			PlayerReplicationInfo = spawn(class'PlayerReplicationInfo', self);
		PlayerReplicationInfo.PlayerName = PlayerSpawner.PlayerReplicationInfo.PlayerName$"'s Assault Sentinel";
		PlayerReplicationInfo.bIsSpectator = true;
		PlayerReplicationInfo.bBot = false;
		PlayerReplicationInfo.Team = PlayerSpawner.PlayerReplicationInfo.Team;
//		PlayerReplicationInfo.RemoteRole = ROLE_None;
	}
}

defaultproperties
{
     TargetRange=25000
}
