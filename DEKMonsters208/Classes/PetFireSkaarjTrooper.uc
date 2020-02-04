class PetFireSkaarjTrooper extends FireSkaarjTrooper;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'FireSkaarjTrooperProjectile';
}

defaultproperties
{
}
