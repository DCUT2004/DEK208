class LavaBioSkaarjGlob extends BioGlob;

simulated function Destroyed()
{
    if ( !bNoFX && EffectIsRelevant(Location,false) )
    {
        Spawn(class'RedGoopSmoke');
        Spawn(class'RedGoopSparks');
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
	spawn(class'RedBioDecal',,,, rotator(-HitNormal));

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
        local LavaBioSkaarjGlob Glob;

        Glob = LavaBioSkaarjGlob(Other);

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
    local LavaBioSkaarjGlob NewGlob;
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

defaultproperties
{
     BaseDamage=20
     GoopLevel=3
     TossZ=300.000000
     Damage=30.000000
     MyDamageType=Class'DEKMonsters208.DamTypeLavaBioSkaarjGlob'
     LightHue=30
     LightSaturation=15
     DrawScale=1.500000
     Skins(0)=Texture'DEKMonstersTexturesMaster206E.FireMonsters.FireGib'
}
