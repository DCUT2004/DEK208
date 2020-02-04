class DEKLightningTurretInstantFire extends SniperFire;

simulated function vector GetFireStart(vector X, vector Y, vector Z)
{
	return DEKLightningTurret(Instigator).GetFireStart();
}

simulated function Rotator	GetPlayerAim( vector StartTrace, float InAimError )
{
	local vector HL, HN;
	ASVehicle(Instigator).CalcWeaponFire( HL, HN );
	return Rotator( HL - StartTrace );
}

simulated function DoTrace(Vector Start, Rotator Dir)
{
	local Vector X, Y, Z, End, HitLocation, HitNormal, RefNormal;
	local Actor Other;
	local int Damage;
	local bool bDoReflect;
	local int ReflectNum;
	local RPGStatsInv StatsInv, HealerStatsInv;
	local float old_xp,cur_xp,xp_each,xp_diff,xp_given_away;
	local int i;
    local int DriverLevel;
    local Controller C;
    local DEKLightningTurretLightningBeamFX hitEmitter;
    local class<Actor> tmpHitEmitClass;

	MaxRange();
	
	Start = GetFireStart(X, Y, Z);
	
    tmpHitEmitClass = class'DEKRPG208.DEKLightningTurretLightningBeamFX';

	ReflectNum = 0;
	while (true)
	{
		bDoReflect = false;
		X = Vector(Dir);
		End = Start + TraceRange * X;
		
		Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);

		if ( Other != None && (Other != Instigator || ReflectNum > 0) )
		{
			if (bReflective && Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, DamageMin*0.25))
			{
				bDoReflect = true;
				HitNormal = Vect(0,0,0);
			}
			else if ( !Other.bWorldGeometry )
			{
				Damage = DamageMin;
				if ( (DamageMin != DamageMax) && (FRand() > 0.5) )
					Damage += Rand(1 + DamageMax - DamageMin);
				Damage = Damage * DamageAtten;

				// Update hit effect except for pawns (blood) other than vehicles.
				if ( Other.IsA('Vehicle') || (!Other.IsA('Pawn') && !Other.IsA('HitScanBlockingVolume')) )
					WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other, HitLocation, HitNormal);

				// find the current dataobject
				if (DEKLightningTurret(Instigator) != None && DEKLightningTurret(Instigator).Driver != None)
				{
					StatsInv = RPGStatsInv(DEKLightningTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
					if (StatsInv != None && StatsInv.DataObject != None)
					{
						old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
						DriverLevel = StatsInv.DataObject.Level;

						if (Level.TimeSeconds > (DEKLightningTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay) && (DEKLightningTurret(Instigator).NumHealers > 0))
						{
							Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKLightningTurret(Instigator).NumHealers);
						}
					}
				}

				Other.TakeDamage(Damage, Instigator, HitLocation, Momentum*X, DamageType);
				HitNormal = Vect(0,0,0);

				if (StatsInv != None && StatsInv.DataObject != None && DriverLevel == StatsInv.DataObject.Level)		// if the driver has levelled, then do not share xp
				{
					cur_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
					xp_diff = cur_xp - old_xp;
					if (xp_diff > 0 && DEKLightningTurret(Instigator).NumHealers > 0)
//					if (xp_diff > 0 && Level.TimeSeconds > DEKLightningTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKLightningTurret(Instigator).NumHealers > 0)
					{
						// split the xp amongst the healers
						xp_each = class'RW_EngineerLink'.static.XPForLinker(xp_diff , DEKLightningTurret(Instigator).Healers.length);
						xp_given_away = 0;

						for(i = 0; i < DEKLightningTurret(Instigator).Healers.length; i++)
						{
							if (DEKLightningTurret(Instigator).Healers[i].Pawn != None && DEKLightningTurret(Instigator).Healers[i].Pawn.Health >0)
							{
							    C = DEKLightningTurret(Instigator).Healers[i];
							    if (DruidLinkSentinelController(C) != None)
									HealerStatsInv = DruidLinkSentinelController(C).StatsInv;
							    else
									HealerStatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
								if (HealerStatsInv != None && HealerStatsInv.DataObject != None)
								{
									HealerStatsInv.DataObject.AddExperienceFraction(xp_each, DEKLightningTurret(Instigator).RPGMut, DEKLightningTurret(Instigator).Healers[i].Pawn.PlayerReplicationInfo);
								}
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
					// DEKLightningTurret(Instigator).Healers.length = 0;	// we have just paid them, so scrub their names
				}

			}
			else if ( WeaponAttachment(Weapon.ThirdPersonActor) != None )
				WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
		}
		else
		{
			HitLocation = End;
			HitNormal = Vect(0,0,0);
			WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
		}
        if ( Weapon == None )
			return;
		
		if (Weapon != None)
		{
			hitEmitter = Weapon.Spawn(class'DEKLightningTurretLightningBeamFX',Instigator,, Start, Rotator(HitNormal));
			if ( hitEmitter != None )
				hitEmitter.mSpawnVecA = HitLocation;
		}

		if (bDoReflect && ++ReflectNum < 4)
		{
			Start = HitLocation;
			Dir = Rotator(RefNormal); //Rotator( X - 2.0*RefNormal*(X dot RefNormal) );
		}
		else
		{
			break;
		}
	}
	Instigator.PlaySound(Sound'WeaponSounds.BaseFiringSounds.BLightningGunFire',,0.50);
	Super.DoTrace(Start, Dir);
}

defaultproperties
{
     HitEmitterClass=None
     NumArcs=10
     SecDamageMult=2.0000000
     SecTraceDist=1000.000000
     DamageTypeHeadShot=Class'DEKRPG208.DamTypeLightningTurretHeadShot'
     DamageType=Class'DEKRPG208.DamTypeLightningTurretLightningBeam'
     DamageMin=55
     DamageMax=55
     FireSound=None
     FireRate=1.000000
     AmmoClass=Class'UT2k4Assault.Ammo_Dummy'
     AmmoPerFire=0
}
