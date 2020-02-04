class DamTypeBeamWarlord extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     WeaponClass=Class'DEKMonsters208.WeaponBeamWarlord'
     DeathString="%o was zapped by a warlord."
     bDetonatesGoop=True
     KDamageImpulse=10000.000000
}
