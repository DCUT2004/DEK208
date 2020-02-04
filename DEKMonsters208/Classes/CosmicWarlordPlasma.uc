class CosmicWarlordPlasma extends PROJ_LinkTurret_Plasma;

var FX_DEK_Plasma	Plasma;

simulated function Destroyed()
{
    if ( Plasma != None )
        Plasma.Destroy();

	super.Destroyed();
}

simulated function PostBeginPlay()
{
	local vector dir;

	if ( Level.NetMode != NM_DedicatedServer )
		Plasma = Spawn(class'FX_DEK_Plasma', Self,, Location - 50*Dir, Rotation);

	if ( Plasma != None )
		Plasma.SetBase( Self );

	Velocity		 = Speed * Vector(Rotation);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local FX_DEKPlasmaImpact	FX_Impact;

	// Give a little splash
	if ( Role == Role_Authority )
		HurtRadius(Damage * 0.5 * (1.0 + float(Links)),DamageRadius, MyDamageType, MomentumTransfer * (1.0 + float(Links)*0.15) ,HitLocation);

    if ( EffectIsRelevant(Location, false) )
	{
        if ( Links == 0 )
		{
            FX_Impact = Spawn(class'FX_DEKPlasmaImpact',,, HitLocation + HitNormal * 2, rotator(HitNormal));
			FX_Impact.SetGreenColor();
		}
        else
		{
            FX_Impact = Spawn(class'FX_DEKPlasmaImpact',,, HitLocation + HitNormal * 2, rotator(HitNormal));
			FX_Impact.SetYellowColor();
		}
		Spawn(class'ShockComboFlash',,, HitLocation, rotator(HitNormal));
	}

		PlaySound(Sound'WeaponSounds.ShockRifle.ShockComboFire',,5.0);
	Destroy();
}

/* HurtRadius()
 Hurt locally authoritative actors within the radius.
*/

defaultproperties
{
     Speed=2500.000000
     MaxSpeed=2500.000000
     Damage=55.000000
     DamageRadius=250.000000
     MyDamageType=Class'DEKMonsters208.DamTypeCosmicWarlord'
     LightHue=210
     LightSaturation=75
}
