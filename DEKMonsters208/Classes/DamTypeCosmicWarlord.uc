class DamTypeCosmicWarlord extends WeaponDamageType;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'CosmicSparks';
}

defaultproperties
{
     WeaponClass=Class'DEKMonsters208.WeaponCosmicWarlord'
     DeathString="%o was demolished by a Cosmic Warlord's plasma blast."
     DamageOverlayMaterial=Shader'UT2004Weapons.Shaders.ShockHitShader'
     DeathOverlayMaterial=Shader'UT2004Weapons.Shaders.ShockHitShader'
     DamageOverlayTime=0.800000
}
