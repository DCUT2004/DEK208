class UpgradeINAVRiLAltFire extends INAVRiLAltFire;

var UpgradeINAVRiL NewGun;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	NewGun = UpgradeINAVRiL(Weapon);
}

defaultproperties
{
}
