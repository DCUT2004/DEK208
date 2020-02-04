class CosmicKrallPlasma extends KrallBolt;

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
     Speed=2500.000000
     MaxSpeed=2500.000000
     Damage=18.000000
     DamageRadius=200.000000
     MyDamageType=Class'DEKMonsters208.DamTypeCosmicKrall'
     LightHue=200
     LifeSpan=3.000000
     DrawScale=2.000000
     Mass=2.000000
}
