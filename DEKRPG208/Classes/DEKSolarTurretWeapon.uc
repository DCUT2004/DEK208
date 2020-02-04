class DEKSolarTurretWeapon extends ONSWeapon;

var bool bFiring, bAltWeaponFirePoint;
var float BeamFireDuration;
var float BeamRehitDelay;
var float BlastBuildUpDelay;
var name WeaponAltFireAttachmentBone;
var Sound AltFireBuildUpSound;

var array<Actor> RecentlyHit;
var array<float> RecentHitTime;

var class<Actor> BuildUpEffectClass;
var class<DEKSolarTurretHeatRayEffect> BeamEffectClass;
var DEKSolarTurretHeatRayEffect BeamEffect;

#exec  AUDIO IMPORT NAME="SolarTurretFire" FILE="C:\UT2004\Sounds\SolarTurretFire.WAV" GROUP="TurretSounds"
#exec  AUDIO IMPORT NAME="SolarTurretAltCharge" FILE="C:\UT2004\Sounds\SolarTurretAltCharge.WAV" GROUP="TurretSounds"
#exec  AUDIO IMPORT NAME="SolarTurretAltFire" FILE="C:\UT2004\Sounds\SolarTurretAltFire.WAV" GROUP="TurretSounds"

replication
{
	reliable if (bNetOwner)
		bAltWeaponFirePoint;

	reliable if (!bNetOwner)
		bFiring;

	reliable if (bNetdirty)
		BeamEffect;
}

simulated event FlashMuzzleFlash()
{
	Super.FlashMuzzleFlash();

	if (Team == 1 && DEKSolarTurretEnergyWaveTrailer(EffectEmitter) != None)
		DEKSolarTurretEnergyWaveTrailer(EffectEmitter).SetBlueEffects();
}

simulated function DestroyEffects()
{
	EffectEmitter = None; // don't mess with it, it's the shock wave that might still be going independently

	Super.DestroyEffects();
}


function bool CanAttack(Actor Other)
{
	local float Dist, CheckDist;
	local vector HitLocation, HitNormal;
	local actor HitActor;

	if (Instigator == None || Instigator.Controller == None)
		return false;

	// check that target is within range
	Dist = VSize(Instigator.Location - Other.Location);
	if (Dist > MaxRange())
		return false;

	// check that can see target
	if (!Instigator.Controller.LineOfSightTo(Other))
	{
		// might still decide to attack if known to be in shockwave range
		CheckDist = FMin(Dist, 2000.0);
		if (Dist < CheckDist)
			return Pawn(Other) == None || Pawn(Other).Controller == None || !Instigator.Controller.SameTeamAs(Pawn(Other).Controller);
		return false;
	}

	// check that would hit target, and not a friendly
	CalcWeaponFire();
	HitActor = Trace(HitLocation, HitNormal, Other.Location + Other.CollisionHeight * vect(0,0,0.8), WeaponFireLocation, true);

	return HitActor == None || HitActor == Other || Pawn(HitActor) == None || Pawn(HitActor).Controller == None || !Instigator.Controller.SameTeamAs(Pawn(HitActor).Controller);
}


function byte BestMode()
{
	local vector dir;

	if (Instigator.Controller != None && Instigator.Controller.Target != None) {
		// maybe pick shockwave instead of beam
		dir = Instigator.Controller.Target.Location - Location + 0.5 * (Instigator.Controller.Target.Velocity - Instigator.Velocity);
		return int(VSize(dir) < 1500 + FRand() * 500);
	}
	return 0;
}

function TraceFire(Vector Start, Rotator Dir)
{
	local Vector X, End, HitLocation, HitNormal;
	local Actor Other;
	local ONSWeaponPawn WeaponPawn;
	local Vehicle VehicleInstigator;
	local RPGStatsInv StatsInv, HealerStatsInv;
    local float old_xp,cur_xp,xp_each,xp_diff,xp_given_away;
	local int Damage, i;
	local int DriverLevel;
    local Controller C;

	MaxRange();

	if (bDoOffsetTrace)
	{
		WeaponPawn = ONSWeaponPawn(Owner);
		if (WeaponPawn != None && WeaponPawn.VehicleBase != None)
		{
			if (!WeaponPawn.VehicleBase.TraceThisActor(HitLocation, HitNormal, Start, Start + vector(Dir) * (WeaponPawn.VehicleBase.CollisionRadius * 1.5)))
				Start = HitLocation;
		}
		else if (!Owner.TraceThisActor(HitLocation, HitNormal, Start, Start + vector(Dir) * (Owner.CollisionRadius * 1.5)))
			Start = HitLocation;
	}

	X = Vector(Dir);
	End = Start + TraceRange * X;

	//skip past vehicle driver
	VehicleInstigator = Vehicle(Instigator);
	if (VehicleInstigator != None && VehicleInstigator.Driver != None)
	{
		VehicleInstigator.Driver.bBlockZeroExtentTraces = false;
		Other = Trace(HitLocation, HitNormal, End, Start, true);
		VehicleInstigator.Driver.bBlockZeroExtentTraces = true;
	}
	else
	{
		Other = Trace(HitLocation, HitNormal, End, Start, True);
	}

	for (i = RecentlyHit.Length - 1; i >= 0; i--)
	{
		if (Level.TimeSeconds - RecentHitTime[i] > BeamRehitDelay)
		{
			RecentHitTime.Remove(i, 1);
			RecentlyHit.Remove(i, 1);
		}
		else if (Other == RecentlyHit[i])
			break;
	}
	if (i == -1)
	{
		if (Other != None && Other != Instigator)
		{
			if (!Other.bWorldGeometry)
			{
				Damage = DamageMin + Rand(DamageMax - DamageMin);
				// find the current dataobject
				if (DEKSolarTurret(Instigator) != None && DEKSolarTurret(Instigator).Driver != None)
				{
					StatsInv = RPGStatsInv(DEKSolarTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
					if (StatsInv != None && StatsInv.DataObject != None)
					{
						old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
						DriverLevel = StatsInv.DataObject.Level;

						if (Level.TimeSeconds > DEKSolarTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKSolarTurret(Instigator).NumHealers > 0)
							Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKSolarTurret(Instigator).NumHealers);
					}
				}
	
	
				if (ONSPowerCore(Other) == None && ONSPowerNodeEnergySphere(Other) == None)  // Sweet Hackaliciousness
					Other.TakeDamage(Damage, Instigator, HitLocation, Momentum*X, DamageType);
				HitNormal = vect(0,0,0);
	
				if (StatsInv != None && StatsInv.DataObject != None && DriverLevel == StatsInv.DataObject.Level)		// if the driver has levelled, then do not share xp
			{
					cur_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
					xp_diff = cur_xp - old_xp;
					if (xp_diff > 0 && DEKSolarTurret(Instigator).NumHealers > 0)
	//				if (xp_diff > 0 && Level.TimeSeconds > DEKSolarTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKSolarTurret(Instigator).NumHealers > 0)
					{
						// split the xp amongst the healers
						xp_each = class'RW_EngineerLink'.static.XPForLinker(xp_diff , DEKSolarTurret(Instigator).Healers.length);		// use Healers.length rather than NumHealers - should be same but 
						xp_given_away = 0;
	
						for(i = 0; i < DEKSolarTurret(Instigator).Healers.length; i++)
						{
							if (DEKSolarTurret(Instigator).Healers[i].Pawn != None && DEKSolarTurret(Instigator).Healers[i].Pawn.Health >0)
							{
								C = DEKSolarTurret(Instigator).Healers[i];
								if (DruidLinkSentinelController(C) != None)
									HealerStatsInv = DruidLinkSentinelController(C).StatsInv;
								else
									HealerStatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
								if (HealerStatsInv != None && HealerStatsInv.DataObject != None)
									HealerStatsInv.DataObject.AddExperienceFraction(xp_each, DEKSolarTurret(Instigator).RPGMut, DEKSolarTurret(Instigator).Healers[i].Pawn.PlayerReplicationInfo);
								xp_given_away += xp_each;
							}
						}
						// now adjust the turret operator
						if (xp_given_away > 0)
						{
							StatsInv.DataObject.ExperienceFraction -= xp_given_away;
							while (StatsInv.DataObject.ExperienceFraction < 0)
							{
								StatsInv.DataObject.ExperienceFraction += 1.0;
								StatsInv.DataObject.Experience -= 1;
							}
						}
	
					}
					// DEKSolarTurret(Instigator).Healers.length = 0;	// we have just paid them, so scrub their names
				}
				if (Vehicle(Other) != None || Pawn(Other) == None)
				{
					HitCount++;
					LastHitLocation = HitLocation;
					SpawnHitEffects(Other, HitLocation, HitNormal);
				}
				if (!Other.bStatic)
					Other.TakeDamage(Damage, Instigator, HitLocation, Momentum*X, DamageType);
				HitNormal = vect(0,0,0);
			}
			else
			{
				HitCount++;
				LastHitLocation = HitLocation;
				SpawnHitEffects(Other, HitLocation, HitNormal);
			}
			// remember recent hit
			if (Other != None)
			{
				RecentlyHit[RecentlyHit.Length] = Other;
				RecentHitTime[RecentHitTime.Length] = Level.TimeSeconds;
			}
		}
		else
		{
			HitLocation = End;
			HitNormal = Vect(0,0,0);
			HitCount++;
			LastHitLocation = HitLocation;
		}
		NetUpdateTime = Level.TimeSeconds - 1;
	}

	if (BeamEffect != None)
	{
		if (Other != None)
			BeamEffect.EndEffect = HitLocation;
		else
			BeamEffect.EndEffect = End;
		BeamEffect.bHitSomething = (Other != None);
	}
}

simulated function TraceBeam(Vector Start, Rotator Dir)
{
	local Vector X, End, HitLocation, HitNormal;
	local Actor Other;
	local ONSWeaponPawn WeaponPawn;
	local Vehicle VehicleInstigator;

	MaxRange();

	if (bDoOffsetTrace)
	{
		WeaponPawn = ONSWeaponPawn(Owner);
		if (WeaponPawn != None && WeaponPawn.VehicleBase != None)
		{
			if (!WeaponPawn.VehicleBase.TraceThisActor(HitLocation, HitNormal, Start, Start + vector(Dir) * (WeaponPawn.VehicleBase.CollisionRadius * 1.5)))
				Start = HitLocation;
		}
		else if (!Owner.TraceThisActor(HitLocation, HitNormal, Start, Start + vector(Dir) * (Owner.CollisionRadius * 1.5)))
			Start = HitLocation;
	}

	X = Vector(Dir);
	End = Start + TraceRange * X;

	//skip past vehicle driver
	VehicleInstigator = Vehicle(Instigator);
	if (VehicleInstigator != None && VehicleInstigator.Driver != None) {
		VehicleInstigator.Driver.bBlockZeroExtentTraces = false;
		Other = Trace(HitLocation, HitNormal, End, Start, true);
		VehicleInstigator.Driver.bBlockZeroExtentTraces = true;
	}
	else
	{
		Other = Trace(HitLocation, HitNormal, End, Start, True);
	}

	if (BeamEffect != None)
	{
		if (Other != None)
			BeamEffect.EndEffect = HitLocation;
		else
			BeamEffect.EndEffect = End;
		BeamEffect.bHitSomething = (Other != None && Other.bWorldGeometry);
	}
}

simulated function float ChargeBar()
{
	if (bIsAltFire)
	{
		if (FireCountDown > AltFireInterval - BlastBuildUpDelay)
			return FClamp((FireCountDown - (AltFireInterval - BlastBuildUpDelay)) / BlastBuildUpDelay, 0.0, 0.999);
		else
			return FClamp(1 - FireCountDown / (AltFireInterval - BlastBuildUpDelay), 0.0, 0.999);
	}
	else
	{
		if (FireCountdown > FireInterval - BeamFireDuration)
			return FClamp((FireCountDown - (FireInterval - BeamFireDuration)) / BeamFireDuration, 0.0, 0.999);
		else
			return FClamp(1 - FireCountDown / (FireInterval - BeamFireDuration), 0.0, 0.999);
	}
}


simulated event PostNetReceive()
{
	if (bAltWeaponFirePoint)
	{
		WeaponFireAttachmentBone = WeaponAltFireAttachmentBone;
	}
	else
	{
		WeaponFireAttachmentBone = default.WeaponFireAttachmentBone;
	}
}


function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
	local Projectile P;

	P = Super.SpawnProjectile(ProjClass, bAltFire);
	if (DEKSolarTurretEnergyWave(P) != None)
		DEKSolarTurretEnergyWave(P).SetBlueEffects(Team == 1);

	return P;
}


simulated function ClientTrigger()
{
	local Actor BuildUpEffect;

	BuildUpEffect = Spawn(BuildUpEffectClass, Self);
	if (BuildUpEffect != None)
		AttachToBone(BuildUpEffect, WeaponAltFireAttachmentBone);
}

simulated state InstantFireMode
{
	function Fire(Controller C)
	{
		bFiring = True;
		PlayOwnedSound(FireSoundClass, SLOT_None, FireSoundVolume/255.0,, FireSoundRadius, FireSoundPitch, False);
		GotoState(, 'FireBeam');
		NetUpdateTime = Level.TimeSeconds - 1;
	}

	simulated function Tick(float DeltaTime)
	{
		Global.Tick(DeltaTime);

		if (bFiring)
		{
			CalcWeaponFire();
			if (Role == ROLE_Authority && BeamEffect == None)
			{
				BeamEffect = Spawn(BeamEffectClass, Instigator,, WeaponFireLocation, WeaponFireRotation);
				if (BeamEffect != None && Team < 2)
					BeamEffect.LinkColor = Team + 1;
			}
			else if (BeamEffect != None)
			{
				BeamEffect.SetLocation(WeaponFireLocation);
				BeamEffect.SetRotation(WeaponFireRotation);
			}

			if (Role == ROLE_Authority)
				TraceFire(WeaponFireLocation, WeaponFireRotation);
			else
				TraceBeam(WeaponFireLocation, WeaponFireRotation);
		}
		else if (Role == ROLE_Authority && BeamEffect != None)
			BeamEffect.Destroy();
	}

	simulated function SpawnHitEffects(actor HitActor, vector HitLocation, vector HitNormal)
	{
		local PlayerController PC;

		PC = Level.GetLocalPlayerController();
		if (PC != None && ((Instigator != None && Instigator.Controller == PC) || VSize(PC.ViewTarget.Location - HitLocation) < 5000))
		{
			// TODO - impact effects
		}
	}

	function AltFire(Controller C)
	{
		local Actor BuildUpEffect;

		bAltWeaponFirePoint = True;
		WeaponFireAttachmentBone = WeaponAltFireAttachmentBone;
		PlayOwnedSound(AltFireBuildUpSound, SLOT_None, AltFireSoundVolume/255.0,, AltFireSoundRadius, FireSoundPitch, False);
		SetTimer(BlastBuildUpDelay, False);
		NetUpdateTime = Level.TimeSeconds - 1;
		bClientTrigger = !bClientTrigger;
		if (Level.NetMode != NM_DedicatedServer)
		{
			BuildUpEffect = Spawn(BuildUpEffectClass, Self);
			if (BuildUpEffect != None)
				AttachToBone(BuildUpEffect, WeaponAltFireAttachmentBone);
		}
	}

	simulated function Timer()
	{
		CalcWeaponFire();

		if (Role == ROLE_Authority)
		{
			SpawnProjectile(AltFireProjectileClass, True);
		}
		else if (Instigator.IsLocallyControlled())
		{
			PlayOwnedSound(AltFireSoundClass, SLOT_None, 2.0,, AltFireSoundRadius, FireSoundPitch, False);
			FlashMuzzleFlash();
		}
		bAltWeaponFirePoint = False;
		WeaponFireAttachmentBone = default.WeaponFireAttachmentBone;
	}

	simulated event OwnerEffects()
	{
		if (!bIsRepeatingFF)
		{
			if (bIsAltFire)
				ClientPlayForceFeedback( AltFireForce );
			else
				ClientPlayForceFeedback( FireForce );
		}
		ShakeView();

		if (Role < ROLE_Authority)
		{
			if (bIsAltFire)
				FireCountdown = AltFireInterval;
			else
				FireCountdown = FireInterval;

			AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

			if (AmbientEffectEmitter != None)
				AmbientEffectEmitter.SetEmitterStatus(true);

			// Play firing noise
			if (!bAmbientFireSound)
			{
				if (bIsAltFire)
					PlayOwnedSound(AltFireBuildUpSound, SLOT_None, FireSoundVolume/255.0,, AltFireSoundRadius,, false);
				else
					PlayOwnedSound(FireSoundClass, SLOT_None, FireSoundVolume/255.0,, FireSoundRadius,, false);
			}
		}

		if (bIsAltFire)
		{
			bAltWeaponFirePoint = True;
			WeaponFireAttachmentBone = WeaponAltFireAttachmentBone;
			SetTimer(BlastBuildUpDelay, False);
		}
		else
		{
			bFiring = True;
			GotoState(, 'FireBeam');
		}
	}

	simulated function EndState()
	{
		bFiring = False;
	}

FireBeam:
	Sleep(BeamFireDuration);
	bFiring = False;
	NetUpdateTime = Level.TimeSeconds - 1;
}

defaultproperties
{
     BeamFireDuration=2.000000
     BeamRehitDelay=0.400000
     BlastBuildUpDelay=0.500000
     WeaponAltFireAttachmentBone="Muzzle"
     AltFireBuildUpSound=Sound'DEKRPG208.TurretSounds.SolarTurretAltCharge'
     BuildUpEffectClass=Class'DEKRPG208.DEKSolarTurretEnergyWaveChargeEffect'
     BeamEffectClass=Class'DEKRPG208.DEKSolarTurretHeatRayEffect'
     YawBone="Object02"
     PitchBone="Wheel"
     PitchUpLimit=16000
     PitchDownLimit=61000
     WeaponFireAttachmentBone="Muzzle"
     RotationsPerSecond=0.150000
     bInstantFire=True
     bShowChargingBar=True
     Spread=500.045013
     FireInterval=5.500000
     AltFireInterval=3.800000
     EffectEmitterClass=Class'DEKRPG208.DEKSolarTurretEnergyWaveTrailer'
     FireSoundClass=Sound'DEKRPG208.TurretSounds.SolarTurretFire'
     FireSoundVolume=412.000000
     AltFireSoundClass=Sound'DEKRPG208.TurretSounds.SolarTurretAltFire'
     DamageType=Class'DEKRPG208.DamTypeDEKSolarTurretBeam'
     DamageMin=35
     DamageMax=40
     TraceRange=20000.000000
     Momentum=10000.000000
     AltFireProjectileClass=Class'DEKRPG208.DEKSolarTurretEnergyWave'
     AIInfo(0)=(bLeadTarget=True,WarnTargetPct=0.750000,RefireRate=0.500000)
     AIInfo(1)=(bLeadTarget=True,WarnTargetPct=0.750000,RefireRate=0.500000)
     Mesh=SkeletalMesh'AS_VehiclesFull_M.LinkBody'
     DrawScale=0.200000
     Skins(0)=Combiner'AS_Weapons_TX.LinkTurret.LinkTurret_Skin2_C'
     Skins(1)=Combiner'AS_Weapons_TX.LinkTurret.LinkTurret_Skin1_C'
     Skins(2)=Shader'UT2004Weapons.Shaders.PowerPulseShaderYellow'
     bForceSkelUpdate=True
     CollisionRadius=60.000000
     CollisionHeight=90.000000
     bNetNotify=True
}
