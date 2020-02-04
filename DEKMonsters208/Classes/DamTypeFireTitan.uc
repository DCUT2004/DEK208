class DamTypeFireTitan extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     WeaponClass=Class'DEKMonsters208.WeaponFireTitan'
     DeathString="%o was fried by %k's fireball."
     FemaleSuicide="%o snuffed herself with the fireball."
     MaleSuicide="%o snuffed himself with the fireball."
     bDetonatesGoop=True
     DamageOverlayMaterial=TexPanner'DEKWeaponsMaster206.fX.RedPanner'
     DamageOverlayTime=0.800000
}
