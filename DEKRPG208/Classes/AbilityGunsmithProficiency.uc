class AbilityGunsmithProficiency extends CostRPGAbility
	config(UT2004RPG) 
	abstract;
	
var config int RequiredKills;
var config int L1MaxMines,L2MaxMines,L3MaxMines,L4MaxMines,L5MaxMines,L6MaxMines,L7MaxMines,L8MaxMines,L9MaxMines,L10MaxMines;
var int ShieldKills, AVRiLKills, BioKills, ShockKills, LinkKills, MinigunKills, FlakKills, RocketKills, LightningKills, MineKills, GrenadeKills, IonKills, RedeemerKills;

static function ScoreKill(Controller Killer, Controller Killed, bool bOwnedByKiller, int AbilityLevel)
{
	local Weapon W;
	
	if (RPGWeapon(Killer.Pawn.Weapon) != None)
		W = RPGWeapon(Killer.Pawn.Weapon).ModifiedWeapon;
	else
		W = Killer.Pawn.Weapon;
		
	if (bOwnedByKiller && Killer != None && Killer.Pawn != None)
	{
		if (ShieldGun(W) != None)
			default.ShieldKills++;
		else if (INAVRiL(W) != None)
			default.AVRiLKills++;
		else if (BioRifle(W) != None)
			default.BioKills++;
		else if (ShockRifle(W) != None)
			default.ShockKills++;
		else if (LinkGun(W) != None || RPGLinkGun(W) != None)
			default.LinkKills++;
		else if (Minigun(W) != None)
			default.MinigunKills++;
		else if (FlakCannon(W) != None)
			default.FlakKills++;
		else if (RocketLauncher(W) != None)
			default.RocketKills++;
		else if (SniperRifle(W) != None)
			default.LightningKills++;
		else if (DEKMineLayer(W) != None)
			default.MineKills++;
		else if (ONSGrenadeLauncher(W) != None)
			default.GrenadeKills++;
		else if (Painter(W) != None)
			default.IonKills++;
		else if (Redeemer(W) != None)
			default.RedeemerKills++;
	}
}
	
static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local WeaponFire FireMode[2];
	local Weapon W;
	
	if (Weapon == None || Weapon.Owner == None || Pawn(Weapon.Owner) == None || Pawn(Weapon.Owner).PlayerReplicationInfo == None || PlayerController(Pawn(Weapon.Owner).Controller) == None)
		return;
		
	if (Weapon.Role != ROLE_Authority)
		return;
		
	if (RPGWeapon(Weapon) != None)
		W = RPGWeapon(Weapon).ModifiedWeapon;
	else
		W = Weapon;
		
	FireMode[0] = W.GetFireMode(0);
	FireMode[1] = W.GetFireMode(1);
	
	
	if (default.BioKills >= default.RequiredKills)
	{
		if (BioFire(FireMode[0]) != None && BioRifle(W) != None)
			BioFire(FireMode[0]).ProjectileClass=class'DEKWeapons208.UpgradeBioGlob';
		if (BioChargedFire(FireMode[1]) != None && BioRifle(W) != None)
		{
			BioChargedFire(FireMode[1]).MaxGoopLoad=15;
			BioChargedFire(FireMode[1]).ProjectileClass=class'DEKWeapons208.UpgradeBioGlob';
		}
	}
	if (default.FlakKills >= default.RequiredKills)
	{
		if (FlakFire(FireMode[0]) != None && FlakCannon(W) != None)
		{
			FlakFire(FireMode[0]).ProjPerFire=7;
			FlakFire(FireMode[0]).ProjectileClass=class'DEKWeapons208.UpgradeFlakChunk';
		}
		if (FlakAltFire(FireMode[1]) != None && FlakCannon(W) != None)
		{
			FlakAltFire(FireMode[1]).ProjectileClass=class'DEKWeapons208.UpgradeFlakShell';
		}
	}
	if (default.GrenadeKills >= default.RequiredKills)
	{
		if (ONSGrenadeFire(FireMode[0]) != None)
		{
			ONSGrenadeFire(FireMode[0]).ProjectileClass=class'DEKWeapons208.UpgradeGrenadeProjectile';
		}
	}
	if (default.AVRiLKills >= default.RequiredKills)
	{
		if (INAVRiLFire(FireMode[0]) != None)
		{
			INAVRiLFire(FireMode[0]).ProjectileClass=class'DEKWeapons208.UpgradeINAVRiLRocket';
		}
	}
	if (default.IonKills >= default.RequiredKills)
	{
		if (PainterFire(FireMode[0]) != None)
		{
			PainterFire(FireMode[0]).PaintDuration=0.3000000;
		}
		if (RPGPainterFire(FireMode[0]) != None)
		{
			RPGPainterFire(FireMode[0]).PaintDuration=0.3000000;
		}
	}
	if (default.LightningKills >= default.RequiredKills)
	{
		if (SniperFire(FireMode[0]) != None)
		{
			SniperFire(FireMode[0]).NumArcs=8;
			SniperFire(FireMode[0]).SecDamageMult=0.800000;
			SniperFire(FireMode[0]).SecTraceDist=2000.000000;
		}
	}
	if (default.LinkKills >= default.RequiredKills)
	{
		if (LinkAltFire(FireMode[0]) != None && RPGLinkGun(W) != None)
		{
			LinkAltFire(FireMode[0]).AmmoPerFire=1;
		}
		if (RPGLinkFire(FireMode[1]) != None && RPGLinkGun(W) != None)
		{
			RPGLinkFire(FireMode[1]).LinkBreakDelay=7.000;
		}
	}
	if (default.MineKills >= default.RequiredKills)
	{
		if (DEKMineLayer(W) != None)
		{
			if (AbilityLevel == 1)
				DEKMineLayer(W).MaxMines = default.L1MaxMines; //default is 3 for DC Server
			else if (AbilityLevel == 2)
				DEKMineLayer(W).MaxMines = default.L2MaxMines; //default is 3 for DC Server
			else if (AbilityLevel == 3)
				DEKMineLayer(W).MaxMines = default.L3MaxMines; //default is 3 for DC Server
			else if (AbilityLevel == 4)
				DEKMineLayer(W).MaxMines = default.L4MaxMines; //default is 3 for DC Server
			else if (AbilityLevel == 5)
				DEKMineLayer(W).MaxMines = default.L5MaxMines; //default is 3 for DC Server
			else if (AbilityLevel == 6)
				DEKMineLayer(W).MaxMines = default.L6MaxMines; //default is 3 for DC Server
			else if (AbilityLevel == 7)
				DEKMineLayer(W).MaxMines = default.L7MaxMines; //default is 3 for DC Server
			else if (AbilityLevel == 8)
				DEKMineLayer(W).MaxMines = default.L8MaxMines; //default is 3 for DC Server
			else if (AbilityLevel == 9)
				DEKMineLayer(W).MaxMines = default.L9MaxMines; //default is 3 for DC Server
			else if (AbilityLevel == 10)
				DEKMineLayer(W).MaxMines = default.L10MaxMines; //default is 3 for DC Server
		}
	}
	if (default.MinigunKills >= default.RequiredKills)
	{
		if (MinigunFire(FireMode[0]) != None && Minigun(W) != None)
		{
			MinigunFire(FireMode[0]).WindupTime=0.010000;
			MinigunFire(FireMode[0]).PrefireTime=0.010000;
			MinigunFire(FireMode[0]).ShakeRotTime=0.000000;
			MinigunFire(FireMode[0]).ShakeOffsetTime=0.000000;
			MinigunFire(FireMode[0]).Spread=0.010000;
		}
		if (MinigunAltFire(FireMode[1]) != None && Minigun(W) != None)
		{
			MinigunAltFire(FireMode[1]).WindupTime=0.0100000;
			MinigunAltFire(FireMode[1]).PrefireTime=0.010000;
			MinigunAltFire(FireMode[1]).Spread=0.009000;
			MinigunAltFire(FireMode[0]).ShakeRotTime=0.000000;
			MinigunAltFire(FireMode[0]).ShakeOffsetTime=0.000000;
		}
	}
	if (default.RedeemerKills >= default.RequiredKills)
	{
		if (RedeemerFire(FireMode[0]) != None)
		{
			RedeemerFire(FireMode[0]).ProjectileClass=class'DEKWeapons208.UpgradeRedeemerProj';
		}
	}
	if (default.RocketKills >= default.RequiredKills)
	{
		if (RocketLauncher(W) != None)
		{
			RocketLauncher(W).SeekRange = 13000.0000;
			RocketLauncher(W).LockRequiredTime = 0.10000;
		}
	}
	if (default.ShieldKills >= default.RequiredKills)
	{
		if (ShieldFire(FireMode[0]) != None)
		{
			ShieldFire(FireMode[0]).SelfDamageScale=0.00;
			ShieldFire(FireMode[0]).SelfForceScale=3.000000;
			ShieldFire(FireMode[0]).MaxDamage=500.000000;
		}
		if (ShieldAltFire(FireMode[1]) != None)
		{
			ShieldAltFire(FireMode[0]).AmmoPerFire=5;
			ShieldAltFire(FireMode[0]).AmmoRegenTime=0.100000;
		}
	}
	if (default.ShockKills >= default.RequiredKills)
	{
		if (ShockProjFire(FireMode[1]) != None)
		{
			ShockProjFire(FireMode[1]).ProjectileClass=Class'DEKWeapons208.UpgradeShockProjectile';
		}
	}
}

defaultproperties
{
	 RequiredKills=20
     L1MaxMines=4
     L2MaxMines=5
     L3MaxMines=6
     L4MaxMines=7
     L5MaxMines=8
     L6MaxMines=9
     L7MaxMines=10
     L8MaxMines=11
     L9MaxMines=12
     L10MaxMines=13
     PlayerLevelReqd(1)=180
     ExcludingAbilities(0)=Class'DEKRPG208.AbilitySpecialistProficiency'
	 ExcludingAbilities(1)=Class'DEKRPG208.AbilityDualityProficiency'
     AbilityName="Niche: Gunsmith"
     Description="Once you make 20 kills with a weapon, that weapon receives an upgrade such as in larger explosions, longer projectile lifespans, and so on.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
