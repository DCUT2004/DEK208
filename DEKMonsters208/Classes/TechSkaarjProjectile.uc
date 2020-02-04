class TechSkaarjProjectile extends FlakShell;

#exec obj load file=GeneralAmbience.uax

var(Minibolts)  float           MiniboltInterval;
var(Minibolts)  int             MiniboltDamage;
var(Minibolts)  float            MiniboltRadius;
var(Minibolts)  class<DamageType> MiniboltDamageType;
var config float BaseChance;

simulated function PostNetBeginPlay()
{
    SetTimer(MiniboltInterval, true);

    super.PostNetBeginPlay();
}

event Timer()
{
    local Actor Victim;
    local vector Direction;
    local float Distance;
    local vector HitLocation;
    local vector Momentum;
    local TechBolt Bolt;
    local float BeamLength;

	if(rand(99) < int(BaseChance))
	{
		foreach VisibleCollidingActors(class'Actor', Victim, MiniboltRadius, Location)
		{
			if(Victim != self && (Victim.IsA('AutoGun') || Victim.IsA('DEKBeamSentinel') || Victim.IsA('DEKCeilingBeamSentinel') || Victim.IsA('DEKMercurySentinel') || Victim.IsA('DEKCeilingMercurySentinel') || Victim.IsA('DEKLynxTurret') || Victim.IsA('DEKOdinTurret') || Victim.IsA('DEKSolarTurret') || Victim.IsA('DEKStingerSentinel') || Victim.IsA('DruidAddLinkSentinel') || Victim.IsA('DruidBallTurret') || Victim.IsA('DEKCeilingDefenseSentinel') || Victim.IsA('DEKCeilingDefenseSentinelCrimbo') || Victim.IsA('DruidCeilingLightningSentinel') || Victim.IsA('DruidCeilingSentinel') || Victim.IsA('DruidDefenseSentinel') || Victim.IsA('DruidEnergyTurret') || Victim.IsA('DruidEnergyWall') || Victim.IsA('DruidLightningSentinel') || Victim.IsA('DruidLinkSentinel') || Victim.IsA('DruidMinigunTurret') || Victim.IsA('DruidSentinel') || Victim.IsA('DEKDamageSentinel') && Victim != Instigator))
			{
				Direction = Victim.Location - HitLocation;
				Distance = FMax(1, VSize(Direction));
				Direction = Direction / Distance;
				HitLocation = Victim.Location - Direction * 0.5 * (Victim.CollisionHeight + Victim.CollisionRadius);
				Momentum = Direction * MomentumTransfer;

				BeamLength = VSize(Location - HitLocation);

				Bolt = Spawn(class'TechBolt',,, Location, rotator(HitLocation - Location));
				if (Bolt != None)
				{
					BeamEmitter(Bolt.Emitters[0]).BeamDistanceRange.Min = BeamLength;
					BeamEmitter(Bolt.Emitters[0]).BeamDistanceRange.Max = BeamLength;
					Bolt.SpawnEffects(Victim, HitLocation, Direction * -1);
					Bolt.SetBase(self);
					Bolt.RemoteRole = ROLE_SimulatedProxy;
				}

				Bolt.SpawnEffects(Victim, HitLocation, Direction * -1);

				// Attach the bolt to the ball and to the target?
				Bolt.SetBase(self);

				// Deal damage.
				Victim.TakeDamage(MiniboltDamage, Instigator, HitLocation, Momentum, MiniboltDamageType);
			}
		}
	}
}

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;
	local int TakePercent, DamageVictimAdjust;
	local int OldHealth, HealthTaken;

	if ( bHurtEntry )
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo') )
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			if ( Instigator == None || Instigator.Controller == None )
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
			if ( Victims == LastTouched )
				LastTouched = None;
				
            OldHealth = 0;
            DamageVictimAdjust = 1;
			if (Pawn(Victims) != None)
			{
			    OldHealth = Pawn(Victims).Health;
		        TakePercent = 0;
			    if (DruidBlock(Victims) != None && !Victims.IsA('TarydiumCrystal'))
			    {
		            DamageVictimAdjust = 10;
		            TakePercent = 25;
				}
				else if (vehicle(Victims) != None)
				{
		            DamageVictimAdjust = 5;
		            TakePercent = 10;
				}
			}

			Victims.TakeDamage
			(
				damageScale * DamageAmount * DamageVictimAdjust,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * Momentum * dir),
				DamageType
			);
			if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
			if (OldHealth > 0)
			{
			    // means this one was a pawn
			    if (Victims == None || Pawn(Victims).Health <= 0)
			        HealthTaken = OldHealth;
				else
				    HealthTaken = OldHealth - Pawn(Victims).Health;
				if (HealthTaken < 0)
				    HealthTaken = 0;
				// now take some health back
				if (HealthTaken > 0 && Instigator != None)
				{
					HealthTaken = max((HealthTaken * TakePercent)/100.0, 1);
					Instigator.GiveHealth(HealthTaken, Instigator.HealthMax);
				}
			}

		}
	}

	bHurtEntry = false;
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	local PlayerController PC;

	PlaySound (Sound'WeaponSounds.BExplosion1',,1*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
		PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 3000 )
			spawn(class'FlakExplosion',,,HitLocation + HitNormal*16 );
		spawn(class'FlashExplosion',,,HitLocation + HitNormal*16 );
		//spawn(class'RocketSmokeRing',,,HitLocation + HitNormal*16, rotator(HitNormal) );
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if ( Role == ROLE_Authority )
	{
		HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);	
	}
    Destroy();
}

defaultproperties
{
     MiniboltInterval=0.750000
     MiniboltDamage=25
     MiniboltRadius=1200.000000
     BaseChance=33.000000
     Speed=1000.000000
     MaxSpeed=1000.000000
     TossZ=0.000000
     Damage=30.000000
     DamageRadius=150.000000
     MomentumTransfer=1000.000000
     MyDamageType=Class'DEKMonsters208.DamTypeTechSkaarj'
     ImpactSound=SoundGroup'WeaponSounds.BioRifle.BioRifleGoo2'
     LightHue=120
     LightSaturation=250
     Physics=PHYS_Flying
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.TechMonsters.TechProjFB'
}
