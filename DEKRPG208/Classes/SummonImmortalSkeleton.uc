class SummonImmortalSkeleton extends SummonMortalSkeleton;

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	return;
}

defaultproperties
{
	 Lifespan=180.00
     ClawDamage=35
     Skins(0)=Shader'DEKMonstersTexturesMaster206E.NecroMonsters.SkeletonShader'
     Skins(1)=Shader'DEKMonstersTexturesMaster206E.NecroMonsters.SkeletonShader'
}
