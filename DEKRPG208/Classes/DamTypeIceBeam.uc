class DamTypeIceBeam extends DamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth)
{
    HitEffects[0] = class'HitSmoke';
	if (Rand(25) > VictemHealth)
		HitEffects[1] = class'HitFlame';
}

defaultproperties
{
     DeathString="%o was frozen by %k's ice beam."
     FemaleSuicide="%o had a cold experience."
     MaleSuicide="%o had a cold experience."
     bSuperWeapon=True
     DamageOverlayTime=1.000000
     GibPerterbation=0.250000
}
