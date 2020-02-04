class PhantomOUTMessage extends LocalMessage;

var(Message) localized string LevelUpString;
var(Message) color RedColor;

static function color GetColor(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
		return Default.RedColor;
}

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	if (Switch == 1)
	   return PRI1.PlayerName @ Default.LevelUpString;
}

defaultproperties
{
     LevelUpString="is OUT!"
     RedColor=(G=0,R=255,B=0,A=255)
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(G=0,R=255,B=0)
     StackMode=SM_Down
     PosY=0.790000
}