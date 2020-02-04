class ArtifactKillAllPets extends RPGArtifact;

function Activate()
{
	local MonsterPointsInv Inv;

	Inv = MonsterPointsInv(Instigator.FindInventoryType(class'MonsterPointsInv'));
	if(Inv != None)
		inv.KillAllMonsters();

	bActive = false;
	GotoState('');
	return;
}

exec function TossArtifact()
{
	//do nothing. This artifact cant be thrown
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');
}

function DropFrom(vector StartLocation)
{
	if (bActive)
		GotoState('');
	bActive = false;

	Destroy();
	Instigator.NextItem();
}

function BotConsider()
{
	return;		// bots do not kill things they have summoned
}

defaultproperties
{
     MinActivationTime=0.000000
     IconMaterial=Texture'DEKRPGTexturesMaster207P.Artifacts.KillSummoningCharmIcon'
     ItemName="Kill All Summoned Monsters"
}
