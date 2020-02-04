class DEKStingerTurretFire extends ProjectileFire;

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

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local DEKStingerTurretProj Proj;

    Proj = Weapon.Spawn(class'DEKStingerTurretProj',,, Start, Dir);
    if ( Proj == None )
        return None;

    Proj.Damage *= DamageAtten;
    return Proj;
}

simulated function vector MyGetFireStart(vector X, vector Y, vector Z)
{
    return Instigator.Location + X*ProjSpawnOffset.X + Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;
}

simulated function bool AllowFire()
{
    return true;
}

defaultproperties
{
     FireRate=0.200000
     ProjectileClass=Class'DEKRPG208.DEKStingerTurretProj'
     Spread=0.015000
     SpreadStyle=SS_Random
}
