class DamTypeMeteor extends DamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     DeathString="%o was crushed by %k's meteor."
     FemaleSuicide="%o crushed herself with her meteor."
     MaleSuicide="%o crushed himself with his meteor."
     bDetonatesGoop=True
     bDelayedDamage=True
     DamageOverlayMaterial=Shader'DEKRPGTexturesMaster207P.fX.PulseRedShader'
     DamageOverlayTime=0.800000
}
