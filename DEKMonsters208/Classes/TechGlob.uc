class TechGlob extends BioGlob;

simulated function Destroyed()
{
    if ( !bNoFX && EffectIsRelevant(Location,false) )
    {
        Spawn(class'TechSmoke');
        Spawn(class'TechSparks');
    }
	if ( Fear != None )
		Fear.Destroy();
    if (Trail != None)
        Trail.Destroy();
    Super(Projectile).Destroyed();
}

auto state Flying
{
    simulated function Landed( Vector HitNormal )
    {
        local Rotator NewRot;
        local int CoreGoopLevel;

        if ( Level.NetMode != NM_DedicatedServer )
        {
            PlaySound(ImpactSound, SLOT_Misc);
            // explosion effects
        }

        SurfaceNormal = HitNormal;

        // spawn globlings
        CoreGoopLevel = Rand3 + MaxGoopLevel - 3;
        if (GoopLevel > CoreGoopLevel)
        {
            if (Role == ROLE_Authority)
                SplashGlobs(GoopLevel - CoreGoopLevel);
            SetGoopLevel(CoreGoopLevel);
        }
	spawn(class'xScorch',,,, rotator(-HitNormal));

        bCollideWorld = false;
        SetCollisionSize(GoopVolume*10.0, GoopVolume*10.0);
        bProjTarget = true;

	NewRot = Rotator(HitNormal);
	NewRot.Roll += 32768;
        SetRotation(NewRot);
        SetPhysics(PHYS_None);
        bCheckedsurface = false;
        Fear = Spawn(class'AvoidMarker');
        GotoState('OnGround');
    }

    simulated function ProcessTouch(Actor Other, Vector HitLocation)
    {
        local TechGlob Glob;

        Glob = TechGlob(Other);

        if ( Glob != None )
        {
            if (Glob.Owner == None || (Glob.Owner != Owner && Glob.Owner != self))
            {
                if (bMergeGlobs)
                {
                    Glob.MergeWithGlob(GoopLevel); // balancing on the brink of infinite recursion
                    bNoFX = true;
                    Destroy();
                }
                else
                {
                    BlowUp( HitLocation );
                }
            }
        }
        else if (Other != Instigator && (Other.IsA('Pawn') || Other.IsA('DestroyableObjective') || Other.bProjTarget))
            BlowUp( HitLocation );
		else if ( Other != Instigator && Other.bBlockActors )
			HitWall( Normal(HitLocation-Location), Other );
    }
}

singular function SplashGlobs(int NumGloblings)
{
    local int g;
    local TechGlob NewGlob;
    local Vector VNorm;

    for (g=0; g<NumGloblings; g++)
    {
        NewGlob = Spawn(Class, self,, Location+GoopVolume*(CollisionHeight+4.0)*SurfaceNormal);
        if (NewGlob != None)
        {
            NewGlob.Velocity = (GloblingSpeed + FRand()*150.0) * (SurfaceNormal + VRand()*0.8);
            if (Physics == PHYS_Falling)
            {
                VNorm = (Velocity dot SurfaceNormal) * SurfaceNormal;
                NewGlob.Velocity += (-VNorm + (Velocity - VNorm)) * 0.1;
            }
            NewGlob.InstigatorController = InstigatorController;
        }
        //else log("unable to spawn globling");
    }
}

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;
	local int TakePercent, DamageVictimAdjust;
	local int OldHealth, HealthTaken;

	if ( bHurtEntry )
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo') )
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			if ( Instigator == None || Instigator.Controller == None )
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
			if ( Victims == LastTouched )
				LastTouched = None;
				
            OldHealth = 0;
            DamageVictimAdjust = 1;
			if (Pawn(Victims) != None)
			{
			    OldHealth = Pawn(Victims).Health;
		        TakePercent = 0;
			    if (DruidBlock(Victims) != None && !Victims.IsA('TarydiumCrystal'))
			    {
		            DamageVictimAdjust = 5;
		            TakePercent = 25;
				}
				else if (vehicle(Victims) != None)
				{
		            DamageVictimAdjust = 4;
		            TakePercent = 10;
				}
			}

			Victims.TakeDamage
			(
				damageScale * DamageAmount * DamageVictimAdjust,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * Momentum * dir),
				DamageType
			);
			if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
			if (OldHealth > 0)
			{
			    // means this one was a pawn
			    if (Victims == None || Pawn(Victims).Health <= 0)
			        HealthTaken = OldHealth;
				else
				    HealthTaken = OldHealth - Pawn(Victims).Health;
				if (HealthTaken < 0)
				    HealthTaken = 0;
				// now take some health back
				if (HealthTaken > 0 && Instigator != None)
				{
					HealthTaken = max((HealthTaken * TakePercent)/100.0, 1);
					Instigator.GiveHealth(HealthTaken, Instigator.HealthMax);
				}
			}

		}
	}

	bHurtEntry = false;
}

//FinalBlend'DEKMonstersTexturesMaster206E.Monsters.TechProjFB'

defaultproperties
{
     BaseDamage=18
     GoopLevel=2
     TossZ=300.000000
     Damage=14.000000
     LightHue=30
     LightSaturation=250
     DrawScale=1.750000
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.TechMonsters.TechProjFB'
}
