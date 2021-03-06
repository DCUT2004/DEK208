class ArtifactKillAllBuildings extends RPGArtifact;

function Activate()
{
	local EngineerPointsInv Inv;

	Inv = class'AbilityLoadedEngineer'.static.GetEngInv(Instigator);
	if(Inv != None)
		Inv.KillAllBuildings();

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
     IconMaterial=Texture'DEKRPGTexturesMaster207P.Artifacts.KillSummonBlockIcon'
     ItemName="Kill All Summoned Buildings"
}
