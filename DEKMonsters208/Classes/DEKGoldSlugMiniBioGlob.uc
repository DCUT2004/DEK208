class DEKGoldSlugMiniBioGlob extends PoisonSlugMiniBioGlob;

function NullInBlast(float Radius)
{
//
}

function BlowUp(vector HitLocation)
{
	Super.BlowUp(HitLocation);
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
