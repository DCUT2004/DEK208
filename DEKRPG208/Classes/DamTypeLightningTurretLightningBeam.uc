class DamTypeLightningTurretLightningBeam extends VehicleDamageType;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     VehicleClass=Class'DEKRPG208.DEKLightningTurret'
     DeathString="%o was struck by %k's lightning cannon."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     bDetonatesGoop=True
     bCauseConvulsions=True
     DamageOverlayMaterial=Shader'XGameShaders.PlayerShaders.LightningHit'
     DamageOverlayTime=0.900000
     VehicleDamageScaling=1.500000
}
