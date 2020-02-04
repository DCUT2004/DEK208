//This message is sent to players who have some damage-causing condition (e.g. poison)
class AdrenMessage extends LocalMessage;

var(Message) localized string AdrenMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	return Switch @ default.AdrenMessage;
}

defaultproperties
{
     AdrenMessage="Adrenaline."
     bIsUnique=True
     bFadeMessage=True
     Lifetime=1
     DrawColor=(B=53,G=160)
     PosX=0.110000
     PosY=0.130000
}
