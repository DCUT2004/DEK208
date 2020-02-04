class AdrenalineAwarenessInv extends Inventory
	config(UT2004RPG);

function Timer()
{
	local Controller C;
	local ASGameInfo ASGame;

	if (Instigator == None || Instigator.Health <= 0)
	{
		Destroy();
		return;
	}

	C = Instigator.Controller;
	if (C == None && Instigator.DrivenVehicle != None)
		 C = Instigator.DrivenVehicle.Controller;

	if (C == None)
		return;

	//if (Level.Game.IsA('ASGameInfo') || ClassIsChildOf(ASGame.Class,class'ASGameInfo'))
	//{
	//	C.Pawn.ReceiveLocalizedMessage(class'AdrenMessage', C.Adrenaline);
	//}
	if (ASGameInfo(Level.Game) != None && ClassIsChildOf(ASGame.Class,class'ASGameInfo'))
	{
		if (C != None && Instigator != None && Instigator.Health > 0)
			C.Pawn.ReceiveLocalizedMessage(class'AdrenMessage', C.Adrenaline);
	}
	else
	{
		Destroy();
		return;
	}
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	return switch @ "adrenaline.";
}

defaultproperties
{
     RemoteRole=ROLE_DumbProxy
}
