class FireSlugBioGlobC extends BioGlob;

var vector Dir;
var float HeatLifeSpan;
var config float BaseChance;

function AdjustSpeed()
{
	Velocity = Vector(Rotation) * Speed * 2;
	Velocity.Z += TossZ * 2;
}

auto state Flying
{
    simulated function Landed( Vector HitNormal )
    {
        Explode(Location,HitNormal);
    }

    simulated function HitWall( Vector HitNormal, Actor Wall )
    {
        Landed(HitNormal);
    }
}

function NullInBlast(float Radius)
{
	local float damageScale, pawndist;
	local vector pawndir;
	local Controller C, NextC;
	Local SuperHeatInv Inv;

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
		if ( C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.SameTeamAs(InstigatorController) && !C.Pawn.IsA('FireBrute') && !C.Pawn.IsA('FireChildGasbag') && !C.Pawn.IsA('FireChildSkaarjPupae') && !C.Pawn.IsA('FireGasbag') && !C.Pawn.IsA('FireGiantGasbag') && !C.Pawn.IsA('FireKrall') && !C.Pawn.IsA('FireLord') && !C.Pawn.IsA('FireManta') && !C.Pawn.IsA('FireMercenary') && !C.Pawn.IsA('FireNali') && !C.Pawn.IsA('FireNaliFighter') && !C.Pawn.IsA('FireQueen') && !C.Pawn.IsA('FireRazorfly') && !C.Pawn.IsA('FireSkaarjPupae') && !C.Pawn.IsA('FireSkaarjSniper') && !C.Pawn.IsA('FireSkaarjTrooper') && !C.Pawn.IsA('FireSkaarjSuperHeat') && !C.Pawn.IsA('FireSlith') && !C.Pawn.IsA('FireSlug') && !C.Pawn.IsA('FireTitan')
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

function BlowUp(vector HitLocation)
{
	Super.BlowUp(HitLocation);
	// ok, lets null them according to how close to the centre they are
	NullInBlast(DamageRadius);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
    local rotator rot;
    local int i;
    local FireSlugMiniBioGlob Glob;

	start = Location - 60 * Dir;

    if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
		for (i=0; i<8; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			Glob = Spawn( class 'FireSlugMiniBioGlob',, '', Start, rot);
		}
	}
    Destroy();
}

simulated function Destroyed()
{
    if ( !bNoFX && EffectIsRelevant(Location,false) )
    {
        Spawn(class'RedGoopSparks');
    }
	if ( Fear != None )
		Fear.Destroy();
    if (Trail != None)
        Trail.Destroy();
    Super(Projectile).Destroyed();
}

defaultproperties
{
     HeatLifespan=4.000000
     BaseChance=25.000000
     Speed=1000.000000
     TossZ=1.000000
     MyDamageType=Class'DEKMonsters208.DamTypeFireSlug'
     LightHue=30
     LightSaturation=15
     DrawScale=4.000000
     Skins(0)=Texture'DEKMonstersTexturesMaster206E.FireMonsters.FireGib'
     CollisionRadius=8.000000
     CollisionHeight=8.000000
}
