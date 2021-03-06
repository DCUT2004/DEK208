class NecroEnergyChargeEmitter extends xEmitter;

simulated function PostBeginPlay()
{
	SetTimer(0.5, true);
	Super.PostBeginPlay();
}

function Timer()
{
	mRegen=False;
}

defaultproperties
{
     mParticleType=PT_Line
     mSpawningType=ST_Explode
     mStartParticles=0
     mMaxParticles=100
     mLifeRange(0)=0.200000
     mLifeRange(1)=0.200000
     mRegenRange(0)=50.000000
     mRegenRange(1)=50.000000
     mPosDev=(X=5.000000,Y=5.000000,Z=5.000000)
     mSpawnVecB=(X=60.000000,Z=0.960000)
     mSpeedRange(0)=-50.000000
     mSpeedRange(1)=-50.000000
     mPosRelative=True
     mAirResistance=0.000000
     mSizeRange(0)=8.000000
     mSizeRange(1)=16.000000
     Physics=PHYS_Rotating
     LifeSpan=10.000000
     Skins(0)=Texture'XEffects.Skins.TracerT'
     Style=STY_Additive
     bFixedRotationDir=True
     RotationRate=(Yaw=16000)
}
