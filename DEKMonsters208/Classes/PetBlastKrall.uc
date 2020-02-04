class PetBlastKrall extends BlastKrall;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	bSuperAggressive = (FRand() < 0.2);
	Instigator = self;
	CheckController();
	SummonedMonster = True;
}

defaultproperties
{
}
