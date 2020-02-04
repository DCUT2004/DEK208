class PetFireSkaarjSuperHeat extends FireSkaarjSuperHeat;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'FireSkaarjSuperHeatProjectile';
}

defaultproperties
{
}
