class DEKSolarTurretEnergyWave extends Projectile;

var vector ShockwaveExtent;

var vector Origin;
var array<Actor> AlreadyHit;
var array<Actor> Shields;
var bool bBlueTeam;

replication
{
	reliable if (bNetInitial)
		bBlueTeam;
}


simulated function PreBeginPlay()
{
	Origin = Location;
	Super.PreBeginPlay();
	UpdateAppearance();
}

simulated function PostBeginPlay()
{
	if (Role == ROLE_Authority && Instigator != None && Instigator.Controller != None) {
		if (Instigator.Controller.ShotTarget != None && Instigator.Controller.ShotTarget.Controller != None)
			Instigator.Controller.ShotTarget.Controller.ReceiveProjectileWarning(Self);

		InstigatorController = Instigator.Controller;
	}

	Velocity = Speed * vector(Rotation);

	bReadyToSplash = True;
}

simulated function SetBlueEffects(bool bIsBlue)
{
	bBlueTeam = bIsBlue;
}

simulated function bool CanSplash()
{
	return False;
}

simulated function Tick(float DeltaTime)
{
	UpdateAppearance();

	// ensure really hitting actors after growing
	SetLocation(Location);
}

simulated function UpdateAppearance()
{
	local float Scale, NewHeight, NewRadius;
	local vector Extent;

	Scale = FClamp((default.LifeSpan - LifeSpan) / default.LifeSpan, 0.1, 1.0);

	SetDrawScale(default.DrawScale * Scale);
	LightRadius = default.LightRadius * Scale;

	Scale = Sqrt(FClamp(1.1 - 1.1 * Scale, 0.0, 1.0));
	LightBrightness = default.LightBrightness * Scale;

	// recalculate collision cylinder
	Extent = DrawScale * ((DrawScale3D * ShockwaveExtent) >> Rotation);
	NewHeight = Abs(Extent.Z);
	Extent.Z = 0;
	NewRadius = VSize(Extent);

	SetCollisionSize(NewRadius, NewHeight);
}

simulated function ClientSideTouch(Actor Other, Vector HitLocation);
simulated function Explode(vector HitLocation, vector HitNormal);
simulated function BlowUp(vector HitLocation);
simulated function HitWall(vector HitNormal, Actor Wall)
{
	log(Self@"HitWall"@HitNormal@Wall);
}

simulated singular function Touch(Actor Other)
{
	local vector HitLocation, HitNormal;

	if (Other == None) // Other just got destroyed in its touch?
		return;

	if (Other.bProjTarget || Other.bBlockActors)
	{
		LastTouched = Other;
		if (Velocity == vect(0,0,0) || Other.IsA('Mover'))
		{
			ProcessTouch(Other, Location);
			LastTouched = None;
			return;
		}

		if (Other.TraceThisActor(HitLocation, HitNormal, Other.Location, Location, vect(1,1,1)))
			HitLocation = Location;

		ProcessTouch(Other, HitLocation);
		LastTouched = None;
		if (Role < ROLE_Authority && Other.Role == ROLE_Authority && Pawn(Other) != None)
			ClientSideTouch(Other, HitLocation);
	}
}


simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	local int i;
	local RPGStatsInv StatsInv, HealerStatsInv;
	local float old_xp,cur_xp,xp_each,xp_diff,xp_given_away;
	local int DriverLevel;
    local Controller C;

	if ( Instigator != None && (Other == Instigator) )
		return;

    if (Other == Owner) return;

	if ( !Other.IsA('Projectile') || Other.bProjTarget )
	{
		if ( Role == ROLE_Authority )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Other.SetDelayedDamageInstigatorController( InstigatorController );

			// find the current dataobject
			if (DruidBallTurret(Instigator) != None && DruidBallTurret(Instigator).Driver != None)
			{
				StatsInv = RPGStatsInv(DruidBallTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None && StatsInv.DataObject != None)
				{
					old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
					DriverLevel = StatsInv.DataObject.Level;

					if (Level.TimeSeconds > DruidBallTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DruidBallTurret(Instigator).NumHealers > 0)
						Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DruidBallTurret(Instigator).NumHealers);
				}
			}

			Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);

			if (StatsInv != None && StatsInv.DataObject != None && DriverLevel == StatsInv.DataObject.Level)		// if the driver has levelled, then do not share xp
			{
				cur_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
				xp_diff = cur_xp - old_xp;
				if (xp_diff > 0 && DruidBallTurret(Instigator).NumHealers > 0)
//				if (xp_diff > 0 && Level.TimeSeconds > DruidBallTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DruidBallTurret(Instigator).NumHealers > 0)
				{
					// split the xp amongst the healers
					xp_each = class'RW_EngineerLink'.static.XPForLinker(xp_diff , DruidBallTurret(Instigator).Healers.length);
					xp_given_away = 0;

					for(i = 0; i < DruidBallTurret(Instigator).Healers.length; i++)
					{
						if (DruidBallTurret(Instigator).Healers[i].Pawn != None && DruidBallTurret(Instigator).Healers[i].Pawn.Health >0)
						{
						    C = DruidBallTurret(Instigator).Healers[i];
						    if (DruidLinkSentinelController(C) != None)
								HealerStatsInv = DruidLinkSentinelController(C).StatsInv;
						    else
								HealerStatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
							if (HealerStatsInv != None && HealerStatsInv.DataObject != None)
								HealerStatsInv.DataObject.AddExperienceFraction(xp_each, DruidBallTurret(Instigator).RPGMut, DruidBallTurret(Instigator).Healers[i].Pawn.PlayerReplicationInfo);
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
				// DruidBallTurret(Instigator).Healers.length = 0;	// we have just paid them, so scrub their names
			}
		}

		Explode(HitLocation, -Normal(Velocity));
	}
}

function bool EncroachingOn(Actor Other)
{
	return False;
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     ShockwaveExtent=(X=80.000000,Y=210.000000,Z=110.000000)
     Speed=2800.000000
     MaxSpeed=2800.000000
     Damage=115.000000
     MomentumTransfer=30000.000000
     MyDamageType=Class'DEKRPG208.DamTypeDEKSolarTurretHeatWave'
     LightType=LT_Steady
     LightEffect=LE_Spotlight
     LightHue=20
     LightSaturation=50
     LightBrightness=300.000000
     LightRadius=30.000000
     DrawType=DT_None
     StaticMesh=StaticMesh'DEKStaticsMaster207P.fX.SolarWave'
     bDynamicLight=True
     bIgnoreEncroachers=True
     LifeSpan=0.500000
     DrawScale=4.000000
     PrePivot=(X=210.000000)
     Skins(0)=FinalBlend'DEKRPGTexturesMaster207P.fX.ShieldHitOrangeEdgesFinal'
     Skins(1)=Texture'AW-2k4XP.Weapons.ElectricShockTex2'
     AmbientGlow=254
     bCollideWorld=False
     bIgnoreOutOfWorld=True
}
