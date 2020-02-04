//This message is sent to players who have some damage-causing condition (e.g. poison)
class HealShieldConditionMessage extends LocalMessage;

var localized string HealShieldMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				 optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if(RelatedPRI_1 == None)
		return "";
	return (RelatedPRI_1.PlayerName @ default.HealShieldMessage);
}

defaultproperties
{
     HealShieldMessage="boosted your shield."
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(B=20,G=250,R=250)
     PosY=0.750000
}
