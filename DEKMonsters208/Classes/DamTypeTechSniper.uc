class DamTypeTechSniper extends DamTypeSniperShot
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     WeaponClass=Class'DEKMonsters208.WeaponTechSniper'
     DeathString="%o was zapped by a Tech Sniper."
     bArmorStops=False
     VehicleDamageScaling=1.500000
}
