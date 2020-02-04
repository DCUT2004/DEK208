class DEKStingerTurretProj extends Projectile;

var(Sounds) sound MiscSound;
var bool bDoTheExp;
var float LightAnimTime;
var byte Bounces;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        Bounces;
}

simulated function PostBeginPlay()
{
    local float r;

    Velocity = Vector(Rotation) * (Speed);
    if (PhysicsVolume.bWaterVolume)
        Velocity *= 0.65;

    r = FRand();

    SetRotation(RotRand());

    Super.PostBeginPlay();
}

simulated function ProcessTouch( Actor Other, Vector HitLocation )
{
	local vector hitDir;
	local RPGStatsInv StatsInv, HealerStatsInv;
	local float old_xp,cur_xp,xp_each,xp_diff,xp_given_away;
	local int i;
    local int DriverLevel;
    local Controller C;

	if ( Instigator != None && (Other == Instigator) )
		return;

    if (Other == Owner) return;

	if ( Other != Instigator && DEKStingerTurretProj(Other) == None && (!Other.IsA('Projectile') || Other.bProjTarget) )
	{
		if ( Role == ROLE_Authority )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Other.SetDelayedDamageInstigatorController( InstigatorController );
				
			hitDir = Normal(Velocity);
			if ( FRand() < 0.2 )
				hitDir *= 5;

			// find the current dataobject
			if (DEKStingerTurret(Instigator) != None && DEKStingerTurret(Instigator).Driver != None)
			{
				StatsInv = RPGStatsInv(DEKStingerTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None && StatsInv.DataObject != None)
				{
					old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
					DriverLevel = StatsInv.DataObject.Level;

					if (Level.TimeSeconds > DEKStingerTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKStingerTurret(Instigator).NumHealers > 0)
						Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKStingerTurret(Instigator).NumHealers);
				}
			}

			Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);

			if (StatsInv != None && StatsInv.DataObject != None && DriverLevel == StatsInv.DataObject.Level)		// if the driver has levelled, then do not share xp
			{
				cur_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
				xp_diff = cur_xp - old_xp;
				if (xp_diff > 0 && DEKStingerTurret(Instigator).NumHealers > 0)
//				if (xp_diff > 0 && Level.TimeSeconds > DEKStingerTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKStingerTurret(Instigator).NumHealers > 0)
				{
					// split the xp amongst the healers
					xp_each = class'RW_EngineerLink'.static.XPForLinker(xp_diff , DEKStingerTurret(Instigator).Healers.length);
					xp_given_away = 0;

					for(i = 0; i < DEKStingerTurret(Instigator).Healers.length; i++)
					{
						if (DEKStingerTurret(Instigator).Healers[i].Pawn != None && DEKStingerTurret(Instigator).Healers[i].Pawn.Health >0)
						{
						    C = DEKStingerTurret(Instigator).Healers[i];
						    if (DruidLinkSentinelController(C) != None)
								HealerStatsInv = DruidLinkSentinelController(C).StatsInv;
						    else
								HealerStatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
							if (HealerStatsInv != None && HealerStatsInv.DataObject != None)
								HealerStatsInv.DataObject.AddExperienceFraction(xp_each, DEKStingerTurret(Instigator).RPGMut, DEKStingerTurret(Instigator).Healers[i].Pawn.PlayerReplicationInfo);
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
				// DEKStingerTurret(Instigator).Healers.length = 0;	// we have just paid them, so scrub their names
			}
		}
	}
	Destroy();
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	local vector RealHitNormal;
	local int HitDamage;


	if ( !Wall.bStatic && !Wall.bWorldGeometry
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
	{
		if ( Level.NetMode != NM_Client )
		{
			Hitdamage = Damage * 0.00002 * (DrawScale**3) * speed;
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );
			Wall.TakeDamage( Hitdamage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
	}

	speed = VSize(velocity);
	if (Bounces > 0 && speed>100)
	{
		PlaySound(ImpactSound, SLOT_Interact, DrawScale/10);
		SetPhysics(PHYS_Falling);
		RealHitNormal = HitNormal;
		if ( FRand() < 0.5 )
			RotationRate.Pitch = Max(RotationRate.Pitch, 100000);
		else
			RotationRate.Roll = Max(RotationRate.Roll, 100000);
		HitNormal = Normal(HitNormal + 0.5 * VRand());
		if ( (RealHitNormal Dot HitNormal) < 0 )
			HitNormal.Z *= -0.7;
		Velocity = 0.7 * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
		DesiredRotation = rotator(HitNormal);

		//if ( speed > 250)
		//	SpawnChunks(4);
		Bounces = Bounces - 1;
		return;
	}
	if (Speed < 100)
		Destroy();
	bFixedRotationDir=false;
	bBounce = false;
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	//log ("Rock gets hit by something...");

	if (InstigatedBy == None)
		return;
	if (Damage < 10)
		return;
	Velocity += Momentum/(DrawScale * 10);
	if (Physics == PHYS_None )
	{
		SetPhysics(PHYS_Falling);
		Velocity.Z += 0.4 * VSize(momentum);
	}
	//if ( 2 < DrawScale )
	//	SpawnChunks(4);
}

function SpawnChunks(int num)
{
	local int NumChunks,i;
	local DEKStingerTurretProj TempShard;
	local float pscale;

	if ( DrawScale < 2 + FRand()*2 )
		return;
	if(Level.Game.IsA('Invasion') && DrawScale < 1 + FRand()*2)
		return;


	NumChunks = 1+Rand(num);
	pscale = sqrt(0.52/NumChunks);
	if ( pscale * DrawScale < 1 )
	{
		NumChunks *= pscale * DrawScale;
		pscale = 1/DrawScale;
	}
	speed = VSize(Velocity);
	for (i=0; i<NumChunks; i++)
	{
		TempShard = Spawn(class'DEKStingerTurretProj');
        if (TempShard != None )
			TempSHard.InitFrag(self, pscale);
	}
	InitFrag(self, 0.5);
}

function InitFrag(DEKStingerTurretProj myParent, float Pscale)
{
	RotationRate = RotRand();
	Pscale *= (0.5 + FRand());
	SetDrawScale(Pscale * myParent.DrawScale);
	if ( DrawScale <= 1 )
	{
		SetCollisionSize(0,0);
		RemoteRole=ROLE_None;
		bNotOnDedServer=True;
	}
	else
		SetCollisionSize(CollisionRadius * DrawScale/Default.DrawScale, CollisionHeight * DrawScale/Default.DrawScale);
	Velocity = Normal(VRand() + myParent.Velocity/myParent.speed)
				* (myParent.speed * (0.4 + 0.3 * (FRand() + FRand())));
}

defaultproperties
{
     MiscSound=Sound'WeaponSounds.BaseImpactAndExplosions.BBulletImpact9'
     LightAnimTime=0.700000
     Bounces=6
     Speed=6000.000000
     Damage=25.000000
     MomentumTransfer=4000.000000
     MyDamageType=Class'DEKRPG208.DamTypeStingerTurret'
     ImpactSound=Sound'WeaponSounds.BaseImpactAndExplosions.BBulletImpact9'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=152
     LightSaturation=32
     LightBrightness=5.000000
     LightRadius=1.000000
     LightPeriod=10
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DEKStaticsMaster207P.Meshes.CrystalA'
     bDynamicLight=True
     LifeSpan=4.000000
     LODBias=7.000000
     DrawScale=2.500000
     DrawScale3D=(X=0.437500,Y=0.437500,Z=0.437500)
     AmbientGlow=15
     bBounce=True
}
