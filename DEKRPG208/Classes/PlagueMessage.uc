class PlagueMessage extends LocalMessage;

var localized string PlagueMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				 optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
		return Default.PlagueMessage @ Switch;
}

defaultproperties
{
     PlagueMessage="Plague!"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=2
     DrawColor=(B=23,G=196,R=29)
     PosY=0.700000
}
