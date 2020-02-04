class NecroTimerMessage extends LocalMessage;

var localized string NecroMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	return Switch @ default.NecroMessage;
}

defaultproperties
{
     NecroMessage="seconds."
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(B=63,R=121)
     PosY=0.180000
}
