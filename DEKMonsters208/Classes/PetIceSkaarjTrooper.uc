class PetIceSkaarjTrooper extends IceSkaarjTrooper;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'IceSkaarjTrooperProjectile';
}

defaultproperties
{
}
