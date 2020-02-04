class DecayChain extends xEmitter;

defaultproperties
{
     mParticleType=PT_Beam
     mMaxParticles=5
     mRegenDist=12.000000
     mSpinRange(0)=45000.000000
     mSizeRange(0)=4.000000
     mColorRange(0)=(B=240,G=240,R=240)
     mColorRange(1)=(B=240,G=240,R=240)
     mAttenuate=False
     mAttenKa=0.000000
     mWaveFrequency=0.080000
     mWaveAmplitude=1.000000
     mWaveShift=100000.000000
     mBendStrength=15.000000
     //bOnlyOwnerSee=True
     bNetTemporary=False
     bReplicateInstigator=True
     RemoteRole=ROLE_SimulatedProxy
     //Skins(0)=FinalBlend'XEffectMat.Link.LinkBeamRedFB'
	 Skins(0)=Shader'AWGlobal.Shaders.WetBlood01aw'
     Style=STY_Additive
     bHardAttach=True
     SoundVolume=192
     SoundRadius=96.000000
}
