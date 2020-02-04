class PetArcticBioSkaarj extends ArcticBioSkaarj;

function PostBeginPlay()
{
	Local GameRules G;
	super.PostBeginPlay();
	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			RPGRules = RPGRules(G);
			break;
		}
	}
	SummonedMonster = True;
	Instigator = self;
}

defaultproperties
{
}
