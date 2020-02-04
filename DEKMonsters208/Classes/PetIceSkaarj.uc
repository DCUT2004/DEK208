class PetIceSkaarj extends DCIceSkaarj;

var RPGRules RPGRules;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;
}

defaultproperties
{
}
