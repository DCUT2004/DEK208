class DEKPlasmaTurretBallProj extends Projectile;

#exec  AUDIO IMPORT NAME="PlasmaTurretBallAmb" FILE="C:\UT2004\Sounds\PlasmaTurretBallAmb.WAV" GROUP="TurretSounds"
#exec  AUDIO IMPORT NAME="PlasmaTurretBallExplode" FILE="C:\UT2004\Sounds\PlasmaTurretBallExplode.WAV" GROUP="TurretSounds"

var vector initialDir;
var class<Emitter>  ProjectileEffectClass;
var Emitter         ProjectileEffect;
var class<xEmitter> HitEmitterClass;
var class<Emitter>  ExplosionEmitterClass;
var bool bEffects;
//var byte Team;

simulated function PostBeginPlay()
{
    local Rotator R;

    if (Level.NetMode != NM_DedicatedServer)
    {
        ProjectileEffect = spawn(ProjectileEffectClass, self,, Location, Rotation);
        ProjectileEffect.SetBase(self);
    }

    Super.PostBeginPlay();

    Velocity = Speed * Vector(Rotation);
    R = Rotation;
    R.Roll = 32768;
    SetRotation(R);
    Velocity.z += TossZ;
    initialDir = Velocity;
    
    /*
    if (Instigator != None)
       Team = Instigator.GetTeamNum();
    */

    bEffects = false;
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if ( Other != Instigator )
	{
		SpawnEffects(HitLocation, -1 * Normal(Velocity) );
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}

simulated function Landed( vector HitNormal )
{
	SpawnEffects( Location, HitNormal );
	Explode(Location,HitNormal);
}

simulated function HitWall (vector HitNormal, actor Wall)
{
    Landed(HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local RPGStatsInv StatsInv, HealerStatsInv;
	local float old_xp,cur_xp,xp_each,xp_diff,xp_given_away;
	local int i;
    local int DriverLevel;
    local Controller C;
	local Actor Other;

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
			if (DEKPlasmaTurret(Instigator) != None && DEKPlasmaTurret(Instigator).Driver != None)
			{
				StatsInv = RPGStatsInv(DEKPlasmaTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None && StatsInv.DataObject != None)
				{
					old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
					DriverLevel = StatsInv.DataObject.Level;

					if (Level.TimeSeconds > DEKPlasmaTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKPlasmaTurret(Instigator).NumHealers > 0)
					{
						Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKPlasmaTurret(Instigator).NumHealers);
						DamageRadius = DamageRadius * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKPlasmaTurret(Instigator).NumHealers);
					}
				}
			}

			//Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);
			HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

			if (StatsInv != None && StatsInv.DataObject != None && DriverLevel == StatsInv.DataObject.Level)		// if the driver has levelled, then do not share xp
			{
				cur_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
				xp_diff = cur_xp - old_xp;
				if (xp_diff > 0 && DEKPlasmaTurret(Instigator).NumHealers > 0)
//				if (xp_diff > 0 && Level.TimeSeconds > DEKPlasmaTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKPlasmaTurret(Instigator).NumHealers > 0)
				{
					// split the xp amongst the healers
					xp_each = class'RW_EngineerLink'.static.XPForLinker(xp_diff , DEKPlasmaTurret(Instigator).Healers.length);
					xp_given_away = 0;

					for(i = 0; i < DEKPlasmaTurret(Instigator).Healers.length; i++)
					{
						if (DEKPlasmaTurret(Instigator).Healers[i].Pawn != None && DEKPlasmaTurret(Instigator).Healers[i].Pawn.Health >0)
						{
						    C = DEKPlasmaTurret(Instigator).Healers[i];
						    if (DruidLinkSentinelController(C) != None)
								HealerStatsInv = DruidLinkSentinelController(C).StatsInv;
						    else
								HealerStatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
							if (HealerStatsInv != None && HealerStatsInv.DataObject != None)
								HealerStatsInv.DataObject.AddExperienceFraction(xp_each, DEKPlasmaTurret(Instigator).RPGMut, DEKPlasmaTurret(Instigator).Healers[i].Pawn.PlayerReplicationInfo);
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
				// DEKPlasmaTurret(Instigator).Healers.length = 0;	// we have just paid them, so scrub their names
			}
		}
	}
	Destroy();
}

simulated function Destroyed()
{
    if (ProjectileEffect != None)
        ProjectileEffect.Destroy();

    Super.Destroyed();
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	local PlayerController PC;
	
	PlaySound(ImpactSound,,3.5*TransientSoundVolume);
	
    if ( EffectIsRelevant(Location,false) )
    {
		PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 3000 )
		{
			spawn(ExplosionEmitterClass,,,Location);
			spawn(class'ShockComboFlash',,,Location);
		}

        if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
            Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
    }
}

defaultproperties
{
     ProjectileEffectClass=Class'DEKRPG208.DEKPlasmaTurretBallFX'
     ExplosionEmitterClass=Class'Onslaught.ONSPlasmaHitPurple'
     Speed=1200.000000
     TossZ=225.000000
     Damage=200.000000
     DamageRadius=330.000000
     MomentumTransfer=50000.000000
     MyDamageType=Class'DEKRPG208.DamTypePlasmaTurretBall'
     ImpactSound=Sound'DEKRPG208.TurretSounds.PlasmaTurretBallExplode'
     ExplosionDecal=Class'Onslaught.ONSRocketScorch'
     CullDistance=4000.000000
     Physics=PHYS_Falling
     AmbientSound=Sound'DEKRPG208.TurretSounds.PlasmaTurretBallAmb'
     LifeSpan=3.000000
     DrawScale=0.300000
     AmbientGlow=100
     SoundVolume=255
     SoundRadius=100.000000
     bProjTarget=True
     bFixedRotationDir=True
     DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
     ForceType=FT_Constant
     ForceRadius=60.000000
     ForceScale=5.000000
}
