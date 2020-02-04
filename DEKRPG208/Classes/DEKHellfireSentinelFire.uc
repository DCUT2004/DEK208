class DEKHellfireSentinelFire extends ProjectileFire;

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
	local Projectile p;

	p = Weapon.Spawn(ProjectileClass, Instigator, , Start, Dir);
	if ( p == None )
		return None;

	p.Damage *= DamageAtten;
	
	if (Instigator != None && Instigator.Controller != None && DEKHellfireSentinelController(Instigator.Controller) != None)
	{
		p.Damage *= DEKHellfireSentinelController(Instigator.Controller).DamageAdjust;		// set by LoadedEngineer
	}
	
	return p;
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
     FireSound=Sound'ONSVehicleSounds-S.Tank.TankFire01'
     FireRate=3.000000
     ProjectileClass=Class'DEKRPG208.DEKHellfireSentinelProj'
}
