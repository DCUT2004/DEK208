class PriestMagnet extends UpgradeShockRifleBlackHole;

simulated function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
	local Actor Victims;
	local float damageScale, momentumScale, dist;
	local vector dir;
	local bool VictimPawn;

	if (bHurtEntry)
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors(class'Actor', Victims, 2 * DamageRadius, HitLocation)
	{
		if (Victims != self && Hurtwall != Victims && (Victims.Role == ROLE_Authority || Victims.bNetTemporary) && !Victims.IsA('FluidSurfaceInfo'))
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1, VSize(dir));
			dir = dir / dist;
			damageScale   = 1 - FClamp((dist - Victims.CollisionRadius) /      DamageRadius,  0, 1);
			momentumScale = 1 - FClamp((dist - Victims.CollisionRadius) / (2 * DamageRadius), 0, 1);

			if (Instigator == None || Instigator.Controller == None)
				Victims.SetDelayedDamageInstigatorController(InstigatorController);
			if (Victims == LastTouched)
				LastTouched = None;
				
			VictimPawn = false;
			if (Pawn(Victims) != None)
			{
				VictimPawn = true;
			}

			Victims.TakeDamage(FMax(0.001, damageScale * DamageAmount), Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir, momentumScale * Momentum * dir, DamageType);
			if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
			if (VictimPawn)
			{
				if (Victims == None || Pawn(Victims) == None || Pawn(Victims).Health <= 0 )
					class'ArtifactLightningBeam'.static.AddArtifactKill(Instigator, class'WeaponMagnet');	// assume killed
			}
		}
	}
	if (LastTouched != None && LastTouched != self && LastTouched.Role == ROLE_Authority && !LastTouched.IsA('FluidSurfaceInfo'))
	{
		Victims = LastTouched;
		LastTouched = None;
		dir = Victims.Location - HitLocation;
		dist = FMax(1, VSize(dir));
		dir = dir / dist;
		damageScale   = FMax(Victims.CollisionRadius / (Victims.CollisionRadius + Victims.CollisionHeight), 1 - FMax(0, (dist - Victims.CollisionRadius) /      DamageRadius ));
		momentumScale = FMax(Victims.CollisionRadius / (Victims.CollisionRadius + Victims.CollisionHeight), 1 - FMax(0, (dist - Victims.CollisionRadius) / (2 * DamageRadius)));

		if (Instigator == None || Instigator.Controller == None)
			Victims.SetDelayedDamageInstigatorController(InstigatorController);
		Victims.TakeDamage(damageScale * DamageAmount, Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir, momentumScale * Momentum * dir, DamageType);
		if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
			Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
	}

	bHurtEntry = false;
}

defaultproperties
{
	 Speed=600.00
	 MaxSpeed=600.000000
     AttractionRadius=800.000000
     AttractionStrength=200000.000000
     LightningDamageType=Class'DEKRPG208.DamTypeMagnet'
     DetonationTime=2.000000
     Damage=200.000000
     MyDamageType=Class'DEKRPG208.DamTypeMagnet'
}
