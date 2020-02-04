//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MTRearGun extends ONSWeapon;

#exec OBJ LOAD FILE=..\Animations\ONSWeapons-A.ukx

var class<Projectile> TeamProjectileClasses[2];
var float MinAim;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.SmokePanels1');
    L.AddPrecacheMaterial(Material'XEffects.Skins.TransTrailT');
    L.AddPrecacheMaterial(Material'EpicParticles.Flares.FlashFlare1');
    L.AddPrecacheMaterial(Material'EmitterTextures.MultiFrame.rockchunks02');
    L.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.PlasmaFlare');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.SmokePanels1');
    Level.AddPrecacheMaterial(Material'XEffects.Skins.TransTrailT');
    Level.AddPrecacheMaterial(Material'EpicParticles.Flares.FlashFlare1');
    Level.AddPrecacheMaterial(Material'EmitterTextures.MultiFrame.rockchunks02');
    Level.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.PlasmaFlare');

    Super.UpdatePrecacheMaterials();
}

state ProjectileFireMode
{
	function Fire(Controller C)
	{
		if (Vehicle(Owner) != None && Vehicle(Owner).Team < 2)
			ProjectileClass = TeamProjectileClasses[Vehicle(Owner).Team];
		else
			ProjectileClass = TeamProjectileClasses[0];

		Super.Fire(C);
	}

	function AltFire(Controller C)
	{
		local MTIIMissle M;
		local Vehicle V, Best;
		local float CurAim, BestAim;

		M = MTIIMissle(SpawnProjectile(AltFireProjectileClass, True));
		if (M != None)
		{
			if (AIController(Instigator.Controller) != None)
			{
				V = Vehicle(Instigator.Controller.Enemy);
				if (V != None && (V.bCanFly || V.IsA('ONSHoverCraft')) && Instigator.FastTrace(V.Location, Instigator.Location))
					M.SetHomingTarget(V);
			}
			else
			{
				BestAim = MinAim;
				for (V = Level.Game.VehicleList; V != None; V = V.NextVehicle)
					if ((V.bCanFly || V.IsA('ONSHoverCraft')) && V != Instigator && Instigator.GetTeamNum() != V.GetTeamNum())
					{
						CurAim = Normal(V.Location - WeaponFireLocation) dot vector(WeaponFireRotation);
						if (CurAim > BestAim && Instigator.FastTrace(V.Location, Instigator.Location))
						{
							Best = V;
							BestAim = CurAim;
						}
					}
				if (Best != None)
					M.SetHomingTarget(Best);
			}
		}
	}
}

defaultproperties
{
     TeamProjectileClasses(0)=Class'DEKRPG208.MTRedProjectile'
     TeamProjectileClasses(1)=Class'DEKRPG208.MTGunProjectile'
     MinAim=0.900000
     YawBone="REARgunBASE"
     PitchBone="REARgunTURRET"
     PitchUpLimit=20000
     PitchDownLimit=59000
     WeaponFireAttachmentBone="Dummy02"
     GunnerAttachmentBone="REARgunBASE"
     DualFireOffset=10.000000
     RotationsPerSecond=1.200000
     bInstantRotation=True
     Spread=0.012500
     RedSkin=Texture'MTII.MTTurretRed'
     BlueSkin=Texture'MTII.MTTurretBlue'
     FireInterval=0.112500
     AltFireInterval=2.900000
     FireSoundClass=Sound'MTII.Static_AA_fire_3p'
     AltFireSoundClass=Sound'MTII.Rocket_Pod_Fire'
     AltFireSoundVolume=255.000000
     FireForce="Laser01"
     AltFireForce="Laser01"
     ProjectileClass=Class'DEKRPG208.MTRedProjectile'
     AltFireProjectileClass=Class'DEKRPG208.MTMissle'
     AIInfo(0)=(bLeadTarget=True,RefireRate=0.550000)
     AIInfo(1)=(bLeadTarget=True,aimerror=400.000000,RefireRate=0.500000)
     bUseDynamicLights=True
     Mesh=SkeletalMesh'ONSWeapons-A.PRVrearGUN'
     DrawScale=0.700000
     AmbientGlow=2
     bShadowCast=True
}
