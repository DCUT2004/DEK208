class DEKExplosivesSentinelController extends Controller
	config(UT2004RPG);

var Controller PlayerSpawner;
var RPGStatsInv StatsInv;
var MutUT2004RPG RPGMut;

var config float TimeBetweenShots;
var config float TargetRadius;
var class<xEmitter> ResupplyEmitterClass;

var float DamageAdjust;		// set by AbilityLoadedEngineer
var config float XPPerHit;      // the amount of xp the summoner gets per projectile taken out

var class<xEmitter> HitEmitterClass;        // for standard defense sentinel

var Material HealingOverlay;

var bool bHealing;
var int DoHealCount;

var config float SpiderGrowthRate;


simulated event PostBeginPlay()
{
	local Mutator m;

	super.PostBeginPlay();

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
}

function SetPlayerSpawner(Controller PlayerC)
{
	PlayerSpawner = PlayerC;
	if (PlayerSpawner.PlayerReplicationInfo != None && PlayerSpawner.PlayerReplicationInfo.Team != None )
	{
		if (PlayerReplicationInfo == None)
			PlayerReplicationInfo = spawn(class'PlayerReplicationInfo', self);
		PlayerReplicationInfo.PlayerName = PlayerSpawner.PlayerReplicationInfo.PlayerName$"'s Sentinel";
		PlayerReplicationInfo.bIsSpectator = true;
		PlayerReplicationInfo.bBot = true;
		PlayerReplicationInfo.Team = PlayerSpawner.PlayerReplicationInfo.Team;
		PlayerReplicationInfo.RemoteRole = ROLE_None;

		// adjust the fire rate according to weapon speed
		StatsInv = RPGStatsInv(PlayerSpawner.Pawn.FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None)
			TimeBetweenShots = (default.TimeBetweenShots * 100)/(100 + StatsInv.Data.WeaponSpeed);
		if (DamageAdjust > 0.1)
			TimeBetweenShots = TimeBetweenShots / DamageAdjust;		// cant adjust damage for DamageAdjust, so update fire frequency
	}
	SetTimer(TimeBetweenShots, true);
}

function Timer()
{
	// lets target some enemies
	local Projectile P;
	local xEmitter HitEmitter;
	local Projectile ClosestP;
	local Projectile BestGuidedP;
	local int ClosestPdist;
	local int BestGuidedPdist;
	local Mutator m;
	Local DEKExplosivesSentinel DefPawn;
	local ONSMineProjectile Mine;
	local INAVRiLRocket AVRiL;
	local FlakShell Shell;
	local ONSGrenadeProjectile Grenade;
	local RocketProj Rocket;
	local RedeemerProjectile Deemer;
	local UpgradeINAVRiLRocket UpgradeINAVRiL;
	local UpgradeFlakShell UpgradeShell;
	local Grenade ASGrenade;
	local DEKHEllfireSentinelProjChild HellfireProj;
	local DEKSkyMineTurretProj SkymineProj;
	local DEKLynxRocketProjectile LynxRocket;
	local BombTrapProjectile BombTrap;
	local AerialTrapProjectile AerialTrap;
	local ShockTrapProjectile ShockTrap;
	local FrostTrapProjectile FrostTrap;
	local WildfireTrapProjectile WildfireTrap;
	local DEKLaserGrenadeProjectile LaserGrenade;

	if (PlayerSpawner == None || PlayerSpawner.Pawn == None || Pawn == None || Pawn.Health <= 0 || DEKExplosivesSentinel(Pawn) == None)
		return;		// going to die soon.

	DefPawn = DEKExplosivesSentinel(Pawn);

	// look for projectiles in range
	ClosestP = None;
	BestGuidedP = None;
	ClosestPdist = TargetRadius+1;
	BestGuidedPdist = TargetRadius+1;
	
	
	// ok, lets see if the initiator gets any xp
	if (StatsInv == None && PlayerSpawner != None && PlayerSpawner.Pawn != None)
		StatsInv = RPGStatsInv(PlayerSpawner.Pawn.FindInventoryType(class'RPGStatsInv'));
	// quick check to make sure we got the RPGMut set
	if (RPGMut == None && Level.Game != None)
	{
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
	}
	
	ForEach DynamicActors(class'Projectile',P)
	{
		if (P != None && FastTrace(P.Location, Pawn.Location) && TranslocatorBeacon(P) == None && LifeDrainSoulParticle(P) == None && VSize(Pawn.Location - P.Location) <= TargetRadius)
		{
			if ((P.InstigatorController == None ||
				(P.InstigatorController != None &&
					((TeamGame(Level.Game) != None && !P.InstigatorController.SameTeamAs(PlayerSpawner))))))	// not same team
			{

			}
			else
			{
			    // its a friendly projectile. Lets see if it is a mine and we can boost it
				if (DefPawn.SpiderBoostLevel > 0 && DefPawn.ResupplyLevel > 0 && ONSMineProjectile(P) != None)
				{
					Mine = ONSMineProjectile(P);
					if (Mine.Damage < ((1 + DefPawn.SpiderBoostLevel) * Mine.default.Damage))
					{
					    BoostMine(Mine,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(P.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = P.Location;
						if ((XPPerHit > 0) && Mine.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && INAVRiLRocket(P) != None)
				{
					AVRiL = INAVRiLRocket(P);
					if (AVRiL.Damage < ((1 + DefPawn.SpiderBoostLevel) * AVRiL.default.Damage))
					{
					    BoostMine(AVRiL,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(AVRiL.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = AVRiL.Location;
						if ((XPPerHit > 0) && AVRiL.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && FlakShell(P) != None)
				{
					Shell = FlakShell(P);
					if (Shell.Damage < ((1 + DefPawn.SpiderBoostLevel) * Shell.default.Damage))
					{
					    BoostMine(Shell,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(Shell.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = Shell.Location;
						if ((XPPerHit > 0) && Shell.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && ONSGrenadeProjectile(P) != None)
				{
					Grenade = ONSGrenadeProjectile(P);
					if (Grenade.Damage < ((1 + DefPawn.SpiderBoostLevel) * Grenade.default.Damage))
					{
					    BoostMine(Grenade,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(Grenade.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = Grenade.Location;
						if ((XPPerHit > 0) && Grenade.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && RocketProj(P) != None)
				{
					Rocket = RocketProj(P);
					if (Rocket.Damage < ((1 + DefPawn.SpiderBoostLevel) * Rocket.default.Damage))
					{
					    BoostMine(Rocket,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(Rocket.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = Rocket.Location;
						if ((XPPerHit > 0) && Rocket.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && RedeemerProjectile(P) != None)
				{
					Deemer = RedeemerProjectile(P);
					if (Deemer.Damage < ((1 + DefPawn.SpiderBoostLevel) * Deemer.default.Damage))
					{
					    BoostMine(Deemer,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(Deemer.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = Deemer.Location;
						if ((XPPerHit > 0) && Deemer.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && UpgradeINAVRiLRocket(P) != None)
				{
					UpgradeINAVRiL = UpgradeINAVRiLRocket(P);
					if (UpgradeINAVRiL.Damage < ((1 + DefPawn.SpiderBoostLevel) * UpgradeINAVRiL.default.Damage))
					{
					    BoostMine(UpgradeINAVRiL,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(UpgradeINAVRiL.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = UpgradeINAVRiL.Location;
						if ((XPPerHit > 0) && UpgradeINAVRiL.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && UpgradeFlakShell(P) != None)
				{
					UpgradeShell = UpgradeFlakShell(P);
					if (UpgradeShell.Damage < ((1 + DefPawn.SpiderBoostLevel) * UpgradeShell.default.Damage))
					{
					    BoostMine(UpgradeShell,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(UpgradeShell.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = UpgradeShell.Location;
						if ((XPPerHit > 0) && UpgradeShell.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && Grenade(P) != None)
				{
					ASGrenade = Grenade(P);
					if (ASGrenade.Damage < ((1 + DefPawn.SpiderBoostLevel) * ASGrenade.default.Damage))
					{
					    BoostMine(ASGrenade,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(ASGrenade.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = ASGrenade.Location;
						if ((XPPerHit > 0) && ASGrenade.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && DEKHellfireSentinelProjChild(P) != None)
				{
					HellfireProj = DEKHellfireSentinelProjChild(P);
					if (HellfireProj.Damage < ((1 + DefPawn.SpiderBoostLevel) * HellfireProj.default.Damage))
					{
					    BoostMine(HellfireProj,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(HellfireProj.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = HellfireProj.Location;
						if ((XPPerHit > 0) && HellfireProj.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && DEKSkyMineTurretProj(P) != None)
				{
					SkyMineProj = DEKSkyMineTurretProj(P);
					if (SkyMineProj.Damage < ((1 + DefPawn.SpiderBoostLevel) * SkyMineProj.default.Damage))
					{
					    BoostCombo(SkyMineProj,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(SkyMineProj.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = SkyMineProj.Location;
						if ((XPPerHit > 0) && SkyMineProj.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && DEKLynxRocketProjectile(P) != None)
				{
					LynxRocket = DEKLynxRocketProjectile(P);
					if (LynxRocket.Damage < ((1 + DefPawn.SpiderBoostLevel) * LynxRocket.default.Damage))
					{
					    BoostMine(LynxRocket,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(LynxRocket.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = LynxRocket.Location;
						if ((XPPerHit > 0) && LynxRocket.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && BombTrapProjectile(P) != None)
				{
					BombTrap = BombTrapProjectile(P);
					if (BombTrap.Damage < ((1 + DefPawn.SpiderBoostLevel) * BombTrap.default.Damage))
					{
					    BoostMine(BombTrap,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(BombTrap.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = BombTrap.Location;
						if ((XPPerHit > 0) && BombTrap.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && AerialTrapProjectile(P) != None)
				{
					AerialTrap = AerialTrapProjectile(P);
					if (AerialTrap.Damage < ((1 + DefPawn.SpiderBoostLevel) * AerialTrap.default.Damage))
					{
					    BoostMine(AerialTrap,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(AerialTrap.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = AerialTrap.Location;
						if ((XPPerHit > 0) && AerialTrap.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && ShockTrapProjectile(P) != None)
				{
					ShockTrap = ShockTrapProjectile(P);
					if (ShockTrap.Damage < ((1 + DefPawn.SpiderBoostLevel) * ShockTrap.default.Damage))
					{
					    BoostMine(ShockTrap,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(ShockTrap.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = ShockTrap.Location;
						if ((XPPerHit > 0) && ShockTrap.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && WildfireTrapProjectile(P) != None)
				{
					WildfireTrap = WildfireTrapProjectile(P);
					if (WildfireTrap.Damage < ((1 + DefPawn.SpiderBoostLevel) * WildfireTrap.default.Damage))
					{
					    BoostMine(WildfireTrap,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(WildfireTrap.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = WildfireTrap.Location;
						if ((XPPerHit > 0) && WildfireTrap.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && FrostTrapProjectile(P) != None)
				{
					FrostTrap = FrostTrapProjectile(P);
					if (FrostTrap.Damage < ((1 + DefPawn.SpiderBoostLevel) * FrostTrap.default.Damage))
					{
					    BoostMine(FrostTrap,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(FrostTrap.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = FrostTrap.Location;
						if ((XPPerHit > 0) && FrostTrap.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				if (DefPawn.SpiderBoostLevel > 0 && DEKLaserGrenadeProjectile(P) != None)
				{
					LaserGrenade = DEKLaserGrenadeProjectile(P);
					if (LaserGrenade.LaserDamage < ((1 + DefPawn.SpiderBoostLevel) * LaserGrenade.default.LaserDamage))
					{
					    BoostLaser(LaserGrenade,(SpiderGrowthRate)); 
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(LaserGrenade.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = LaserGrenade.Location;
						if ((XPPerHit > 0) && LaserGrenade.InstigatorController != PlayerSpawner && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
						{
							StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
						}
					}
				}
				// ok, lets see if the initiator gets any xp
				//if (StatsInv == None && PlayerSpawner != None && PlayerSpawner.Pawn != None)
				//	StatsInv = RPGStatsInv(PlayerSpawner.Pawn.FindInventoryType(class'RPGStatsInv'));
				// quick check to make sure we got the RPGMut set
				//if (RPGMut == None && Level.Game != None)
				//{
				//	for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
				//		if (MutUT2004RPG(m) != None)
				//		{
				//			RPGMut = MutUT2004RPG(m);
				//			break;
				//		}
				//}
				//if ((XPPerHit > 0) && P.InstigatorController != PlayerSpawner && P.Damage < ((1 + DefPawn.SpiderBoostLevel) * P.default.Damage) && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
				//{
				//	if (P != LaserGrenade)
				//		StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
				//}
			}
		}
	}
}

static function BoostMine(Projectile P, float SpiderGrowthRate)
{
    local vector NewLoc;

    // this code based on the mutator by Rachel 'Angel Mapper' Cordone
    NewLoc = P.Location;
    NewLoc.Z += 2*SpiderGrowthRate;
    P.SetDrawScale(P.DrawScale*SpiderGrowthRate);
    P.SetCollisionSize(P.CollisionRadius*SpiderGrowthRate,P.CollisionHeight*SpiderGrowthRate);
    P.SetLocation(NewLoc);
    P.DamageRadius *= SpiderGrowthRate;
    P.Damage *= SpiderGrowthRate;
    P.MomentumTransfer *= SpiderGrowthRate;
}

static function BoostCombo(DEKSkyMineTurretProj P, float SpiderGrowthRate)
{
    local vector NewLoc;

    // this code based on the mutator by Rachel 'Angel Mapper' Cordone
    NewLoc = P.Location;
    NewLoc.Z += 2*SpiderGrowthRate;
    P.SetDrawScale(P.DrawScale*SpiderGrowthRate);
    P.SetCollisionSize(P.CollisionRadius*SpiderGrowthRate,P.CollisionHeight*SpiderGrowthRate);
    P.SetLocation(NewLoc);
    P.ComboRadius *= SpiderGrowthRate;
    P.ComboDamage *= SpiderGrowthRate;
    P.ComboMomentumTransfer *= SpiderGrowthRate;
}

static function BoostLaser(DEKLaserGrenadeProjectile P, float SpiderGrowthRate)
{
    // this code based on the mutator by Rachel 'Angel Mapper' Cordone
    P.LaserDamage *= SpiderGrowthRate;
}

function Destroyed()
{
	if (PlayerReplicationInfo != None)
		PlayerReplicationInfo.Destroy();

	Super.Destroyed();
}

defaultproperties
{
     TimeBetweenShots=0.400000
     TargetRadius=1000.000000
     ResupplyEmitterClass=Class'DEKRPG208.RedBoltEmitter'
     DamageAdjust=1.000000
     XPPerHit=0.050000
     HitEmitterClass=Class'DEKRPG208.PurpleBoltEmitter'
     SpiderGrowthRate=1.100000
}
