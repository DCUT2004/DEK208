class ArcaneHeatMessage extends LocalMessage;

var(Message) localized string LevelUpString;
var(Message) color RedColor;

static function color GetColor(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
		return Default.RedColor;
}

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	   return Default.LevelUpString;
}

defaultproperties
{
     LevelUpString="Heat"
     RedColor=(G=0,R=255,B=0,A=255)
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(G=0,R=255,B=0)
     StackMode=SM_Down
     PosY=0.790000
}