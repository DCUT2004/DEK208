class DEKStingerTurretAttachment extends WA_Turret_Minigun;

#exec  AUDIO IMPORT NAME="StingerTwoFire" FILE="C:\UT2004\Sounds\StingerTwoFire.WAV" GROUP="TurretSounds"

simulated function PostBeginPlay()
{
	local Rotator	R;
	
    if ( mShellCaseEmitter != None )
        mShellCaseEmitter.Destroy();

	if ( SmokeEmitter != None )
        SmokeEmitter.Destroy();

	super.PostBeginPlay();

	 R					= GetBoneRotation( 'CannonBone' );
	 CurrentCannonRoll	= R.Yaw;
}

simulated function UpdateTracer()
{
	return;
}

simulated Event StartFiring()
{
	bFiring	= true;
	
	if ( Instigator != None )
	{
		if (FiringMode == 0)
		Instigator.AmbientSound	= FiringSound;
	}
	GotoState('Firing');
}

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     mShellCaseEmitterClass=None
     mMuzFlashClass=None
     mTracerClass=None
     SmokeEmitterClass=None
     FiringSound=Sound'DEKRPG208.TurretSounds.StingerTwoFire'
     WindingSound=None
}
