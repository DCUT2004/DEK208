class ArtifactPriestMagnet extends EnhancedRPGArtifact;

function BotConsider()
{
	if (Instigator.Controller.Adrenaline < AdrenalineRequired)
		return;

	if ( !bActive && Instigator.Controller.Enemy != None
		   && Instigator.Controller.CanSee(Instigator.Controller.Enemy) && NoArtifactsActive() && FRand() < 0.3 )	// fairly rare
		Activate();
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');
}

function Activate()
{
	local Vehicle V;
	local Vector FaceVect;
	local Rotator FaceDir;
    local Projectile p;

	Super(EnhancedRPGArtifact).Activate();
	
	if (Instigator != None)
	{
		if(Instigator.Controller.Adrenaline < (AdrenalineRequired*AdrenalineUsage))
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, AdrenalineRequired*AdrenalineUsage, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		
		if (LastUsedTime  + (TimeBetweenUses*TimeUsage) > Instigator.Level.TimeSeconds)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 5000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// cannot use yet
		}

		V = Vehicle(Instigator);
		if (V != None )
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// can't use in a vehicle

		}

		// change the guts of it
		FaceDir = Instigator.Controller.GetViewRotation();
		FaceVect = Vector(FaceDir);

	    p = Instigator.Spawn(class'PriestMagnet',,, Instigator.Location + Instigator.EyePosition() + (FaceVect * Instigator.Collisionradius * 1.1), FaceDir);
		if (p != None)
		{
			Instigator.Controller.Adrenaline -= (AdrenalineRequired*AdrenalineUsage);
			if (Instigator.Controller.Adrenaline < 0)
				Instigator.Controller.Adrenaline = 0;
	
			SetRecoveryTime(TimeBetweenUses*TimeUsage);

			p.PlaySound(Sound'WeaponSounds.RocketLauncher.RocketLauncherFire',,Instigator.TransientSoundVolume,,Instigator.TransientSoundRadius);
		}
	}
	bActive = false;
	GotoState('');
	return;
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle.";
	else if (Switch == 5000)
		return "Cannot use this artifact again yet.";
	else
		return switch @ "Adrenaline is required to use this artifact";
}

defaultproperties
{
     AdrenalineRequired=50
     TimeBetweenUses=5.000000
     CostPerSec=1
     MinActivationTime=0.000001
     PickupClass=Class'DEKRPG208.ArtifactPriestMagnetPickup'
     IconMaterial=Texture'XEffects.Skins.MuzShockFlash_t'
     ItemName="Magnet"
}
