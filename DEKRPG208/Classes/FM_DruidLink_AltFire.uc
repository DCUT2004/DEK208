class FM_DruidLink_AltFire extends RPGLinkFire;

var	float VehicleDamageMult;

function PlayFiring()
{
	if ( LinkGun(Weapon).Links <= 0 )
		ClientPlayForceFeedback("BLinkGunBeam1");

	super(WeaponFire).PlayFiring();
}

simulated function vector GetFireStart(vector X, vector Y, vector Z)
{
    return ASVehicle(Instigator).GetFireStart();
}

simulated function bool AllowFire()
{
    return true;
}

simulated function bool myHasAmmo( LinkGun LinkGun )
{
	return true;
}

simulated function Rotator	GetPlayerAim( vector StartTrace, float InAimError )
{
	local vector HL, HN;
	ASVehicle(Instigator).CalcWeaponFire( HL, HN );
	return Rotator( HL - StartTrace );
}

simulated function float AdjustLinkDamage( LinkGun LinkGun, Actor Other, float Damage )
{
	Damage = Damage * (Linkgun.Links+1);

	if ( Other.IsA('Vehicle') )
		Damage *= VehicleDamageMult;

	return Damage;
}

defaultproperties
{
     VehicleDamageMult=2.500000
     BeamEffectClass=Class'UT2k4AssaultFull.FX_LinkTurret_BeamEffect'
     DamageType=Class'UT2k4AssaultFull.DamTypeLinkTurretBeam'
     Damage=12
     TraceRange=2000.000000
     FireAnim="Fire"
     AmmoClass=Class'UT2k4Assault.Ammo_Dummy'
     AmmoPerFire=0
}
