class MissionRingAndHoldCompleteMessage extends LocalMessage;

var localized string MissionCompleteMessage, XPMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	return default.MissionCompleteMessage @ Switch @ default.XPMessage;
}

defaultproperties
{
     MissionCompleteMessage="Ring and Hold complete! +"
	 XPMessage="XP."
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     PosY=0.80000
}
