class CosmicSkaarjPlasma extends KrallBolt;

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
     TrailTex=Texture'XEffectMat.Link.link_muz_blue'
     Speed=3000.000000
     MaxSpeed=3000.000000
     Damage=36.000000
     DamageRadius=200.000000
     MyDamageType=Class'DEKMonsters208.DamTypeCosmicSkaarj'
     LifeSpan=3.000000
     DrawScale=1.500000
     Mass=2.000000
}
