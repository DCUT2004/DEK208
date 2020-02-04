class PlasmaGrenadeAltFire extends WeaponFire;

var PlasmaGrenadeLauncher Gun;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	Gun = PlasmaGrenadeLauncher(Weapon);
}

simulated function bool AllowFire()
{
	return (Gun.CurrentGrenades > 0);
}

function DoFireEffect()
{
	local int x;

	for (x = 0; x < Gun.Grenades.Length; x++)
		if (Gun.Grenades[x] != None)
                  Gun.Grenades[x].Explode(Gun.Grenades[x].Location, vect(0,0,1));
				  
	Gun.Grenades.length = 0;
	Gun.CurrentGrenades = 0;
}

defaultproperties
{
     FireSound=Sound'WeaponSounds.TAGRifle.TAGTargetAquired'
     FireRate=1.000000
     BotRefireRate=0.000000
}
