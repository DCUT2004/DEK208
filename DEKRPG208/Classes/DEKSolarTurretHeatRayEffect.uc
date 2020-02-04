class DEKSolarTurretHeatRayEffect extends LinkBeamEffect;


var DEKSolarTurretHeatRayEndEffect EndFlash;
var vector LastScorchLocation;


simulated function Vector SetBeamRotation()
{
	SetRotation(rotator(EndEffect - Location));

	return Normal(EndEffect - Location);
}


simulated function Destroyed()
{
	if (EndFlash != None)
		EndFlash.Destroy();
	super.Destroyed();
}


simulated function Tick(float dt)
{
	local int c, n;
	local Vector BeamDir, HitLocation, HitNormal;
	local actor HitActor;
	local PlayerController P;
	local DEKSolarTurretHeatRayHitEffect HitEffect;

	if (Role == ROLE_Authority && (Instigator == None || Instigator.Controller == None))
	{
		Destroy();
		return;
	}

	// set beam start location
	BeamDir = SetBeamRotation();

	if (Level.NetMode != NM_DedicatedServer) {
		if (Instigator != None) {
			if (MuzFlash == None)
				MuzFlash = Spawn(class'DEKSolarTurretHeatRayMuzzleFlash', self);
		}
		else if (MuzFlash != None)
			MuzFlash.Destroy();

		if (EndFlash == None)
			EndFlash = Spawn(class'DEKSolarTurretHeatRayEndEffect', self);
		/*
		if (Sparks == None && EffectIsRelevant(EndEffect, false)) {
			P = Level.GetLocalPlayerController();
			if (P == Instigator.Controller || CheckMaxEffectDistance(P, Location))
				Sparks = Spawn(class'LinkSparks', self);
		}
		*/
	}
	if (Links != OldLinks || LinkColor != OldLinkColor || MuzFlash != OldMuzFlash) {
		// create/destroy children
		NumChildren = Min(Links+1, MAX_CHILDREN);
		if (Level.NetMode != NM_DedicatedServer) {
			for (c = 0; c < MAX_CHILDREN; c++)
			{
				if (c < NumChildren && Level.DetailMode != DM_Low) {
					if (Child[c] == None)
						Child[c] = Spawn(class'LinkBeamChild', self);

					Child[c].mSizeRange[0] = 2.0 + 4.0 * (NumChildren - c);
				}
				else if (Child[c] != None)
					Child[c].Destroy();
			}
		}


		switch (LinkColor)
		{
		case 0:
			Skins[0] = FinalBlend'XEffectMat.LinkBeamYellowFB';
			if (MuzFlash != None)
				MuzFlash.Skins[0] = Texture'XEffectMat.link_muz_yellow';
			LightHue = 40;
			break;
		case 1:
			Skins[0] = FinalBlend'LinkBeamYellowFB';
			if (MuzFlash != None)
				MuzFlash.Skins[0] = Texture'XEffectMat.link_muz_yellow';
			LightHue = 30;
			break;
		case 2:
			Skins[0] = FinalBlend'LinkBeamYellowFB';
			if (MuzFlash != None)
				MuzFlash.Skins[0] = Texture'XEffectMat.link_muz_yellow';
			LightHue = 60;
			break;
		}
		/*
		if (Sparks != None) {
			Sparks.SetLinkStatus(Links, False, 2);
			Sparks.bHidden = False;
			Sparks.LightHue = LightHue;
			Sparks.LightBrightness = LightBrightness;
			Sparks.LightRadius = LightRadius - 3;
		}
		*/
		OldLinks		= Links;
		OldLinkColor	= LinkColor;
		OldMuzFlash		= MuzFlash;
	}

	if (Level.bDropDetail || Level.DetailMode == DM_Low) {
		bDynamicLight = false;
		LightType = LT_None;
	}
	else if (bDynamicLight)
		LightType = LT_Steady;

	mSpawnVecA = EndEffect;

	if (EndFlash != None) {
		EndFlash.SetLocation(EndEffect);
	}
	PrevLoc = Location;
	PrevRot = Rotation;

	for (c = 0; c < NumChildren; c++) {
		if (Child[c] != None) {
			n = c+1;
			Child[c].SetLocation(Location);
			Child[c].SetRotation(Rotation);
			Child[c].mSpawnVecA     = mSpawnVecA;
			Child[c].mWaveShift     = mWaveShift;
			Child[c].mWaveAmplitude = 4.0 * n + mWaveAmplitude * (4.0 - n);
			Child[c].mWaveLockEnd   = False;
			Child[c].Skins[0]       = Skins[0];
		}
	}
	/*
	if (Sparks != None) {
		Sparks.SetLocation(EndEffect - BeamDir*10.0);
		if (bHitSomething)
			Sparks.SetRotation(Rotation);
		else
			Sparks.SetRotation(Rotator(-BeamDir));
		Sparks.mRegenRange[0] = Sparks.DesiredRegen;
		Sparks.mRegenRange[1] = Sparks.DesiredRegen;
		Sparks.bDynamicLight = true;
	}
	*/
	if (bHitSomething && Level.NetMode != NM_DedicatedServer) {
		HitActor = Trace(HitLocation, HitNormal, EndEffect + 100*BeamDir, EndEffect - 100*BeamDir, true);
		if (HitActor != None && (Level.TimeSeconds - ScorchTime > 0.1 || VSize(LastScorchLocation - EndEffect) > 30)) {
			ScorchTime = Level.TimeSeconds;
			LastScorchLocation = HitLocation;
			P = Level.GetLocalPlayerController();
			if (P != None && CheckMaxEffectDistance(P, Location)) {
				HitEffect = Spawn(class'DEKSolarTurretHeatRayHitEffect',,, HitLocation, rotator(-HitNormal));
				if (HitEffect != None && !HitActor.bWorldGeometry)
					HitEffect.SetNonWorldHit();
			}
		}
	}
}

simulated function bool CheckMaxEffectDistance(PlayerController P, vector SpawnLocation)
{
	return !P.BeyondViewDistance(SpawnLocation, 10000);
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     Links=5
     mSizeRange(0)=35.000000
     mWaveShift=250000.000000
     mWaveLockEnd=False
     LightHue=40
     LightBrightness=240.000000
     LightRadius=10.000000
     bUpdateSimulatedPosition=True
     NetPriority=3.000000
     Skins(0)=FinalBlend'XEffectMat.Link.LinkBeamYellowFB'
}
