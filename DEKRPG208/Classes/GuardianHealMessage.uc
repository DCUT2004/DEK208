class GuardianHealMessage extends LocalMessage;

var localized string GuardianHealMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	if (Switch == 0)
	{
		return PRI1.PlayerName @ default.GuardianHealMessage;
	}
}

defaultproperties
{
     GuardianHealMessage="has activated your Guardian Healing!"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(G=232,R=142)
     PosY=0.140000
}
