class FireSlithProjectile extends SMPSlithProj;

var float HeatLifeSpan;
var config float BaseChance;

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

        bCollideWorld = false;
        SetCollisionSize(GoopVolume*10.0, GoopVolume*10.0);
        bProjTarget = true;

		NewRot = Rotator(HitNormal);
		NewRot.Roll += 32768;
        SetRotation(NewRot);
        SetPhysics(PHYS_None);
        bCheckedsurface = false;
		if ( (Level.Game != None) && (Level.Game.NumBots > 0) )
			Fear = Spawn(class'AvoidMarker');
        GotoState('OnGround');
    }

    simulated function ProcessTouch(Actor Other, Vector HitLocation)
    {
        local FireSlithProjectile Glob;

        Glob = FireSlithProjectile(Other);

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

function NullInBlast(float Radius)
{
	local float damageScale, pawndist;
	local vector pawndir;
	local Controller C, NextC;
	Local SuperHeatInv Inv;

	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;
		if(C.Pawn == None)
		{
			C = NextC;
			break;
		}
		if ( C != None && C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.SameTeamAs(InstigatorController) && !C.Pawn.IsA('FireBrute') && !C.Pawn.IsA('FireChildGasbag') && !C.Pawn.IsA('FireChildSkaarjPupae') && !C.Pawn.IsA('FireGasbag') && !C.Pawn.IsA('FireGiantGasbag') && !C.Pawn.IsA('FireKrall') && !C.Pawn.IsA('FireLord') && !C.Pawn.IsA('FireManta') && !C.Pawn.IsA('FireMercenary') && !C.Pawn.IsA('FireNali') && !C.Pawn.IsA('FireNaliFighter') && !C.Pawn.IsA('FireQueen') && !C.Pawn.IsA('FireRazorfly') && !C.Pawn.IsA('FireSkaarjPupae') && !C.Pawn.IsA('FireSkaarjSniper') && !C.Pawn.IsA('FireSkaarjTrooper') && !C.Pawn.IsA('FireSkaarjSuperHeat') && !C.Pawn.IsA('FireSlith') && !C.Pawn.IsA('FireSlug') && !C.Pawn.IsA('FireTitan')  && !C.Pawn.IsA('FireTentacle')
		     && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) && MagicShieldInv(C.Pawn.FindInventoryType(class'MagicShieldInv')) == None )
		{
			pawndir = C.Pawn.Location - Location;
			pawndist = FMax(1,VSize(pawndir));
			damageScale = 1 - FMax(0,pawndist/Radius);

			if(!C.Pawn.isA('Vehicle') && class'RW_Freeze'.static.canTriggerPhysics(C.Pawn) && (C.Pawn.FindInventoryType(class'SuperHeatInv') == None))
			{
				if(C.Pawn == None)
				{
					C = NextC;
					break;
				}
				if(rand(99) < int(BaseChance))
				{
					Inv = spawn(class'SuperHeatInv', C.Pawn,,, rot(0,0,0));
					if(Inv != None)
					{
						Inv.LifeSpan = (damageScale * HeatLifeSpan);	
						Inv.Modifier = (damageScale * HeatLifeSpan);	// *3 because the NullEntropyInv divides by 3
						Inv.GiveTo(C.Pawn);
					}
				}
			}
			if(C.Pawn == None)
			{
				C = NextC;
				break;
			}
		}
		C = NextC;
	}
}

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

function BlowUp(vector HitLocation)
{
	Super.BlowUp(HitLocation);
	// ok, lets null them according to how close to the centre they are
	NullInBlast(DamageRadius);
}

defaultproperties
{
     HeatLifespan=4.000000
     BaseChance=25.000000
     MyDamageType=Class'DEKMonsters208.DamTypeFireSlith'
     LightHue=30
     LightSaturation=15
     Skins(0)=Texture'DEKMonstersTexturesMaster206E.FireMonsters.FireGib'
}
