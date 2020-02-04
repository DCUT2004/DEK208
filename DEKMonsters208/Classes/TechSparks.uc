class TechSparks extends xEmitter;

state Ticking
{
	simulated function Tick( float dt )
	{
		if( LifeSpan < 1.0 )
		{
			mRegenRange[0] *= LifeSpan;
			mRegenRange[1] = mRegenRange[0];
		}
	}
}

simulated function timer()
{
	GotoState('Ticking');
}

simulated function PostNetBeginPlay()
{
	SetTimer(LifeSpan - 1.0,false);
}


//Texture'XGameShadersB.Blood.BloodPuffOil' Texture'EpicParticles.Fire.SprayFire1'

defaultproperties
{
     mParticleType=PT_Line
     mStartParticles=0
     mMaxParticles=10
     mDelayRange(1)=0.100000
     mLifeRange(0)=0.500000
     mLifeRange(1)=0.800000
     mRegenRange(0)=0.000000
     mRegenRange(1)=20.000000
     mDirDev=(X=0.600000,Y=0.600000,Z=0.600000)
     mPosDev=(X=0.800000,Y=0.800000,Z=0.800000)
     mSpawnVecB=(X=8.000000,Z=0.040000)
     mSpeedRange(0)=70.000000
     mSpeedRange(1)=240.000000
     mMassRange(0)=1.500000
     mMassRange(1)=2.500000
     mAirResistance=0.000000
     mSizeRange(0)=1.500000
     mSizeRange(1)=6.500000
     mGrowthRate=-4.000000
     mColorRange(0)=(B=10,G=30,R=30)
     mColorRange(1)=(B=10,G=10,R=10)
     mAttenKa=0.000000
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=3.000000
     Skins(0)=Texture'XEffects.GreySpark'
     ScaleGlow=2.000000
     Style=STY_Additive
}
