class ArtifactMaxModifier extends DruidMaxModifier;

function Timer()
{
	if(needsIdentify && Weapon != None)
	{
		Weapon.Identify();
		needsIdentify=false;
	}
	setTimer(0, false);

	Destroy();
	Instigator.NextItem();
}

defaultproperties
{
     AdrenalineRequired=0
     ItemName="One Use Max Modifier"
}
