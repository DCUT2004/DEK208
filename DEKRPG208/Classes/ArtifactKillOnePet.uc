class ArtifactKillOnePet extends RPGArtifact;

function Activate()
{
	local MonsterPointsInv Inv;

	Inv = MonsterPointsInv(Instigator.FindInventoryType(class'MonsterPointsInv'));
	if(Inv != None)
		inv.KillFirstMonster();

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

defaultproperties
{
     MinActivationTime=0.000000
     IconMaterial=Texture'DEKRPGTexturesMaster207P.Artifacts.KillSummoningCharmIcon'
     ItemName="Kill Oldest Summoned Monster"
}
