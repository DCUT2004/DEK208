class DamTypeLightningTurretProj extends VehicleDamageType;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     VehicleClass=Class'DEKRPG208.DEKLightningTurret'
     DeathString="%o caught %k's ball lightning."
     FemaleSuicide="%o was faster than lightning."
     MaleSuicide="%o was faster than lightning."
     bDetonatesGoop=True
     bCauseConvulsions=True
     DamageOverlayMaterial=Shader'XGameShaders.PlayerShaders.LightningHit'
     DamageOverlayTime=0.900000
}
