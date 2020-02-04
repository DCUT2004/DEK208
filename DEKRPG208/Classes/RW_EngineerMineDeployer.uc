class RW_EngineerMineDeployer extends RW_EnhancedInfinity
	HideDropDown
	CacheExempt
	config(UT2004RPG);

simulated function bool CanThrow()
{
	return false;
}

function DropFrom(vector StartLocation)
{
	Destroy();
}

defaultproperties
{
     ModifierOverlay=Shader'DEKWeaponsMaster206.fX.ELinkShader'
     MinModifier=0
     MaxModifier=0
     bCanThrow=False
}
