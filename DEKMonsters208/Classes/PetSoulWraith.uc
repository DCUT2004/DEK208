class PetSoulWraith extends NecroSoulWraith;

function PostBeginPlay()
{
	Super(NecroSoulWraith).PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;
}

defaultproperties
{
}
