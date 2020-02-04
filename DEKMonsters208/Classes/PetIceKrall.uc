class PetIceKrall extends IceKrall;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'IceKrallProj';
}

defaultproperties
{
}
