class PetIceQueen extends IceQueen;

function PostBeginPlay()
{
	super(SMPQueen).PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
}

function SpawnChildren()
{
	return;
}

defaultproperties
{
}
