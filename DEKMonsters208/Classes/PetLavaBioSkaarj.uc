class PetLavaBioSkaarj extends LavaBioSkaarj;

function PostBeginPlay()
{
	super(LavaBioSkaarj).PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'LavaBioSkaarjGlob';
}

defaultproperties
{
}
