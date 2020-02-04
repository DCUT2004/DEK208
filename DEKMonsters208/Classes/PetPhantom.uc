class PetPhantom extends NecroPhantomPet;

function PostBeginPlay()
{
	Super(NecroPhantom).PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;
}

defaultproperties
{
}
