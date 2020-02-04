class DEKGoldSlugBioGlobB extends PoisonSlugBioGlobB;

function NullInBlast(float Radius)
{
//
}

function BlowUp(vector HitLocation)
{
	Super.BlowUp(HitLocation);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start, bstart;
    local rotator rot;
    local int i, x;
    local PoisonSlugMiniBioGlob Glob;
    local PoisonSlugBioGlobC GlobC;

	start = Location - 40 * Dir;
	bstart = Location - 60 * Dir;

	if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);

        for (i=0; i<6; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			Glob = Spawn( class 'DEKGoldSlugMiniBioGlob',, '', Start, rot);
		}
        //This give the illusion that the big glob is bouncing
		for (x=0; x<1; x++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			GlobC = Spawn( class 'DEKGoldSlugBioGlobC',, '', bStart, rot);
		}
	}
    Destroy();
}

simulated function Destroyed()
{
    if ( !bNoFX && EffectIsRelevant(Location,false) )
    {
        Spawn(class'YellowGoopSmoke');
    }
	if ( Fear != None )
		Fear.Destroy();
    if (Trail != None)
        Trail.Destroy();
    Super(Projectile).Destroyed();
}

defaultproperties
{
     MyDamageType=Class'DEKMonsters208.DamTypeGoldSlug'
     LightHue=45
     Skins(0)=Texture'DEKMonstersTexturesMaster206E.GoldMonsters.FunkyYellow'
}
