class DruidLinkSentinelBeamEffect extends xEmitter;

#exec OBJ LOAD FILE=XEffectMat.utx

defaultproperties
{
     mParticleType=PT_Beam
     mRegen=False
     mMaxParticles=1
     mLifeRange(0)=0.400000
     mLifeRange(1)=0.400000
     mRegenDist=65.000000
     mSpinRange(0)=45000.000000
     mSizeRange(0)=11.000000
     mColorRange(0)=(B=140,G=240,R=140)
     mColorRange(1)=(B=240,G=240,R=240)
     mAttenuate=False
     mAttenKa=0.000000
     mWaveFrequency=0.060000
     mWaveAmplitude=8.000000
     mWaveShift=100000.000000
     mBendStrength=3.000000
     mWaveLockEnd=True
     LightType=LT_Steady
     LightHue=100
     LightSaturation=100
     LightBrightness=255.000000
     LightRadius=4.000000
     bDynamicLight=True
     bReplicateInstigator=True
     bNetInitialRotation=True
     RemoteRole=ROLE_SimulatedProxy
     Skins(0)=FinalBlend'XEffectMat.Link.LinkBeamGreenFB'
     Style=STY_Additive
}
