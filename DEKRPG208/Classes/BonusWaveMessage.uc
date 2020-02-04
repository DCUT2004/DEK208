class BonusWaveMessage extends Localmessage;

var(Message) localized string BonusMessage;

////////////////////////////////////////////////////////////////////////////////

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	return PRI1.PlayerName @ default.BonusMessage;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
     BonusMessage="Wave 17 is now unlocked!"
     bIsUnique=True
     bIsPartiallyUnique=True
     bFadeMessage=True
     Lifetime=7
     DrawColor=(B=244,G=168,R=216)
     PosY=0.150000
}
