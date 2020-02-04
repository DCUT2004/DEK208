class PaladinActivatedMessage extends LocalMessage;

var localized string PaladinActivatedMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	if (Switch == 0)
	{
		return PRI1.PlayerName @ default.PaladinActivatedMessage;
	}
}

defaultproperties
{
     PaladinActivatedMessage="has used your Paladin protection!"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(G=232,R=142)
     PosY=0.140000
}
