//This message is sent to players who have some damage-causing condition (e.g. poison)
class NecroGhostMisfortuneMessage extends LocalMessage;

var localized string MisfortuneMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				 optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	//if(RelatedPRI_1 == None)
		//return "";
	//return (RelatedPRI_1.PlayerName @ default.HealedMessage);
	return default.MisfortuneMessage;
}

defaultproperties
{
     MisfortuneMessage="You have the misfortune curse!"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(B=0,G=0,R=225)
     PosY=0.800000
}
