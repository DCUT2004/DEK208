class PhantomGhostTimer extends LocalMessage;

var localized string PhantomMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	return Switch @ default.PhantomMessage;
}

defaultproperties
{
     PhantomMessage="seconds."
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     PosY=0.790000
}
