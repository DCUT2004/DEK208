class UpgradeFlakChunk extends Projectile;

var xEmitter Trail;
var() class<DamageType>	DamageTypeHeadShot;
var() float	DamageAtten;
var bool bBounced; // set after the first bounce - needed for self damaging
var sound ImpactSounds[6];
var byte Bounces;

simulated function PostBeginPlay()
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {
            Trail = Spawn(class'FlakTrail',self);
            Trail.Lifespan = Lifespan;
        }
            
    }

	Velocity=Speed*Vector(Rotation);

	if (PhysicsVolume.bWaterVolume)
        Velocity *= 0.65;

	Super.PostBeginPlay();
}

simulated function Destroyed()
{
    if (Trail !=None) Trail.mRegen=False;
	Super.Destroyed();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if ( (UpgradeFlakChunk(Other) == None) && ((bBounced) || (Other != Instigator)) )
	{
        	speed = VSize(Velocity);
	        if ( speed > 200 )
        	{
		        if ( Role == ROLE_Authority )
					if (!Other.bWorldGeometry)
					{
						Other.TakeDamage(Max(5, Damage - DamageAtten*FMax(0,(default.LifeSpan - LifeSpan - 1))), Instigator, HitLocation, (MomentumTransfer * Velocity/speed), MyDamageType);
					}
        	}
		Destroy();
	}
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    if ( !Wall.bStatic && !Wall.bWorldGeometry 
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
    {
        if ( Level.NetMode != NM_Client )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );
            Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
        Destroy();
        return;
    }

	bBounced = True;
	
	if (Bounces > 0)
    {
		if ( !Level.bDropDetail && (FRand() < 0.4) )
			Playsound(ImpactSounds[Rand(6)]);

		//SetRotation(rotator(Velocity));
        Velocity = 0.75 * (Velocity - 2.0*HitNormal*(Velocity dot HitNormal));
        Bounces = Bounces - 1;
        return;
    }
	
	bBounce = false;
}

simulated function PhysicsVolumeChange( PhysicsVolume Volume )
{
	if (Volume.bWaterVolume)
	{
        	if ( Trail != None )
		Trail.Destroy();

        	Velocity *= 0.65;
	}
}

defaultproperties
{
	 Bounces=4
     DamageAtten=5.000000
     ImpactSounds(0)=Sound'XEffects.Impact4Snd'
     ImpactSounds(1)=Sound'XEffects.Impact6Snd'
     ImpactSounds(2)=Sound'XEffects.Impact7Snd'
     ImpactSounds(3)=Sound'XEffects.Impact3'
     ImpactSounds(4)=Sound'XEffects.Impact1'
     ImpactSounds(5)=Sound'XEffects.Impact2'
     Speed=2500.000000
     MaxSpeed=2700.000000
     Damage=16.714285
     MomentumTransfer=10000.000000
     MyDamageType=Class'XWeapons.DamTypeFlakChunk'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
     CullDistance=3000.000000
     LifeSpan=3.700000
     DrawScale=14.000000
     AmbientGlow=254
     Style=STY_Alpha
     bBounce=True
}
