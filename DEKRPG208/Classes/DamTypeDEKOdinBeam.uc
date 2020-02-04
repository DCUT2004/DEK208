class DamTypeDEKOdinBeam extends VehicleDamageType abstract;


static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictimHealth)
{
	HitEffects[0] = class'HitSmoke';
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     VehicleClass=Class'DEKRPG208.DEKOdinTurret'
     DeathString="%o was evaporated into thin air by %k's Odin turret."
     FemaleSuicide="%o's Odin turret malfunctioned."
     bDetonatesGoop=True
     bSkeletize=True
     GibModifier=0.000000
     DamageOverlayMaterial=Shader'UT2004Weapons.Shaders.ShockHitShader'
     DamageOverlayTime=1.000000
     VehicleDamageScaling=1.333333
}
