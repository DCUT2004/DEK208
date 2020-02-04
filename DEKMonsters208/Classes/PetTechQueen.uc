class PetTechQueen extends TechQueen;

function PostBeginPlay()
{
	Super(SMPQueen).PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;
}

function SpawnChildren()
{
	return;
}

defaultproperties
{
}
