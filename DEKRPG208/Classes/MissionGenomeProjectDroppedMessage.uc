class MissionGenomeProjectDroppedMessage extends LocalMessage;

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
     LevelUpString="No trans allowed! Vial dropped"
     RedColor=(R=255,A=255)
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=4
     DrawColor=(R=255)
     StackMode=SM_Down
     PosY=0.100000
     FontSize=0.7000
}