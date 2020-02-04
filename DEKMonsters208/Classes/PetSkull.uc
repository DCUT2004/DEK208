class PetSkull extends NecroSkull;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;
	PlayAnim('Chase');
}

defaultproperties
{
}
