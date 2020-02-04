class GuardianRemoveMessage extends LocalMessage;

var localized string RemoveMessageOne, RemoveMessageTwo;

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	if (Switch == 0)
	{
		return default.RemoveMessageOne;
	}
	else if (Switch == 1)
	{
		return default.RemoveMessageTwo;
	}
}

defaultproperties
{
     RemoveMessageOne="Your Guardian Heal has been removed!"
     RemoveMessageTwo="Your heal target has been removed!"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(B=0,G=0)
     PosY=0.140000
}
