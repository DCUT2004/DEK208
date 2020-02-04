class AmplifierConditionMessage extends LocalMessage;

var localized string AmplifiedMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				 optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if (Switch == 0)
	{
		return (RelatedPRI_1.PlayerName @ default.AmplifiedMessage);
	}
}

defaultproperties
{
	 DrawColor=(G=66,R=203,B=244)
     AmplifiedMessage="has amplified your magic weapons!"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=4
     PosY=0.750000
}
