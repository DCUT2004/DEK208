class DEKINIInvasionMessages extends CriticalEventPlus;

var(Message) localized string msgPlayersRemaining;
var(Message) localized string msgLastHope;
var(Message) localized string msgPlayerDenied;
var int m_i;

static function int GetRemainingPlayers(Object OptionalObject, bool Own)
{
	local array<PlayerReplicationInfo> mates;
	local int i;
	local int nValue;
	i = 0;
	if (Own) {
		nValue = 0;
	} else {
		nValue = -1;
	}
	GameReplicationInfo(OptionalObject).GetPRIArray(mates);
	for (i=0; i < mates.length; i++) {
		if (!mates[i].bOutOfLives && !mates[i].bIsSpectator && !mates[i].bOnlySpectator) {
			nValue++;
		}
	}
	return nValue;
}

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	
	if (Switch == 0) {
		return RelatedPRI_1.PlayerName@default.msgLastHope;
	} else if (Switch == 1){
		return string(GetRemainingPlayers(OptionalObject, false))@default.msgPlayersRemaining;
	} else if (Switch == 2){
		return RelatedPRI_1.PlayerName@default.msgPlayerDenied;
	} else if (Switch == 3){
		return string(GetRemainingPlayers(OptionalObject, true))@default.msgPlayersRemaining;
	} else {
		return "";
	}
}

defaultproperties
{
     msgPlayersRemaining="Players Remaining!"
     msgLastHope="is our last hope!"
     msgPlayerDenied="shot that monster's deemer down!! Heck Yeah!"
     Lifetime=6
     PosY=0.700000
}
