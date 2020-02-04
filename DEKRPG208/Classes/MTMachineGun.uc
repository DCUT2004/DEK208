//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MTMachineGun extends ONSWeapon;

var class<Projectile> TeamProjectileClasses[2];
var float MinAim;
var		float	StartHoldTime, MaxHoldTime, ShockMomentum, ShockRadius;
var		bool	bHoldingFire, bFireMode;
var	sound	ChargingSound, ShockSound;

state ProjectileFireMode
{
	function Fire(Controller C)
	{
		if (Vehicle(Owner) != None && Vehicle(Owner).Team < 2)
			ProjectileClass = TeamProjectileClasses[Vehicle(Owner).Team];
		else
			ProjectileClass = TeamProjectileClasses[0];

		Super.Fire(C);
	}


       function AltFire(Controller C)
	{
		local actor		Shock;
		local float		DistScale, dist;
		local vector	dir, StartLocation;
		local Pawn		Victims;

		NetUpdateTime = Level.TimeSeconds - 3;
		bFireMode = true;
		//log("AltFire");
		StartLocation = Instigator.Location;

		PlaySound(ShockSound, SLOT_None, 255/255.0,,, 2.5, False);

		Shock = Spawn(class'FX_IonPlasmaTank_ShockWave', Self,, StartLocation);
		Shock.SetBase( Instigator );

		foreach VisibleCollidingActors( class'Pawn', Victims, ShockRadius, StartLocation )
		{
			//log("found:" @ Victims.GetHumanReadableName() );
			// don't let Shock affect fluid - VisibleCollisingActors doesn't really work for them - jag
			if( (Victims != Instigator) && (Victims.Controller != None)
				&& (Victims.Controller.GetTeamNum() != Instigator.GetTeamNum())
				&& (Victims.Role == ROLE_Authority) )
			{

				dir = Victims.Location - StartLocation;
				dir.Z = 0;
				dist = FMax(1,VSize(dir));
				dir = Normal(Dir)*0.5 + vect(0,0,0);
				DistScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/ShockRadius);
				Victims.AddVelocity( DistScale * ShockMomentum * dir );
				//Victims.Velocity = (DistScale * ShockMomentum * dir);
				//Victims.TakeDamage(0, Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				//(DistScale * ShockMomentum * dir), None	);
				//log("Victims:" @ Victims.GetHumanReadableName() @ "DistScale:" @ DistScale );
			}
		}
	}
 }

defaultproperties
{
     TeamProjectileClasses(0)=Class'DEKRPG208.MTRedProjectile'
     TeamProjectileClasses(1)=Class'DEKRPG208.MTGunProjectile'
     ShockMomentum=-9500.000000
     ShockRadius=2000.000000
     ShockSound=Sound'MTII.SuperSuck'
     YawBone="PlasmaGunBarrel"
     YawStartConstraint=57344.000000
     YawEndConstraint=8192.000000
     PitchBone="PlasmaGunBarrel"
     WeaponFireAttachmentBone="PlasmaGunBarrel"
     WeaponFireOffset=25.000000
     DualFireOffset=25.000000
     RotationsPerSecond=0.800000
     FireInterval=0.125000
     AltFireInterval=4.500000
     FireSoundClass=Sound'MTII.Static_AA_fire_3p'
     AltFireSoundClass=Sound'MTII.SuperSuck'
     AltFireSoundVolume=85.000000
     FireForce="Laser01"
     AltFireForce="Laser01"
     ProjectileClass=Class'DEKRPG208.MTGunProjectile'
     Mesh=SkeletalMesh'ONSWeapons-A.PlasmaGun'
}
