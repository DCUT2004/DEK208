class DamTypeLightningTurretCombo extends VehicleDamageType;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     VehicleClass=Class'DEKRPG208.DEKLightningTurret'
     DeathString="%o was fried to a crisp by %k's Lightning Turret combo."
     FemaleSuicide="%o electrocuted herself."
     MaleSuicide="%o electrocuted himself."
     bDetonatesGoop=True
     bCauseConvulsions=True
     DamageOverlayMaterial=Shader'XGameShaders.PlayerShaders.LightningHit'
     DamageOverlayTime=0.900000
}
