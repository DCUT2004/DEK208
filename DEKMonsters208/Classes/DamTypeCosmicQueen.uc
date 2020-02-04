class DamTypeCosmicQueen extends WeaponDamageType;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'CosmicSparks';
}

defaultproperties
{
     WeaponClass=Class'DEKMonsters208.WeaponCosmicQueen'
     DeathString="%o was slaughtered by the Cosmic Queen."
     DamageOverlayMaterial=Shader'UT2004Weapons.Shaders.ShockHitShader'
     DeathOverlayMaterial=Shader'UT2004Weapons.Shaders.ShockHitShader'
     DamageOverlayTime=0.800000
}
