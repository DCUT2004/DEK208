class DamTypeDEKRailGunShot extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     WeaponClass=Class'DEKWeapons208.DEKRailGun'
     DeathString="%o rode %k's rail gun."
     FemaleSuicide="%o had a zapgasm."
     MaleSuicide="%o had a zapgasm."
     bDetonatesGoop=True
     bCauseConvulsions=True
     DamageOverlayMaterial=Shader'XGameShaders.PlayerShaders.LightningHit'
     DamageOverlayTime=0.900000
     GibPerterbation=0.200000
     VehicleDamageScaling=0.700000
}
