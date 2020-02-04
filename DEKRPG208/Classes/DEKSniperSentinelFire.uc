class DEKSniperSentinelFire extends InstantFire;

var() class<DEKSniperSentinelTracer> BeamEffectClass;
var() Vector ProjSpawnOffset;

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
		Beam = spawn(BeamEffectClass,,, Start, Dir);
}

simulated function vector MyGetFireStart(vector X, vector Y, vector Z)
{
    return Instigator.Location + X*ProjSpawnOffset.X + Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;
}

defaultproperties
{
     BeamEffectClass=Class'DEKRPG208.DEKSniperSentinelTracer'
     ProjSpawnOffset=(X=15.000000)
     DamageType=Class'DEKRPG208.DamTypeSniperSentinel'
     DamageMin=60
     DamageMax=60
     FireSound=Sound'NewWeaponSounds.NewSniperShot'
     FireRate=1.330000
}
