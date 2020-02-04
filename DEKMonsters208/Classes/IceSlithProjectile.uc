class IceSlithProjectile extends SMPSlithProj;

var float IceLifeSpan;
var config float BaseChance;
var Sound FreezeSound;

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
        local IceSlithProjectile Glob;

        Glob = IceSlithProjectile(Other);

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
	Local FreezeInv Inv;
	Local Actor A;

	// freezes anything not a null warlord. Any side.
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
		if ( C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.SameTeamAs(InstigatorController) && !C.Pawn.IsA('IceBrute') && !C.Pawn.IsA('IceChildGasbag') && !C.Pawn.IsA('IceChildSkaarjPupae') && !C.Pawn.IsA('IceGasbag') && !C.Pawn.IsA('IceGiantGasbag') && !C.Pawn.IsA('IceKrall') && !C.Pawn.IsA('Manta') && !C.Pawn.IsA('IceMercenary') && !C.Pawn.IsA('IceNali') && !C.Pawn.IsA('IceNaliFighter') && !C.Pawn.IsA('IceQueen') && !C.Pawn.IsA('IceRazorfly') && !C.Pawn.IsA('IceSkaarjFreezing') && !C.Pawn.IsA('IceSkaarjPupae') && !C.Pawn.IsA('IceSkaarjSniper') && !C.Pawn.IsA('IceSkaarjTrooper') && !C.Pawn.IsA('IceSlith') && !C.Pawn.IsA('IceSlug') && !C.Pawn.IsA('IceTitan') && !C.Pawn.IsA('IceWarlord')
		     && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) && MagicShieldInv(C.Pawn.FindInventoryType(class'MagicShieldInv')) == None )
		{
			pawndir = C.Pawn.Location - Location;
			pawndist = FMax(1,VSize(pawndir));
			damageScale = 1 - FMax(0,pawndist/Radius);

			if(!C.Pawn.isA('Vehicle') && class'RW_Freeze'.static.canTriggerPhysics(C.Pawn) && (C.Pawn.FindInventoryType(class'FreezeInv') == None))
			{
				if(C.Pawn == None)
				{
					C = NextC;
					break;
				}
				if(rand(99) < int(BaseChance))
				{
					Inv = spawn(class'FreezeInv', C.Pawn,,, rot(0,0,0));
					if(Inv != None)
					{
						Inv.LifeSpan = (damageScale * IceLifeSpan);	
						Inv.Modifier = (damageScale * IceLifeSpan);	// *3 because the NullEntropyInv divides by 3
						Inv.GiveTo(C.Pawn);
						A = C.Pawn.spawn(class'IceKrallSmoke', C.Pawn,, C.Pawn.Location, C.Pawn.Rotation);  // cant use IceSmoke as it assumes a PlayerController exists
						if(C.Pawn == None)
						{
							C = NextC;
							break;
						}
						if (A != None)
						{
							A.RemoteRole = ROLE_SimulatedProxy;
							A.PlaySound(FreezeSound,,2.5*A.TransientSoundVolume,,A.TransientSoundRadius);
						}
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

function BlowUp(vector HitLocation)
{
	Super.BlowUp(HitLocation);
	// ok, lets null them according to how close to the centre they are
	NullInBlast(DamageRadius);
}

simulated function Destroyed()
{
    if ( !bNoFX && EffectIsRelevant(Location,false) )
    {
        Spawn(class'BlueGoopSmoke');
        Spawn(class'BlueGoopSparks');
    }
	if ( Fear != None )
		Fear.Destroy();
    if (Trail != None)
        Trail.Destroy();
    Super(Projectile).Destroyed();
}

defaultproperties
{
     IceLifespan=3.000000
     BaseChance=25.000000
     FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
     MyDamageType=Class'DEKMonsters208.DamTypeIceSlith'
     LightHue=120
     LightSaturation=135
     Skins(0)=Texture'DEKMonstersTexturesMaster206E.IceMonsters.IceGib'
}
