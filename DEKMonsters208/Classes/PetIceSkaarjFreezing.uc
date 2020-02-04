class PetIceSkaarjFreezing extends IceSkaarjFreezing;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'IceSkaarjFreezingProjectile';
}

defaultproperties
{
}
