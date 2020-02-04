class DEKLynxTurretWeapon extends ONSManualGun;

var float MaxLockRange, LockAim;

function TraceFire(Vector Start, Rotator Dir)
{
//
}

state InstantFireMode
{
//
}

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
     bInstantFire=False
     FireInterval=0.650000
     FireSoundClass=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
     ProjectileClass=Class'DEKRPG208.DEKLynxRocketProjectile'
     Skins(0)=Shader'DEKRPGTexturesMaster207P.Skins.LynxEnergyTurretShader'
}
