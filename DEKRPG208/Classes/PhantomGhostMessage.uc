class PhantomGhostMessage extends LocalMessage;

var localized string PhantomMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	if (Switch == 0)
	{
		return default.PhantomMessage;
	}
}

defaultproperties
{
     PhantomMessage="You are a Phantom!"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     PosY=0.750000
}
