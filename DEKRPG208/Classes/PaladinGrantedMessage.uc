class PaladinGrantedMessage extends LocalMessage;

var localized string PaladinGrantedMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	if (Switch == 0)
	{
		return default.PaladinGrantedMessage @ PRI1.PlayerName;
	}
}

defaultproperties
{
     PaladinGrantedMessage="You are under protection by"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(G=232,R=142)
     PosY=0.140000
}
