class FM_BeamSentinel_Fire extends InstantFire;

var() class<ONSChargeBeamEffect> BeamEffectClass;

#exec OBJ LOAD FILE=..\Sounds\WeaponSounds.uax

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
	local ONSChargeBeamEffect Beam;

	if (ReflectNum == 0)

	Beam = spawn(BeamEffectClass,,, Start, Dir);
	Beam.HitLocation = HitLocation;

	if (Level.NetMode != NM_DedicatedServer)
		Beam.SetupBeam();
}

defaultproperties
{
     BeamEffectClass=Class'Onslaught.ONSChargeBeamEffect'
     DamageType=Class'DEKRPG208.DamTypeBeamSentinel'
     DamageMin=140
     DamageMax=160
     TraceRange=17000.000000
     Momentum=60000.000000
     bReflective=True
     FireSound=Sound'ONSVehicleSounds-S.PRV.PRVFire04'
     FireForce="ShockRifleFire"
     FireRate=2.000000
     AmmoClass=Class'XWeapons.ShockAmmo'
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-8.000000)
     ShakeOffsetRate=(X=-600.000000)
     ShakeOffsetTime=3.200000
     BotRefireRate=0.700000
     aimerror=0.000000
}
