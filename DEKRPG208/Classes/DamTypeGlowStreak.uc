class DamTypeGlowStreak extends DamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     DeathString="%o was struck down by %k's glow streak."
     FemaleSuicide="%o was drawn to her glow streak."
     MaleSuicide="%o was drawn to his glow streak."
     bDetonatesGoop=True
     bDelayedDamage=True
}
