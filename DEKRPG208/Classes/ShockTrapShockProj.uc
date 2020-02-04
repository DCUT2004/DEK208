//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ShockTrapShockProj extends Projectile;

var Emitter LightningGlow;
var float MiniboltInterval;
var int MiniboltDamage;
var int MiniboltRadius;
var class<Emitter>  MiniboltClass;
var class<DamageType> MiniboltDamageType;
var(Trail) Emitter Trail;
var(Trail) class<Emitter>  TrailClass;

/** Detonation: Prevent impact on other projectiles. */

simulated event PreBeginPlay()
{
    Super.PreBeginPlay();

    if( Pawn(Owner) != None )
        Instigator = Pawn( Owner );
}

/** Minibolts: Start the process. */
simulated function PostNetBeginPlay()
{
	local PlayerController PC;
	
    SetTimer(MiniboltInterval, true);
		
	PC = Level.GetLocalPlayerController();
	if ( (Instigator != None) && (PC == Instigator.Controller) )
		return;
	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	else if ( (PC == None) || (PC.ViewTarget == None) || (VSize(PC.ViewTarget.Location - Location) > 3000) )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}

    super.PostNetBeginPlay();
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
	{
		Trail = Spawn(TrailClass, self);
		Trail.SetBase(self);
	}
}

simulated function Destroyed()
{
    if (Trail != None)
    {
		if ( bNoFX )
			Trail.Destroy();
		else
			Trail.Kill();
	}
	
	Super.Destroyed();
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
   	PlaySound(ImpactSound, SLOT_Misc, 1.5*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
	    Spawn(class'ShockExplosionCore',,, Location);
		if ( !Level.bDropDetail && (Level.DetailMode != DM_Low) )
			Spawn(class'ShockExplosion',,, Location);
	}
    SetCollisionSize(0.0, 0.0);
	Destroy();
}

/** Minibolts: Spawn a minibolt. */
event Timer()
{
    local Actor Victim;
	local Pawn P;
    local vector Direction;
    local float Distance;
    local vector HitLocation;
    local vector Momentum;
    local ShockTrapShockProjMiniBolt Bolt;
    local float BeamLength;

    // Zap all nearby targets.
    foreach VisibleCollidingActors(class'Actor', Victim, MiniboltRadius, Location)
    {
		P = Pawn(Victim);
        if(Victim.Role == ROLE_Authority && Victim != self && Victim != None && P != None && P.Controller != None && ( Victim != Instigator || P != Instigator || P != Instigator.Controller) && (Victim.IsA('Pawn') || Victim.IsA('ONSPowerCore') || Victim.IsA('DestroyableObjective')) && P.Health > 0 && !P.Controller.SameTeamAs(Instigator.Controller))
        {
            Direction = Victim.Location - HitLocation;
            Distance = FMax(1, VSize(Direction));
            Direction = Direction / Distance;
            HitLocation = Victim.Location - Direction * 0.5 * (Victim.CollisionHeight + Victim.CollisionRadius);
            Momentum = Direction * MomentumTransfer;

            BeamLength = VSize(Location - Victim.Location);

            Bolt = Spawn(class'ShockTrapShockProjMinibolt',,, Location, rotator(Victim.Location - Location));
			if (Bolt != None)
			{
				BeamEmitter(Bolt.Emitters[0]).BeamDistanceRange.Min = BeamLength;
				BeamEmitter(Bolt.Emitters[0]).BeamDistanceRange.Max = BeamLength;
				Bolt.RemoteRole = ROLE_SimulatedProxy;
				Bolt.SpawnEffects(P, HitLocation, Direction * -1);

				// Attach the bolt to the ball and to the target?
				Bolt.SetBase(self);
			}

            // Deal damage.
            Victim.TakeDamage(MiniboltDamage, Instigator, HitLocation, Momentum, MiniboltDamageType);
        }
    }
}

simulated function tick ( float DeltaTime)
{
	if (Instigator.DrivenVehicle != None)
		Reset();
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	//do nothing. We don't want people getting sucked in to explode the projectile right away. Have it suck in players, then explode when the timer calls it.
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	// Can't hurt it.
}

// Commented out properties are default in Projectile.

defaultproperties
{
     MiniboltInterval=0.500000
     MiniboltDamage=10
     MiniboltRadius=800
     MiniboltClass=Class'DEKRPG208.ShockTrapShockProjMinibolt'
     MiniboltDamageType=Class'DEKRPG208.DamTypeShockTrapShock'
     TrailClass=Class'DEKRPG208.ShockTrapShockProjTrail'
     DamageRadius=0.000000
     MomentumTransfer=8000.000000
     MyDamageType=Class'DEKRPG208.DamTypeShockTrap'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=195
     LightSaturation=85
     LightBrightness=190.000000
     LightRadius=2.000000
     DrawType=DT_Sprite
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.ShockRifle.ShockRifleProjectile'
     LifeSpan=5.000000
     Texture=Texture'XEffectMat.Shock.shock_core_low'
     Style=STY_Translucent
     bAlwaysFaceCamera=True
}
