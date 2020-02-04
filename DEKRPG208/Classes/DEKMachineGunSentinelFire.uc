class DEKMachineGunSentinelFire extends InstantFire;

function DoFireEffect()
{
    local Vector	StartTrace, HL, HN;
    local Rotator	R;
	local Actor		HitActor;

	if ( Instigator == None )
		return;

    Instigator.MakeNoise(1.0);

    StartTrace	= ASVehicle(Instigator).GetFireStart();
	HitActor	= ASVehicle(Instigator).CalcWeaponFire( HL, HN );
    R = Rotator(Normal(HL-StartTrace) + VRand()*FRand()*Spread);
	DoTrace(StartTrace, R);
}

function InitEffects()
{
	if ( Level.DetailMode == DM_Low )
		FlashEmitterClass = None;
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

defaultproperties
{
     DamageType=Class'DEKRPG208.DamTypeMachineGunSentinel'
     DamageMin=4
     DamageMax=5
     FireSound=Sound'ONSVehicleSounds-S.Tank.TankMachineGun01'
     FireRate=0.200000
     Spread=0.030000
}
