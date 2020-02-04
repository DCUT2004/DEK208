class TechWarlordShell extends FlakShell;

#exec obj load file=GeneralAmbience.uax

var(Minibolts)  float           MiniboltInterval;
var(Minibolts)  int             MiniboltDamage;
var(Minibolts)  float             MiniboltRadius;
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

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other != Instigator )
	{
		SpawnEffects(HitLocation, -1 * Normal(Velocity) );
		Kaboom(HitLocation,Normal(HitLocation-Other.Location));
	}
}

simulated function Landed( vector HitNormal )
{
	SpawnEffects( Location, HitNormal );
	Kaboom(Location,HitNormal);
}

simulated function Kaboom(vector HitLocation, vector HitNormal)
{
	local vector start;

	start = Location + 10 * HitNormal;
	if ( Role == ROLE_Authority )
	{
		HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);	
	}
    Destroy();
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
// do nothing. Bypass defense sentinels which calls in explode function for projectiles.
}

defaultproperties
{
     MiniboltInterval=2.000000
     MiniboltDamage=50
     MiniboltRadius=1800.000000
     MiniboltDamageType=Class'DEKMonsters208.DamTypeTechWarlord'
     Speed=1500.000000
     TossZ=330.000000
     Damage=45.000000
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.TechMonsters.TechProjFB'
}
