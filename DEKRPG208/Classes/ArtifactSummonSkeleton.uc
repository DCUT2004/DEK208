class ArtifactSummonSkeleton extends RPGArtifact
	config(UT2004RPG);

var MutUT2004RPG RPGMut;

function BotConsider()
{
	if (bActive)
		return;

	if ( Instigator.Health + Instigator.ShieldStrength < 100 && Instigator.Controller.Enemy != None
	     && Instigator.Controller.Adrenaline > (40+rand(60)) && NoArtifactsActive())
		Activate();
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Level.Game != None)
		RPGMut = class'MutUT2004RPG'.static.GetRPGMutator(Level.Game);
	if (RPGMut != None)
		RPGMut.FillMonsterList();
	disable('Tick'); //this artifact doesn't need ticks. It activates imediately
}

function Activate()
{		
	local Inventory Inv;
	local LoadedInv LI;
	local MonsterPointsInv MInv;
	Local Monster M;

	MInv = MonsterPointsInv(Instigator.FindInventoryType(class'MonsterPointsInv'));
	if(MInv == None)
	{
		MInv = Instigator.spawn(class'MonsterPointsInv', Instigator,,, rot(0,0,0));
		if(MInv == None)
		{
			bActive = false;
			GotoState('');
			return; //get em next pass I guess?
		}

		MInv.giveTo(Instigator);
	}
	
	// ok, now we need to check if this bod has extreme monsters?
	for (Inv = Instigator.Controller.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		LI = LoadedInv(Inv);
		if (LI != None)
			break;
	}
	if (LI == None) //fallback, should never happen
		LI = LoadedInv(Instigator.FindInventoryType(class'LoadedInv'));
	if (LI != None && !LI.bGotLoadedMonsters)
		MInv.MaxMonsters=1;
	
	M = MInv.SummonMonster(class'DEKRPG208.SummonImmortalSkeleton', 20, 0);
	
	GotoState('');
	bActive = false;
}

defaultproperties
{
     CostPerSec=1
     MinActivationTime=0.000001
     IconMaterial=Texture'UTRPGTextures.Icons.SummoningCharmIcon'
     ItemName="Skeleton Summon"
     PickupClass=Class'DEKRPG208.ArtifactSummonSkeletonPickup'
}
