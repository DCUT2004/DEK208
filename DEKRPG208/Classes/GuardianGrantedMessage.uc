class GuardianGrantedMessage extends LocalMessage;

var localized string GuardianGrantedMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	if (Switch == 0)
	{
		return default.GuardianGrantedMessage @ PRI1.PlayerName;
	}
}

defaultproperties
{
     GuardianGrantedMessage="You are under Guardian Healing by"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(G=232,R=142)
     PosY=0.140000
}
