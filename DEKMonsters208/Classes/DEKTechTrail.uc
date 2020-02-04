class DEKTechTrail extends xEmitter;

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


 //  Skins(0)=Texture'XGameShadersB.Blood.BloodJetc'
 //  Style=STY_Alpha

defaultproperties
{
     mParticleType=PT_Line
     mMaxParticles=12
     mDelayRange(1)=0.100000
     mLifeRange(0)=0.400000
     mLifeRange(1)=1.200000
     mRegenRange(0)=60.000000
     mRegenRange(1)=80.000000
     mDirDev=(X=0.600000,Y=0.600000,Z=0.600000)
     mPosDev=(X=0.800000,Y=0.800000,Z=0.800000)
     mSpawnVecB=(X=2.000000,Z=0.030000)
     mSpeedRange(0)=150.000000
     mSpeedRange(1)=200.000000
     mMassRange(0)=1.500000
     mMassRange(1)=2.500000
     mAirResistance=0.000000
     mSizeRange(0)=8.500000
     mSizeRange(1)=1.500000
     mGrowthRate=-2.000000
     mColorRange(0)=(B=1,G=1,R=20)
     mColorRange(1)=(B=1,G=1,R=33)
     mAttenKa=0.000000
     mNumTileColumns=4
     mNumTileRows=4
     Physics=PHYS_Trailer
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=3.500000
     Skins(0)=Texture'DEKMonstersTexturesMaster206E.GoldMonsters.BloodPuffGold'
     ScaleGlow=2.000000
     Style=STY_Additive
}
