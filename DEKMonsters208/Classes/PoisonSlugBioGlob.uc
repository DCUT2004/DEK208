class PoisonSlugBioGlob extends BioGlob;

var vector Dir;
var float PoisonLifeSpan;
var config float BaseChance;

function AdjustSpeed()
{
	Velocity = Vector(Rotation) * Speed * 4;
	Velocity.Z += TossZ * 4;
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
/*
function AdjustSpeed()
{
	if ( GoopLevel < 1 )
		Velocity = Vector(Rotation) * Speed * 0.5;
	else
		Velocity = Vector(Rotation) * Speed * 0.25;
	Velocity.Z += TossZ;
} */

function NullInBlast(float Radius)
{
	local float damageScale, pawndist;
	local vector pawndir;
	local Controller C, NextC;
	Local DruidPoisonInv Inv;

	// freezes anything not a null warlord. Any side.
	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;
		if ( C != None && C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.Pawn.IsA('PoisonSlug')
		     && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) && MagicShieldInv(C.Pawn.FindInventoryType(class'MagicShieldInv')) == None )
		{
			pawndir = C.Pawn.Location - Location;
			pawndist = FMax(1,VSize(pawndir));
			damageScale = 1 - FMax(0,pawndist/Radius);

			if(!C.Pawn.isA('Vehicle') && class'RW_Freeze'.static.canTriggerPhysics(C.Pawn) 
				&& (C.Pawn.FindInventoryType(class'DruidPoisonInv') == None))
				
				if(rand(99) < int(BaseChance))
			{
				Inv = spawn(class'DruidPoisonInv', C.Pawn,,, rot(0,0,0));
				if(Inv != None)
				{
					Inv.LifeSpan = (damageScale * PoisonLifeSpan);	
					Inv.Modifier = (damageScale * PoisonLifeSpan);	// *3 because the NullEntropyInv divides by 3
					Inv.GiveTo(C.Pawn);
				}
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
	local vector start, bstart;
    local rotator rot;
    local int i;
    local PoisonSlugMiniBioGlob Glob;

	start = Location - 40 * Dir;
	bstart = Location + 80 * Dir;

	if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);

        for (i=0; i<6; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			Glob = Spawn( class 'PoisonSlugMiniBioGlob',, '', Start, rot);
		}
        //This give the illusion that the big glob is bouncing
		//for (x=0; x<1; x++)
		//{
		//	rot = Rotation;
		//	//rot.yaw += FRand()*32000-16000;
		//	rot.pitch += FRand()*32000-16000;
		//	//rot.roll += FRand()*32000-16000;
		//	GlobB = Spawn( class 'PoisonSlugBioGlobB',, '', bStart, rot);
		//}
	}
    Destroy();
}

defaultproperties
{
     LightBrightness=80.000000
     PoisonLifespan=4.000000
     BaseChance=33.000000
     TossZ=1.000000
     MyDamageType=Class'DEKMonsters208.DamTypePoisonSlug'
     DrawScale=5.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
