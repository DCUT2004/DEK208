class DEKAutoSniperFire extends InstantFire;

var() class<StingerBeam> BeamEffectClass;

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

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
	local DEKSniperSentinelTracer Beam;

	if (ReflectNum == 0)
		Beam = spawn(class'DEKSniperSentinelTracer',,, Start, Dir);
}

defaultproperties
{
     DamageType=Class'DEKRPG208.DamTypeAutoSniper'
     DamageMin=93
     DamageMax=93
     TraceRange=55000.000000
     Momentum=60000.000000
     bReflective=True
     FireSound=Sound'NewWeaponSounds.NewSniperShot'
     FireForce="ShockRifleFire"
     FireRate=1.300000
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-8.000000)
     ShakeOffsetRate=(X=-600.000000)
     ShakeOffsetTime=3.200000
     BotRefireRate=0.700000
     aimerror=0.000000
}
