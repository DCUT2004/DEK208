class DEKLightningTurretProj extends Projectile
	config(UT2004RPG);

var DEKLightningTurretProjFX LightningEffect;

var(Minibolts)  float           MiniboltInterval;
var(Minibolts)  int             MiniboltDamage;
var(Minibolts)  int             MiniboltRadius;
var(Minibolts)  class<Emitter>  MiniboltClass;
var(Minibolts)  class<VehicleDamageType> MiniboltDamageType;
var(Minibolts)  int             LightningComboDamage;
var(Minibolts)  int             LightningComboRadius;
var(Minibolts)  class<VehicleDamageType> LightningComboDamageType;
var config int DischargeChance;

simulated function PostBeginPlay()
{	
    if ( Level.NetMode != NM_DedicatedServer )
	{
        LightningEffect = Spawn(class'DEKLightningTurretProjFX', self);
        LightningEffect.SetBase(self);
	}
	
	Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer
	
    SetTimer(MiniboltInterval, true);

    super.PostNetBeginPlay();
}

simulated function Destroyed()
{
    if (LightningEffect != None)
    {
		LightningEffect.Destroy();
		//LightningEffect.Kill();
	}

	Super.Destroyed();
}

/** Minibolts: Spawn a minibolt. */
simulated function Timer()
{
    local float Distance, BeamLength;
    local vector Momentum, Direction;
    local DEKLightningTurretMiniBolt Bolt;
	local RPGStatsInv StatsInv, HealerStatsInv;
	local float old_xp,cur_xp,xp_each,xp_diff,xp_given_away;
	local int i, DriverLevel, MostHealth;
    local Controller C, D, BestC;
	
	if (Rand(99) <= DischargeChance)
	{
		// Zap all nearby targets.
		C = Level.ControllerList;
		BestC = None;
		MostHealth = 0;
		while (C != None)
		{
			// loop round finding strongest enemy to attack
			if ( C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.SameTeamAs(Instigator.Controller)
				&& VSize(C.Pawn.Location - Location) < MiniboltRadius && FastTrace(C.Pawn.Location, Location) && C.bGodMode == False && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow'))
			{
				if (C.Pawn.Health > MostHealth)
				{
					MostHealth = C.Pawn.Health;
					BestC = C;
				}
			}
			C = C.NextController;
		}
		if ((MostHealth > 0) && (BestC != None) && (BestC.Pawn != None))
		{
            Direction = BestC.Pawn.Location - Location;
            Distance = FMax(1, VSize(Direction));
            Direction = Direction / Distance;
            Momentum = Direction * MomentumTransfer;

            BeamLength = VSize(BestC.Pawn.Location - Location);

            Bolt = Spawn(class'DEKLightningTurretMinibolt',,, Location, rotator(BestC.Pawn.Location - Location));
			if (Bolt != None)
			{
				BeamEmitter(Bolt.Emitters[0]).BeamDistanceRange.Min = BeamLength;
				BeamEmitter(Bolt.Emitters[0]).BeamDistanceRange.Max = BeamLength;
				Bolt.RemoteRole = Role_SimulatedProxy;
				Bolt.SpawnEffects(BestC.Pawn, Location, Direction * -1);
				Bolt.SetBase(self);
				Bolt.RemoteRole = ROLE_SimulatedProxy;
				Spawn(class'DEKLightningTurretProjSparks',,, BestC.Pawn.Location);
			}

            // Deal damage.
			if ( Instigator != None && (BestC.Pawn == Instigator) )
				return;

			//if ( Role == ROLE_Authority )
			//{
				if ( Instigator == None || Instigator.Controller == None )
					BestC.Pawn.SetDelayedDamageInstigatorController( InstigatorController );

				// find the current dataobject
				if (DEKLightningTurret(Instigator) != None && DEKLightningTurret(Instigator).Driver != None)
				{
					StatsInv = RPGStatsInv(DEKLightningTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
					if (StatsInv != None && StatsInv.DataObject != None)
					{
						old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
						DriverLevel = StatsInv.DataObject.Level;

						if (Level.TimeSeconds > DEKLightningTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKLightningTurret(Instigator).NumHealers > 0)
							Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKLightningTurret(Instigator).NumHealers);
					}
				}

				BestC.Pawn.TakeDamage(MiniboltDamage, Instigator, BestC.Pawn.Location, Momentum, MiniboltDamageType);

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
								D = DEKLightningTurret(Instigator).Healers[i];
								if (DruidLinkSentinelController(D) != None)
									HealerStatsInv = DruidLinkSentinelController(D).StatsInv;
								else
									HealerStatsInv = RPGStatsInv(D.Pawn.FindInventoryType(class'RPGStatsInv'));
								if (HealerStatsInv != None && HealerStatsInv.DataObject != None)
									HealerStatsInv.DataObject.AddExperienceFraction(xp_each, DEKLightningTurret(Instigator).RPGMut, DEKLightningTurret(Instigator).Healers[i].Pawn.PlayerReplicationInfo);
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
			//}
		}
		else
			return;
	}
	else
		return;
}

simulated event ProcessTouch(Actor Other, vector HitLocation)
{
    if(!Other.IsA('Projectile') || Other.bProjTarget)
    {
        super.ProcessTouch(Other, HitLocation);
    }
}

simulated function Landed( vector HitNormal )
{
    Explode(Location, HitNormal);
}

simulated function HitWall (vector HitNormal, actor Wall)
{
    Landed(HitNormal);
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	local RPGStatsInv StatsInv, HealerStatsInv;
	local float old_xp,cur_xp,xp_each,xp_diff,xp_given_away;
	local int i;
    local int DriverLevel;
    local Controller C;

	if ( Role == ROLE_Authority )
	{
		if (DEKLightningTurret(Instigator) != None && DEKLightningTurret(Instigator).Driver != None)
		{
			StatsInv = RPGStatsInv(DEKLightningTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
			if (StatsInv != None && StatsInv.DataObject != None)
			{
				old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
				DriverLevel = StatsInv.DataObject.Level;

				if (Level.TimeSeconds > DEKLightningTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKLightningTurret(Instigator).NumHealers > 0)
					Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKLightningTurret(Instigator).NumHealers);
					DamageRadius = DamageRadius * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKLightningTurret(Instigator).NumHealers);
			}
		}

		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

		if (StatsInv != None && StatsInv.DataObject != None && DriverLevel == StatsInv.DataObject.Level)		// if the driver has levelled, then do not share xp
		{
			cur_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
			xp_diff = cur_xp - old_xp;
			if (xp_diff > 0 && DEKLightningTurret(Instigator).NumHealers > 0)
//			if (xp_diff > 0 && Level.TimeSeconds > DEKLightningTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKLightningTurret(Instigator).NumHealers > 0)
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
							HealerStatsInv.DataObject.AddExperienceFraction(xp_each, DEKLightningTurret(Instigator).RPGMut, DEKLightningTurret(Instigator).Healers[i].Pawn.PlayerReplicationInfo);
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

	PlaySound(Sound'ONSBPSounds.ShieldActivate',,3.5*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
	    Spawn(class'DEKLightningTurretProjSparks',,, Location);
	}
    SetCollisionSize(0.0, 0.0);
	Destroy();
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
    local float Distance, BeamLength;
    local vector Direction;
    local DEKLightningTurretMiniBolt Bolt;
	local Controller C, D, NextC;
	local Pawn Victim;
	local RPGStatsInv StatsInv, HealerStatsInv;
	local float old_xp,cur_xp,xp_each,xp_diff,xp_given_away;
	local int i;
    local int DriverLevel;
	local Actor A;
	
	if (DamageType == class'DamTypeLightningTurretLightningBeam')
	{
		C = Level.ControllerList;
		while (C != None)
		{
			// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
			NextC = C.NextController;
			// loop round finding strongest enemy to attack
			if ( C != None && C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.SameTeamAs(Instigator.Controller)
				&& VSize(C.Pawn.Location - Location) < LightningComboRadius && FastTrace(C.Pawn.Location, Location) && C.bGodMode == False && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow'))
			{
				Victim = C.Pawn;
			}
			C = NextC;
		}
		
		if (Victim != None && Victim.Health > 0)
		{
			Victim.TakeDamage(LightningComboDamage, Instigator, Victim.Location, Momentum, LightningComboDamageType);		
			Direction = Victim.Location - Location;
			Distance = FMax(1, VSize(Direction));
			Direction = Direction / Distance;
			Momentum = Direction * MomentumTransfer;

			BeamLength = VSize(Victim.Location - Location);
			Bolt = Spawn(class'DEKLightningTurretMinibolt',,, Location, rotator(Victim.Location - Location));
			if (Bolt != None)
			{
				BeamEmitter(Bolt.Emitters[0]).BeamDistanceRange.Min = BeamLength;
				BeamEmitter(Bolt.Emitters[0]).BeamDistanceRange.Max = BeamLength;
				Bolt.RemoteRole = Role_SimulatedProxy;
				Bolt.SpawnEffects(Victim, Location, Direction * -1);
				Bolt.SetBase(self);
				Spawn(class'DEKLightningTurretProjSparks',,, Victim.Location);
			}
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
							    D = DEKLightningTurret(Instigator).Healers[i];
							    if (DruidLinkSentinelController(D) != None)
									HealerStatsInv = DruidLinkSentinelController(D).StatsInv;
							    else
									HealerStatsInv = RPGStatsInv(D.Pawn.FindInventoryType(class'RPGStatsInv'));
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
		PlaySound(Sound'GeneralAmbience.electricalfx6', SLOT_None, 10.0);
		Instigator.PlaySound(Sound'GeneralAmbience.electricalfx6', SLOT_None, 10.0);
		A = Spawn(class'DEKLightningTurretComboFlash',,, Self.Location);
		if (A != None)
			A.RemoteRole = ROLE_SimulatedProxy;
		Explode(Location, vect(0,0,-1));
	}
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

defaultproperties
{
     MiniboltInterval=0.200000
     MiniboltDamage=40
     MiniboltRadius=400
     MiniboltClass=Class'DEKRPG208.DEKLightningTurretMinibolt'
     MiniboltDamageType=Class'DEKRPG208.DamTypeLightningTurretMinibolt'
     LightningComboDamage=70
     LightningComboRadius=900
     LightningComboDamageType=Class'DEKRPG208.DamTypeLightningTurretCombo'
     DischargeChance=30
     Speed=3000.000000
     MaxSpeed=3000.000000
     bSwitchToZeroCollision=True
     Damage=70.000000
     DamageRadius=60.000000
     MomentumTransfer=1000.000000
     MyDamageType=Class'DEKRPG208.DamTypeLightningTurretProj'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     ExplosionDecal=Class'XEffects.LinkScorch'
     MaxEffectDistance=7000.000000
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=155
     LightSaturation=85
     LightBrightness=255.000000
     LightRadius=4.000000
     DrawType=DT_Sprite
     CullDistance=4000.000000
     bDynamicLight=True
     bNetTemporary=False
     bOnlyDirtyReplication=True
     AmbientSound=Sound'GeneralAmbience.electricalfx12'
     LifeSpan=10.000000
     Texture=Texture'AW-2004Particles.Energy.SmoothRing'
     DrawScale=0.010000
     Skins(0)=Texture'AW-2004Particles.Energy.SmoothRing'
     Style=STY_Translucent
     FluidSurfaceShootStrengthMod=8.000000
     SoundVolume=50
     SoundRadius=100.000000
     CollisionRadius=15.000000
     CollisionHeight=15.000000
     bProjTarget=True
     bAlwaysFaceCamera=True
     ForceType=FT_Constant
     ForceRadius=40.000000
     ForceScale=5.000000
}
