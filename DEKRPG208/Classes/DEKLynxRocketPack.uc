class DEKLynxRocketPack extends ONSRVWebLauncher;

var float MaxLockRange, LockAim;

state ProjectileFireMode
{
	function Fire(Controller C)
	{
		local DEKLynxRocketProjectile R;
		local float BestAim, BestDist;

		R = DEKLynxRocketProjectile(SpawnProjectile(ProjectileClass, False));
		if (R != None)
		{
			if (AIController(C) != None)
				R.HomingTarget = C.Enemy;
			else
			{
				BestAim = LockAim;
				R.HomingTarget = C.PickTarget(BestAim, BestDist, vector(WeaponFireRotation), WeaponFireLocation, MaxLockRange);
			}
		}
	}
}

defaultproperties
{
     MaxLockRange=30000.000000
     LockAim=0.975000
     PitchUpLimit=18000
     bDualIndependantTargeting=True
     bShowChargingBar=False
     FireInterval=0.650000
     FlashEmitterClass=Class'Onslaught.ONSTankFireEffect'
     FireSoundClass=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
     FireForce="RocketLauncherFire"
     ProjectileClass=Class'DEKRPG208.DEKLynxRocketProjectile'
     AIInfo(0)=(bTrySplash=True)
     CollisionRadius=60.000000
}
