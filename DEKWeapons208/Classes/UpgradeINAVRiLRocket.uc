class UpgradeINAVRiLRocket extends INAVRiLRocket;

simulated function Destroyed()
{
	// Turn of smoke emitters. Emitter should then destroy itself when all particles fade out.
	if ( SmokeTrail != None )  
		SmokeTrail.Kill();

	if ( Corona != None )
		Corona.Destroy();

	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
	if (!bNoFX && EffectIsRelevant(Location, false))
		spawn(class'UpgradeINAVRiLExplosion',,, Location, rotator(vect(0,0,1)));
	if (Instigator != None && Instigator.IsLocallyControlled() && Instigator.Weapon != None && !Instigator.Weapon.HasAmmo())
		Instigator.Weapon.DoAutoSwitch();
	//hack for crappy weapon firing sound
	if (INAVRiL(Owner) != None)
		INAVRiL(Owner).PlaySound(sound'WeaponSounds.BExplosion3', SLOT_Interact, 0.01,, TransientSoundRadius);

	Super.Destroyed();
}


function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
// do nothing. Upgraded AVRiL rocket can't get destroyed by both team or enemy.
}

defaultproperties
{
     DamageRadius=210.500000
}
