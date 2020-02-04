//=============================================================================
// HealthPack
//=============================================================================
class LuckyHealthPack extends MiniHealthPack
	notplaceable;

defaultproperties
{
     HealingAmount=15
     PickupMessage="Lucky Health + "
     StaticMesh=StaticMesh'E_Pickups.Health.MidHealth'
     CullDistance=5500.000000
     DrawScale=0.200000
     Skins(0)=Shader'D-E-K-HoloGramFX.PlayerPictureEffect.Pic_1'
     Skins(1)=FinalBlend'MutantSkins.Shaders.MutantGlowFinal'
     TransientSoundVolume=0.350000
}
