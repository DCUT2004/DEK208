class DamTypeCosmicBrute extends WeaponDamageType;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'CosmicSparks';
}

defaultproperties
{
     WeaponClass=Class'DEKMonsters208.WeaponCosmicBrute'
     DeathString="%o was zapped by a Cosmic Brute's plasma."
     DamageOverlayMaterial=Shader'UT2004Weapons.Shaders.ShockHitShader'
     DeathOverlayMaterial=Shader'UT2004Weapons.Shaders.ShockHitShader'
     DamageOverlayTime=0.800000
}
