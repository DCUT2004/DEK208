//This message is sent to players who have some damage-causing condition (e.g. poison)
class KnockbackConditionMessage extends LocalMessage;

var localized string KnockbackMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				 optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	return Default.KnockbackMessage;
}

defaultproperties
{
     KnockbackMessage="X"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=1
     DrawColor=(B=0,G=0)
     PosX=0.650000
     PosY=0.700000
}
