class PetBehemoth extends DCBehemoth;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;

}

defaultproperties
{
}
