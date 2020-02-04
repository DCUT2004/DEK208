class NullEntropyConditionMessage extends LocalMessage;

var localized string NullEntropyMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				 optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	return Default.NullEntropyMessage;
}

defaultproperties
{
     NullEntropyMessage="X"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=2
     DrawColor=(B=219,G=0,R=154)
     PosX=0.300000
     PosY=0.700000
}
