class Meteor extends Projectile;

var FireBall FireBallEffect;
var	xEmitter SmokeTrail;
var config int BaseChance;

simulated event PreBeginPlay()
{
    Super.PreBeginPlay();

    if( Pawn(Owner) != None )
        Instigator = Pawn( Owner );
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
	{
        FireBallEffect = Spawn(class'FireBall', self);
        FireBallEffect.SetBase(self);
        SmokeTrail = Spawn(class'BelchFlames',self);
	}

	//Velocity = Speed * Vector(Rotation); 

    SetTimer(0.4, false);
}

simulated function PostNetBeginPlay()
{
	local PlayerController PC;
	
	Super.PostNetBeginPlay();
	
	if ( Level.NetMode == NM_DedicatedServer )
		return;
		
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
}

function Timer()
{
    SetCollisionSize(20, 20);
}

simulated function Destroyed()
{
    if (FireBallEffect != None)
    {
		if ( bNoFX )
			FireBallEffect.Destroy();
		else
			FireBallEffect.Kill();
	}
	if ( SmokeTrail != None )
		SmokeTrail.mRegen = False;
	Super.Destroyed();
}

simulated function DestroyTrails()
{
    if (FireBallEffect != None)
        FireBallEffect.Destroy();
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
			
	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) ) 
		Explode(HitLocation,Normal(HitLocation-Other.Location));
}
					
simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;
	local bool VictimPawn;

	if ( bHurtEntry )
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Victims != InstigatorController.Pawn) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo') )
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			if ( Instigator == None || Instigator.Controller == None )
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
			if ( Victims == LastTouched )
				LastTouched = None;
			VictimPawn = false;
			if (Pawn(Victims) != None)
			{
				VictimPawn = true;
			}
			Victims.TakeDamage
			(
				damageScale * DamageAmount,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * Momentum * dir),
				MyDamageType
			);
			//now see if we killed it
			if (VictimPawn)
			{
				if (Victims == None || Pawn(Victims) == None || Pawn(Victims).Health <= 0 )
					class'ArtifactLightningBeam'.static.AddArtifactKill(Instigator, class'WeaponMeteor');	// assume killed
			}
			if (Victims != None)
			{
				if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
					Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, MyDamageType, Momentum, HitLocation);
			}
		}
	}
	if ( (LastTouched != None) && (LastTouched != self) && (LastTouched.Role == ROLE_Authority) && !LastTouched.IsA('FluidSurfaceInfo') )
	{
		Victims = LastTouched;
		LastTouched = None;
		dir = Victims.Location - HitLocation;
		dist = FMax(1,VSize(dir));
		dir = dir/dist;
		damageScale = FMax(Victims.CollisionRadius/(Victims.CollisionRadius + Victims.CollisionHeight),1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius));
		if ( Instigator == None || Instigator.Controller == None )
			Victims.SetDelayedDamageInstigatorController(InstigatorController);
		VictimPawn = false;
		if (Pawn(Victims) != None)
		{
			VictimPawn = true;
		}
		Victims.TakeDamage
		(
			damageScale * DamageAmount,
			Instigator,
			Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
			(damageScale * Momentum * dir),
			MyDamageType
		);
		//now see if we killed it
		if (VictimPawn)
		{
			if (Victims == None || Pawn(Victims) == None || Pawn(Victims).Health <= 0 )
				class'ArtifactLightningBeam'.static.AddArtifactKill(Instigator, class'WeaponMeteor');	// assume killed
		}
		if (Victims != None)
		{
			if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, MyDamageType, Momentum, HitLocation);
		}
	}

	bHurtEntry = false;
}

function NullInBlast(float Radius)
{
	local float damageScale, pawndist;
	local vector pawndir;
	local Controller C, NextC;
	Local SuperHeatInv Inv;
	local MagicShieldInv MInv;

	// freezes anything not a null warlord. Any side.
	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;
		if(C.Pawn == None)
		{
			C = NextC;
			break;
		}
		MInv = MagicShieldInv(C.Pawn.FindInventoryType(class'MagicShieldInv'));
		if ( C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.SameTeamAs(InstigatorController)
		     && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) && MInv == None )
		{
			pawndir = C.Pawn.Location - Location;
			pawndist = FMax(1,VSize(pawndir));
			damageScale = 1 - FMax(0,pawndist/Radius);

			if(!C.Pawn.isA('Vehicle') && class'RW_Freeze'.static.canTriggerPhysics(C.Pawn) && (C.Pawn.FindInventoryType(class'SuperHeatInv') == None))
			{
				if(C.Pawn == None)
				{
					C = NextC;
					break;
				}
				if(rand(99) <= BaseChance)
				{
					Inv = spawn(class'SuperHeatInv', C.Pawn,,, rot(0,0,0));
					if(Inv != None)
					{
						Inv.LifeSpan = 4;	
						Inv.Modifier = 3;
						Inv.GiveTo(C.Pawn);
					}
				}
			}
			if(C.Pawn == None)
			{
				C = NextC;
				break;
			}
		}
		C = NextC;
	}
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	local PlayerController PC;
	
	PlaySound(sound'ONSVehicleSounds-S.Explosions.Explosion08',,3.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'NewExplosionA',,,HitLocation + HitNormal*20,rotator(HitNormal));
    	PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5000 )
		{
			Spawn(class'MeteorExplosion',,, HitLocation + HitNormal*20, rotator(HitNormal));
		}
	}
    if ( Role == ROLE_Authority )
    {
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    }
	NullInBlast(DamageRadius);
	SetCollisionSize(0.0, 0.0);
	Destroy();
}

defaultproperties
{
	 bCanBeDamaged=False
     Physics=PHYS_Falling
     BaseChance=80
     Speed=0.000000
     MaxSpeed=0.000000
     bSwitchToZeroCollision=True
     Damage=150.000000
	 DamageRadius=550.0000
     MomentumTransfer=70000.000000
     MyDamageType=Class'DEKRPG208.DamTypeMeteor'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     ExplosionDecal=Class'XEffects.RocketMark'
     MaxEffectDistance=7000.000000
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=30
     LightSaturation=135
     LightBrightness=255.000000
     LightRadius=10.000000
     DrawType=DT_Sprite
     CullDistance=4000.000000
     bDynamicLight=True
     bOnlyDirtyReplication=True
     AmbientSound=Sound'ONSBPSounds.Artillery.ShellIncoming1'
     LifeSpan=10.000000
     Texture=Texture'AW-2004Particles.Fire.NapalmSpot'
     DrawScale=0.30000
     Skins(0)=Texture'XEffects.Skins.MuzFlashWhite_t'
     Style=STY_Translucent
     FluidSurfaceShootStrengthMod=8.000000
     SoundVolume=50
     SoundRadius=100.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     bProjTarget=True
     bAlwaysFaceCamera=True
     ForceType=FT_Constant
     ForceRadius=40.000000
     ForceScale=5.000000
}
