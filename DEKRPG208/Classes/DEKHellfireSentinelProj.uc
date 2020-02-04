class DEKHellfireSentinelProj extends Projectile;

var class<Projectile> ChildProjectileClass;
var float SpreadFactor;

simulated function PostBeginPlay()
{
    local Rotator R;
	
	Velocity = Vector(Rotation) * Speed;  
    Super(Projectile).PostBeginPlay();
    R = Rotation;
	Velocity.z += TossZ; 
    SetRotation(R);
	
	SetTimer(0.1, False);
	SetCollision(false,false,false);
}

simulated function Timer()
{
    local int i, j;
    local Projectile Child;
    local float Mag;
    local vector CurrentVelocity;

    CurrentVelocity = 0.85 * Velocity;

    // one shell in each of 9 zones
    for (i = -1; i < 2; i++)
	{
        for (j= -1; j < 2; j++)
		{
            if (Abs(i) + Abs(j) > 1)
                Mag = 0.7;
            else
                Mag = 1.0;
            Child = Spawn(ChildProjectileClass, self,, Location);
            if (Child != None)
			{
                Child.Velocity = CurrentVelocity;
                Child.Velocity.X += RandRange(0.3, 1.0) * Mag * i * SpreadFactor;
                Child.Velocity.Y += RandRange(0.3, 1.0) * Mag * j * SpreadFactor;
                Child.Velocity.Z = Child.Velocity.Z + SpreadFactor * (FRand() - 0.5);
                Child.InstigatorController = InstigatorController;
            }
        }
    }
    Destroy();
}

simulated function destroyed()
{
	Super.Destroyed();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
     ChildProjectileClass=Class'DEKRPG208.DEKHellfireSentinelProjChild'
     SpreadFactor=400.000000
     Speed=1200.000000
     TossZ=225.000000
     MomentumTransfer=75000.000000
     MyDamageType=Class'DEKRPG208.DamTypeHellfireSentinel'
     ExplosionDecal=Class'XEffects.RocketMark'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'ONS-BPJW1.Meshes.Mini_Shell'
     CullDistance=4000.000000
     Physics=PHYS_Falling
     AmbientSound=Sound'WeaponSounds.BaseProjectileSounds.BFlakCannonProjectile'
     DrawScale=0.100000
     AmbientGlow=100
     bProjTarget=True
     ForceType=FT_Constant
     ForceRadius=60.000000
     ForceScale=5.000000
}
