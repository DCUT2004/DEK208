class UpgradeShieldAltFire extends ShieldAltFire;

function Timer()
{
    if (!bIsFiring)
    {
		RampTime = 0;
        if ( !Weapon.AmmoMaxed(1) )
            Weapon.AddAmmo(2,1); //add 2 every tick instead of 1
        else
            SetTimer(0, false);
    }
    else
    {
        if ( !Weapon.ConsumeAmmo(1,1) )
        {
            if (Weapon.ClientState == WS_ReadyToFire)
                Weapon.PlayIdle();
            StopFiring();
        }
        else
			RampTime += AmmoRegenTime;
    }
	
	SetBrightness(false);
}

defaultproperties
{
     AmmoPerFire=5
}
