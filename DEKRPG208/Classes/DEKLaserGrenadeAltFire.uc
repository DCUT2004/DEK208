class DEKLaserGrenadeAltFire extends WeaponFire;

var DEKLaserGrenadeLauncher EGun;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	EGun = DEKLaserGrenadeLauncher(Weapon);
}

simulated function bool AllowFire()
{
	return (EGun.CurrentMines > 0);
}

function DoFireEffect()
{
	local int x;

	for (x = 0; x < EGun.Mines.Length; x++)
		if (EGun.Mines[x] != None)
			EGun.Mines[x].Explode(EGun.Mines[x].Location, vect(0,0,1));

	EGun.Mines.length = 0;
	EGun.CurrentMines = 0;
}

defaultproperties
{
     FireRate=1.000000
     BotRefireRate=0.000000
}
