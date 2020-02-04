class DamTypeDEKSolarTurretBeam extends VehicleDamageType abstract;


static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictimHealth)
{
	HitEffects[0] = class'HitSmoke';

	if (VictimHealth <= 0)
		HitEffects[1] = class'HitFlameBig';
	else if (FRand() < 0.8)
		HitEffects[1] = class'HitFlame';
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     VehicleClass=Class'DEKRPG208.DEKSolarTurret'
     DeathString="%o was fried by %k's solar ray."
     FemaleSuicide="%o fried herself."
     MaleSuicide="%o fried himself."
     bInstantHit=True
     bAlwaysSevers=True
     bDetonatesGoop=True
     bFlaming=True
     GibModifier=2.000000
     FlashFog=(X=800.000000,Y=600.000000,Z=240.000000)
     GibPerterbation=0.500000
}
