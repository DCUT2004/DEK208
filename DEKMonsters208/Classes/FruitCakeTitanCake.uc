class FruitCakeTitanCake extends TitanBigRock;

simulated function PostBeginPlay()
{
//
}

function ProcessTouch (Actor Other, Vector HitLocation)
{
	local int hitdamage;

	if (Other==none || Other == instigator )
		return;
	PlaySound(ImpactSound, SLOT_Interact, DrawScale/10);
	if(Projectile(Other)!=none)
		Other.Destroy();
	else if ( !Other.IsA('FruitCakeTitanBigBigRock'))
	{
		Hitdamage = Damage * 0.00002 * (DrawScale**3) * speed;
		if ( (HitDamage > 3) && (speed > 150) && ( Role == ROLE_Authority ))
			Other.TakeDamage(hitdamage, instigator,HitLocation,
				(35000.0 * Normal(Velocity)*DrawScale), MyDamageType );
	}
}

function SpawnChunks(int num)
{
//
}

defaultproperties
{
     Damage=100.500000
     MyDamageType=Class'DEKMonsters208.DamTypeFruitCakeTitanRock'
     StaticMesh=StaticMesh'DEKStaticsMaster207P.ChristmasMeshes.FruitCake'
     DrawScale=3.500000
     Skins(0)=Texture'DEKMonstersTexturesMaster206E.ChristmasMonsters.FruitCake'
     Skins(1)=Texture'DEKMonstersTexturesMaster206E.ChristmasMonsters.FruitCake'
     bUseCylinderCollision=True
}
