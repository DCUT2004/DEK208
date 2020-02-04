class DamTypeLightningTurretHeadShot extends VehicleDamageType;

static function bool Headshot()
{
    return true;
}

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     VehicleClass=Class'DEKRPG208.DEKLightningTurret'
     DeathString="%o's head was blown off by %k's lightning turret."
     FemaleSuicide="%o shot herself in the head with her turret."
     MaleSuicide="%o shot himself in the head with his turret."
     bAlwaysSevers=True
     bDetonatesGoop=True
     bCauseConvulsions=True
     DamageOverlayMaterial=Shader'XGameShaders.PlayerShaders.LightningHit'
     DamageOverlayTime=0.900000
}
