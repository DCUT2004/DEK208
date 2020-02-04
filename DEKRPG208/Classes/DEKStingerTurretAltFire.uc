class DEKStingerTurretAltFire extends ProjectileFire;

var int ProjectileCount;

#exec  AUDIO IMPORT NAME="StingerAltFire" FILE="C:\UT2004\Sounds\StingerAltFire.WAV" GROUP="TurretSounds"

function DoFireEffect()
{
	local Vector	ProjOffset;
	local Vector	Start, X,Y,Z, HL, HN;

	if ( Instigator.IsA('ASVehicle') )
		ProjOffset = ASVehicle(Instigator).VehicleProjSpawnOffset;

	ProjSpawnOffset = ProjOffset;

	Instigator.MakeNoise(1.0);
    Instigator.GetAxes(Instigator.Rotation, X, Y, Z);

	Start = MyGetFireStart(X, Y, Z);

	ASVehicle(Instigator).CalcWeaponFire( HL, HN );
	SpawnProjectile(Start, Rotator(HL - Start));
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local int i;
    local DEKStingerTurretProj Proj;

    for(i = 0; i < ProjectileCount; i++)
    {
		Proj = Weapon.Spawn(class'DEKStingerTurretAltProj',,, Start, Dir);
    }
	Instigator.PlaySound(Sound'DEKRPG208.TurretSounds.StingerAltFire',,0.500);
	return none;
}

simulated function vector MyGetFireStart(vector X, vector Y, vector Z)
{
    return Instigator.Location + X*ProjSpawnOffset.X + Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;
}

defaultproperties
{
     ProjectileCount=5
     FireRate=1.000000
     AmmoClass=Class'UT2k4Assault.Ammo_Dummy'
     ProjectileClass=Class'DEKRPG208.DEKStingerTurretAltProj'
     BotRefireRate=0.700000
     FlashEmitterClass=Class'DEKRPG208.DEKStingerTurretMuzFX'
}
