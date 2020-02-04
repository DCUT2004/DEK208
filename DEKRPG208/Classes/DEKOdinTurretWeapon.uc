class DEKOdinTurretWeapon extends ONSWeapon dependson(DEKOdinThickTraceHelper);

var() Sound FireBuildUpSound;
var float BlastBuildUpDelay;
var name EffectsAttachBone;

var float OuterTraceOffset;
var float TraceThickness;

var() float FireRecoilAmount;

var Emitter ChargeBeams[2];
var float BeamSize;
var bool bCharging;
var() vector RightChargeBeamOffset;

//#exec OBJ LOAD FILE=..\Sounds\DEKRPG205.uax
#exec  AUDIO IMPORT NAME="OdinMainFire" FILE="C:\OdinMainFire.WAV" GROUP="TurretSounds"
#exec  AUDIO IMPORT NAME="OdinMainCharge" FILE="C:\OdinMainCharge.WAV" GROUP="TurretSounds"

simulated function DestroyEffects()
{
	if (ChargeBeams[0] != None)
		ChargeBeams[0].Destroy();
	if (ChargeBeams[1] != None)
		ChargeBeams[1].Destroy();
}

function byte BestMode()
{
	return 0;
}

simulated function float ChargeBar()
{
	if (FireCountDown > FireInterval - BlastBuildUpDelay)
		return FClamp((FireCountDown - (FireInterval - BlastBuildUpDelay)) / BlastBuildUpDelay, 0.0, 0.999);
	else
		return FClamp(1 - FireCountDown / (FireInterval - BlastBuildUpDelay), 0.0, 0.999);
}

function bool CanAttack(Actor Other)
{
	local vector Dir, X, Y, Z;

	if (Other != None)
	{
		Dir = Normal(Other.Location - Location);
		GetAxes(Instigator.Rotation, X, Y, Z);

		if (Abs(Z dot Dir) > 0.6)
		{
			// too high/low, i.e. can't reach with turret
			return false;
		}
	}
	return Super.CanAttack(Other);
}

simulated state InstantFireMode
{
	function Fire(Controller C)
	{
		PlayOwnedSound(FireBuildUpSound, SLOT_Misc, FireSoundVolume/255.0,, FireSoundRadius, FireSoundPitch, False);
		SetTimer(BlastBuildUpDelay, False);
		NetUpdateTime = Level.TimeSeconds - 1;
		bClientTrigger = !bClientTrigger;
		PlayChargeUp();
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

	simulated function Timer()
	{
		CalcWeaponFire();

		PlayFire();

		if (Role == ROLE_Authority)
		{
			FlashMuzzleFlash();
			PlayOwnedSound(FireSoundClass, SLOT_None, FireSoundVolume/255.0,, FireSoundRadius, FireSoundPitch, False);
			TraceFire(WeaponFireLocation, WeaponFireRotation);
		}
		else if (Instigator.IsLocallyControlled())
		{
			PlayOwnedSound(FireSoundClass, SLOT_None, FireSoundVolume/255.0,, FireSoundRadius, FireSoundPitch, False);
			FlashMuzzleFlash();
		}
	}
	
	simulated event OwnerEffects()
	{
		if (!bIsRepeatingFF)
		{
			ClientPlayForceFeedback(FireForce);
		}
		ShakeView();

		if (Role < ROLE_Authority)
		{
			FireCountdown = FireInterval;

			PlayChargeUp();
		}

			AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

			if (AmbientEffectEmitter != None)
				AmbientEffectEmitter.SetEmitterStatus(true);

			// Play firing noise
			PlayOwnedSound(FireBuildUpSound, SLOT_Misc, FireSoundVolume/255.0,, FireSoundRadius, FireSoundPitch, False);
			
		SetTimer(BlastBuildUpDelay, False);
	}
}

function PlayChargeUp()
{
	PlayAnim('Charge', 0.3);
	bCharging = True;
}

function PlayFire()
{
	PlayAnim('Fire', 0.5);
	bCharging = False;
}

function Tick(float DeltaTime)
{
	if (!bCharging)
	{
		BeamSize = 0;
		if (ChargeBeams[0] != None)
		{
			ChargeBeams[0].Kill();
			ChargeBeams[0] = None;
		}
		if (ChargeBeams[1] != None)
		{
			ChargeBeams[1].Kill();
			ChargeBeams[1] = None;
		}
	}
	else
	{
		BeamSize += DeltaTime;
		UpdateChargeBeam(0);
		UpdateChargeBeam(1);
	}
}

function UpdateChargeBeam(int n)
{
	local float Dist;

	if (ChargeBeams[n] == None)
	{
		//log("WA_Turret_IonCannon::UpdateChargeBeam Spawning ChargeBeam");
		ChargeBeams[n] = Spawn(class'UT2k4AssaultFull.FX_Turret_IonCannon_ChargeBeam');
		if (ChargeBeams[n] != None)
		{
			AttachToBone(ChargeBeams[n], 'BeamFront');

			ChargeBeams[n].SetRelativeLocation(n * RightChargeBeamOffset);
		}
	}

	if (ChargeBeams[n] != None)
	{
		// Correct Length
		Dist = VSize(GetBoneCoords('BeamFront').Origin - GetBoneCoords('BeamRear').Origin);
		BeamEmitter(ChargeBeams[n].Emitters[0]).BeamDistanceRange.Min   = Dist;
		BeamEmitter(ChargeBeams[n].Emitters[0]).BeamDistanceRange.Max   = Dist;
		SpriteEmitter(ChargeBeams[n].Emitters[2]).StartLocationOffset.X = Dist;

		// Size Scale
		BeamEmitter(ChargeBeams[n].Emitters[0]).StartSizeRange.X.Min = 15.0 * BeamSize * 0.5;
		BeamEmitter(ChargeBeams[n].Emitters[0]).StartSizeRange.X.Max = 50.0 * BeamSize * 0.5;

		SpriteEmitter(ChargeBeams[n].Emitters[1]).StartSizeRange.X.Min =  75.0 * BeamSize * 0.5;
		SpriteEmitter(ChargeBeams[n].Emitters[1]).StartSizeRange.X.Max = 100.0 * BeamSize * 0.5;

		SpriteEmitter(ChargeBeams[n].Emitters[2]).StartSizeRange.X.Min =  75.0 * BeamSize * 0.5;
		SpriteEmitter(ChargeBeams[n].Emitters[2]).StartSizeRange.X.Max = 100.0 * BeamSize * 0.5;
		
		ChargeBeams[n].RemoteRole = ROLE_SimulatedProxy;
	}
}

simulated function CalcWeaponFire()
{
	local coords WeaponBoneCoords;
	local vector CurrentFireOffset;

	// Calculate fire offset in world space
	WeaponBoneCoords = GetBoneCoords(EffectsAttachBone);
	CurrentFireOffset = WeaponFireOffset * vect(1,0,0);

	// Calculate rotation of the gun
	WeaponFireRotation = rotator(vector(CurrentAim) >> Rotation);

	// Calculate exact fire location
	WeaponFireLocation = WeaponBoneCoords.Origin + (CurrentFireOffset >> WeaponFireRotation);

}

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int TraceDistance)
{
	local DEKOdinBlastEmitter Beam;
	//local OdinIonHeatMark Mark;

	Beam = Spawn(class'DEKOdinBlastEmitter', None,, Start, Dir);
	Beam.Instigator = None;
	Beam.HitLocation = HitLocation;
	Beam.SetBeamLength(VSize(HitLocation - Start));

	/*
	Mark = Spawn(class'OdinIonHeatMark', None,, Start, Dir);
	Mark.Initialize(TraceDistance);
	*/
}

function TraceFire(Vector Start, Rotator Dir)
{
	local vector X, Y, Z, HitLocation, HitNormal, ImpactNormal, RefNormal;
	local vector TraceStart, TraceEnd;
	local float Dist, TraceDist, Damage;
	local Actor Other;
	local ONSWeaponPawn WeaponPawn;
	local int i, j, DriverLevel;
	local array<DEKOdinThickTraceHelper.THitInfo> Hits;
    local RPGStatsInv StatsInv, HealerStatsInv;
    local float old_xp,cur_xp,xp_each,xp_diff,xp_given_away;
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

	GetAxes(Dir + rot(0,0,1000), X, Y, Z);

	for (i = -1; i <= 1 && TraceDist < TraceRange; ++i)
	{
		for (j = -1; j <= 1; j++)
		{
			if (Abs(i) + Abs(j) >= 1)
			{
				TraceStart = Start + OuterTraceOffset * (i * Y + j * Z) / Sqrt(Max(i * i + j * j, 1));
				TraceEnd = TraceStart + TraceRange * X;
				Other = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false);
				if (Other == None)
				{
					TraceDist = TraceRange;
					ImpactNormal = vect(0,0,0);
					break;
				}
				Dist = VSize(HitLocation - TraceStart);
				if (Dist > TraceDist)
				{
					TraceDist = Dist;
					ImpactNormal = HitNormal;
				}
			}
		}
	}

	TraceStart = Start;
	TraceEnd = Start + TraceDist * X;
	LastHitLocation = TraceEnd;
	
    if (ONSVehicle(Instigator) != None && ONSVehicle(Instigator).Driver != None)
    {
      	ONSVehicle(Instigator).Driver.bBlockZeroExtentTraces = False;
       	Other = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, True);
       	ONSVehicle(Instigator).Driver.bBlockZeroExtentTraces = true;
    }
	
	/*
	foreach TraceActors(class'Actor', Other, HitLocation, HitNormal, TraceEnd, TraceStart, vect(1,1,1) * TraceThickness)
	{
		if (Other == Level || TerrainInfo(Other) != None || Other.bBlockProjectiles)
			break; // try to trace further with reduced extent
		if (Other != Self && Other != Instigator && (Other.bWorldGeometry || Other.bProjTarget || Other.bBlockActors))
		{
			SpawnHitEffects(Other, HitLocation, HitNormal);
			Damage = (DamageMin + Rand(DamageMax - DamageMin));

			// find the current dataobject
			if (DEKOdinTurret(Instigator) != None && DEKOdinTurret(Instigator).Driver != None)
			{
				StatsInv = RPGStatsInv(DEKOdinTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None && StatsInv.DataObject != None)
				{
					old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
					DriverLevel = StatsInv.DataObject.Level;

					if (Level.TimeSeconds > DEKOdinTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKOdinTurret(Instigator).NumHealers > 0)
						Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKOdinTurret(Instigator).NumHealers);
				}
			}
			if (ONSPowerCore(Other) == None && ONSPowerNodeEnergySphere(Other) == None)  // Sweet Hackaliciousness
				Other.TakeDamage(RandRange(DamageMin, DamageMax), Instigator, HitLocation, Momentum * Normal(HitLocation - Start), DamageType);
			HitNormal = vect(0,0,0);
	
			if (StatsInv != None && StatsInv.DataObject != None && DriverLevel == StatsInv.DataObject.Level)		// if the driver has levelled, then do not share xp
			{
				cur_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
				xp_diff = cur_xp - old_xp;
				if (xp_diff > 0 && DEKOdinTurret(Instigator).NumHealers > 0)
	//			if (xp_diff > 0 && Level.TimeSeconds > DEKOdinTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKOdinTurret(Instigator).NumHealers > 0)
				{
					// split the xp amongst the healers
					xp_each = class'RW_EngineerLink'.static.XPForLinker(xp_diff , DEKOdinTurret(Instigator).Healers.length);		// use Healers.length rather than NumHealers - should be same but 
					xp_given_away = 0;
	
					for(i = 0; i < DEKOdinTurret(Instigator).Healers.length; i++)
					{
						if (DEKOdinTurret(Instigator).Healers[i].Pawn != None && DEKOdinTurret(Instigator).Healers[i].Pawn.Health >0)
						{
						    C = DEKOdinTurret(Instigator).Healers[i];
						    if (DruidLinkSentinelController(C) != None)
								HealerStatsInv = DruidLinkSentinelController(C).StatsInv;
						    else
								HealerStatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
							if (HealerStatsInv != None && HealerStatsInv.DataObject != None)
								HealerStatsInv.DataObject.AddExperienceFraction(xp_each, DEKOdinTurret(Instigator).RPGMut, DEKOdinTurret(Instigator).Healers[i].Pawn.PlayerReplicationInfo);
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
				// DEKOdinTurret(Instigator).Healers.length = 0;	// we have just paid them, so scrub their names
			}

        }
			
	}
	if (Other != None)
	{ // continue with zero-width trace after hitting BSP or terrain
		TraceStart += X * VSize(TraceStart - HitLocation);
		foreach TraceActors(class'Actor', Other, HitLocation, HitNormal, TraceEnd, TraceStart)
		{
			if (Other != Self && Other != Instigator && (Other.bWorldGeometry || Other.bProjTarget || Other.bBlockActors))
			{
				SpawnHitEffects(Other, HitLocation, HitNormal);
				if (Pawn(Other) != None && Pawn(Other).Weapon != None && Pawn(Other).Weapon.CheckReflect(HitLocation, RefNormal, (DamageMin + DamageMax) / 3))
				{
					// successfully blocked by shieldgun, apply reduced damage but increased momentum
					Other.TakeDamage(RandRange(DamageMin, DamageMax) / 3, Instigator, HitLocation, 2 * Momentum * Normal(HitLocation - Start), DamageType);
				}
				else
				{
					Other.TakeDamage(RandRange(DamageMin, DamageMax), Instigator, HitLocation, Momentum * Normal(HitLocation - Start), DamageType);
				}
			}
			if (Other == Level || TerrainInfo(Other) != None || Other.bBlockProjectiles || ONSPowerCoreShield(Other) != None)
				break;
		}
	}
	*/

	Hits = class'DEKOdinThickTraceHelper'.static.TraceHits(Self, TraceStart, TraceEnd, TraceThickness);
	for (i = 0; i < Hits.Length; i++)
	{
		Other = Hits[i].HitActor;

		if (Other.bBlockProjectiles || ONSPowerCoreShield(Other) != None)
			break;

		if (Other != Self && Other != Instigator && (Other.bWorldGeometry || Other.bProjTarget || Other.bBlockActors))
{
			SpawnHitEffects(Other, HitLocation, HitNormal);
			Damage = RandRange(DamageMin, DamageMax);
			if (Other.TraceThisActor(HitLocation, HitNormal, TraceEnd, TraceStart))
			{
				// grazing shot, reduce damage
				Damage *= 0.5;
			}
			// find the current dataobject
			if (DEKOdinTurret(Instigator) != None && DEKOdinTurret(Instigator).Driver != None)
			{
				StatsInv = RPGStatsInv(DEKOdinTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None && StatsInv.DataObject != None)
				{
					old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
					DriverLevel = StatsInv.DataObject.Level;

					if (Level.TimeSeconds > DEKOdinTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKOdinTurret(Instigator).NumHealers > 0)
						Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKOdinTurret(Instigator).NumHealers);
				}
			}
			if (ONSPowerCore(Other) == None && ONSPowerNodeEnergySphere(Other) == None)  // Sweet Hackaliciousness
				Other.TakeDamage(Damage, Instigator, HitLocation, Momentum*X, DamageType);
			HitNormal = vect(0,0,0);
			
			if (StatsInv != None && StatsInv.DataObject != None && DriverLevel == StatsInv.DataObject.Level)		// if the driver has levelled, then do not share xp
			{
				cur_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
				xp_diff = cur_xp - old_xp;
				if (xp_diff > 0 && DEKOdinTurret(Instigator).NumHealers > 0)
	//			if (xp_diff > 0 && Level.TimeSeconds > DEKOdinTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKOdinTurret(Instigator).NumHealers > 0)
				{
					// split the xp amongst the healers
					xp_each = class'RW_EngineerLink'.static.XPForLinker(xp_diff , DEKOdinTurret(Instigator).Healers.length);		// use Healers.length rather than NumHealers - should be same but 
					xp_given_away = 0;
	
					for(i = 0; i < DEKOdinTurret(Instigator).Healers.length; i++)
					{
						if (DEKOdinTurret(Instigator).Healers[i].Pawn != None && DEKOdinTurret(Instigator).Healers[i].Pawn.Health >0)
						{
						    C = DEKOdinTurret(Instigator).Healers[i];
						    if (DruidLinkSentinelController(C) != None)
								HealerStatsInv = DruidLinkSentinelController(C).StatsInv;
						    else
								HealerStatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
							if (HealerStatsInv != None && HealerStatsInv.DataObject != None)
								HealerStatsInv.DataObject.AddExperienceFraction(xp_each, DEKOdinTurret(Instigator).RPGMut, DEKOdinTurret(Instigator).Healers[i].Pawn.PlayerReplicationInfo);
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
				// DEKOdinTurret(Instigator).Healers.length = 0;	// we have just paid them, so scrub their names
			}
			else
			HitLocation = Hits[i].HitLocation;
			HitNormal = Hits[i].Hitnormal;
			if (Pawn(Other) != None && Pawn(Other).Weapon != None && Pawn(Other).Weapon.CheckReflect(HitLocation, RefNormal, (DamageMin + DamageMax) / 3))
			{
				// successfully blocked by shieldgun, apply reduced damage but increased momentum
				Other.TakeDamage(Damage * 0.3, Instigator, HitLocation, 1.5 * Momentum * Normal(HitLocation - Start), DamageType);
			}
			else
			{
				Other.TakeDamage(Damage, Instigator, HitLocation, Momentum * Normal(HitLocation - Start), DamageType);
			}
		}
	}
	if (ImpactNormal != vect(0,0,0))
	{
		HitCount++;
		SpawnHitEffects(Other, LastHitLocation, ImpactNormal);
	}
	SpawnBeamEffect(Start, Dir, LastHitLocation, ImpactNormal, int(TraceDist) + 50);
	Instigator.KAddImpulse(-FireRecoilAmount * vector(Dir), Start);

	NetUpdateTime = Level.TimeSeconds - 1;
}

defaultproperties
{
     FireBuildUpSound=Sound'DEKRPG208.TurretSounds.OdinMainCharge'
     BlastBuildUpDelay=1.250000
     EffectsAttachBone="Muzzle"
     OuterTraceOffset=35.000000
     TraceThickness=120.000000
     FireRecoilAmount=80000.000000
     RightChargeBeamOffset=(Y=200.000000)
     YawBone="IonCannon01"
     PitchBone="Dummy01"
     WeaponFireAttachmentBone="Firepoint"
     WeaponFireOffset=200.000000
     RotationsPerSecond=0.150000
     bInstantFire=True
     bShowChargingBar=True
     bDoOffsetTrace=True
     FireIntervalAimLock=0.400000
     FireInterval=8.500000
     FireSoundClass=Sound'DEKRPG208.TurretSounds.OdinMainFire'
     FireSoundVolume=512.000000
     RotateSound=Sound'ONSBPSounds.ShockTank.TurretHorizontal'
     DamageType=Class'DEKRPG208.DamTypeDEKOdinBeam'
     DamageMin=200
     DamageMax=315
     TraceRange=20000.000000
     Momentum=100000.000000
     AIInfo(0)=(bInstantHit=True,WarnTargetPct=0.900000,RefireRate=0.100000)
     Mesh=SkeletalMesh'AS_VehiclesFull_M.IonCannon'
     DrawScale=0.180000
     bForceSkelUpdate=True
     SoundRadius=1500.000000
     CollisionRadius=62.400002
     CollisionHeight=96.000000
}
