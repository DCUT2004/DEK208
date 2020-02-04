class UpgradeShockBeamFire extends ShockBeamFire;

function DoFireEffect()
{
    local Vector StartTrace,X,Y,Z;
    local Rotator R, Aim;

    Instigator.MakeNoise(1.0);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    if ( PlayerController(Instigator.Controller) != None )
    {
		// for combos
	   Weapon.GetViewAxes(X,Y,Z);
		StartTrace = StartTrace + X*class'UpgradeShockProjFire'.Default.ProjSpawnOffset.X;
		if ( !Weapon.WeaponCentered() )
			StartTrace = StartTrace + Weapon.Hand * Y*class'UpgradeShockProjFire'.Default.ProjSpawnOffset.Y + Z*class'UpgradeShockProjFire'.Default.ProjSpawnOffset.Z;
	}

    Aim = AdjustAim(StartTrace, AimError);
	R = rotator(vector(Aim) + VRand()*FRand()*Spread);
    DoTrace(StartTrace, R);
}

//for bot combos
function Rotator AdjustAim(Vector Start, float InAimError)
{
	if ( (UpgradeShockRifle(Weapon) != None) && (UpgradeShockRifle(Weapon).ComboTarget != None) )
		return Rotator(UpgradeShockRifle(Weapon).ComboTarget.Location - Start);

	return Super.AdjustAim(Start, InAimError);
}

defaultproperties
{
}
