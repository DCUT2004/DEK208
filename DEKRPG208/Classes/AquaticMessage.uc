class AquaticMessage extends LocalMessage;

var localized string AquaticMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	if (Switch == 0)
	{
		return default.AquaticMessage;
	}
}

defaultproperties
{
     AquaticMessage="Just keep swimming, just keep swimming!"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(B=155,G=243,R=155)
     PosY=0.750000
}
