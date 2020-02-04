class CosmicNaliPlasma extends ONSHoverBikePlasmaProjectile;

simulated function Explode(vector HitLocation, vector HitNormal)
{
   if ( Role == ROLE_Authority )
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

    if ( EffectIsRelevant(Location,false) )
		Spawn(class'ShockComboFlash',,, HitLocation, rotator(HitNormal));
    PlaySound(Sound'WeaponSounds.ShockRifle.ShockComboFire');
	Destroy();
}

defaultproperties
{
     Speed=3000.000000
     MaxSpeed=25000.000000
     Damage=40.000000
     DamageRadius=200.000000
     MyDamageType=Class'DEKMonsters208.DamTypeCosmicNali'
}
