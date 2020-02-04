class NoClassMessage extends LocalMessage;

var(Message) localized string PressLString, NoClassString;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if (Switch == 0)
	    return Default.NoClassString@Default.PressLString;
	else
	    return Default.NoClassString;
}

defaultproperties
{
     NoClassString="You must purchase a class."
     PressLString="(Press L)"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=1
     StackMode=SM_Down
     PosY=0.100000
     FontSize=0.7000
}