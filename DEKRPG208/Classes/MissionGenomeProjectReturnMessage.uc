class MissionGenomeProjectReturnMessage extends LocalMessage;

var(Message) localized string LevelUpString;
var(Message) color GreenColor;

static function color GetColor(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
		return Default.GreenColor;
}

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	   return Default.LevelUpString;
}

defaultproperties
{
     LevelUpString="Return the vial to the node!"
     GreenColor=(G=244,R=89,B=66,A=255)
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=1
     DrawColor=(G=244,R=89,B=66)
     StackMode=SM_Down
     PosY=0.100000
     FontSize=0.7000
}