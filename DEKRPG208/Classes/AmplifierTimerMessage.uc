class AmplifierTimerMessage extends LocalMessage;

var(Message) localized string LevelUpString;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	   return Default.LevelUpString @ switch;
}

defaultproperties
{
	 DrawColor=(G=66,R=203,B=244)
     LevelUpString="Magic Amplifier:"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=1
     StackMode=SM_Down
     PosY=0.100000
     FontSize=0.4000
}