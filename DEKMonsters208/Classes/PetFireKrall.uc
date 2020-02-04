class PetFireKrall extends FireKrall;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'FireKrallBolt';
}

defaultproperties
{
}
