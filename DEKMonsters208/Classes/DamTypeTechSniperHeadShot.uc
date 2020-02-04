class DamTypeTechSniperHeadShot extends DamTypeSniperHeadShot
	abstract;


static function IncrementKills(Controller Killer)
{
	local xPlayerReplicationInfo xPRI;
	
	if ( PlayerController(Killer) == None )
		return;
		
	PlayerController(Killer).ReceiveLocalizedMessage( Default.KillerMessage, 0, Killer.PlayerReplicationInfo, None, None );
	xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	if ( xPRI != None )
	{
		xPRI.headcount++;
		if ( (xPRI.headcount == 15) && (UnrealPlayer(Killer) != None) )
			UnrealPlayer(Killer).ClientDelayedAnnouncementNamed('HeadHunter',15);
	}
}		

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
    HitEffects[1] = class'HitFlameBig';
}

defaultproperties
{
     WeaponClass=Class'DEKMonsters208.WeaponTechSniper'
     DeathString="%o's cranium was made extra crispy by a Tech Sniper."
     bArmorStops=False
}
