class ImmobilizedConditionMessage extends LocalMessage;

var localized string ImmobilizedMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				 optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	return default.ImmobilizedMessage;
}

defaultproperties
{
     ImmobilizedMessage="Immobilized"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(R=255)
     PosY=0.700000
}
