class UntetheredConditionMessage extends LocalMessage;

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
     NecroMessage="You are untethered!"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=5
     DrawColor=(B=0,G=0)
     PosY=0.130000
}
