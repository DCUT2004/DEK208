//This message is sent to players who have some damage-causing condition (e.g. poison)
class NecroConditionMessage extends LocalMessage;

var localized string NecroMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	if (Switch == 0)
	{
		return default.NecroMessage;
	}
}

defaultproperties
{
     NecroMessage="You have been resurrected with invulnerability!"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
	 DrawColor=(R=255)
     PosY=0.140000
}
