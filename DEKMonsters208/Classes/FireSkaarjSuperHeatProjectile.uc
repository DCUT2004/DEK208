class FireSkaarjSuperHeatprojectile extends Projectile;

var FireSkaarjSuperHeatFireBall FireBallEffect;
//var	xEmitter SmokeTrail;
var Material ModifierOverlay;
var config float BaseChance;
var float HeatLifeSpan;

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
        FireBallEffect = Spawn(class'FireSkaarjSuperHeatFireball', self);
        FireBallEffect.SetBase(self);
        //SmokeTrail = Spawn(class'BelchFlames',self);
	}

	Velocity = Speed * Vector(Rotation); 
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

simulated function Destroyed()
{
    if (FireBallEffect != None)
    {
		if ( bNoFX )
			FireBallEffect.Destroy();
		else
			FireBallEffect.Kill();
	}
	//if ( SmokeTrail != None )
		//SmokeTrail.mRegen = False;
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
    local Vector X, RefNormal, RefDir;

	if (Other == Instigator) return;
    if (Other == Owner) return;

    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
    {
        if (Role == ROLE_Authority)
        {
            X = Normal(Velocity);
            RefDir = X - 2.0*RefNormal*(X dot RefNormal);
            RefDir = RefNormal;
            Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
        }
        DestroyTrails();
        Destroy();
    }
    else if ( !Other.IsA('Projectile') || Other.bProjTarget )
    {
		Explode(HitLocation, Normal(HitLocation-Other.Location));
    }
}

function BlowUp(vector HitLocation)
{
	Super.BlowUp(HitLocation);
	// ok, lets null them according to how close to the centre they are
	NullInBlast(DamageRadius);
}

function NullInBlast(float Radius)
{
	local float damageScale, pawndist;
	local vector pawndir;
	local Controller C, NextC;
	Local SuperHeatInv Inv;

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
		if ( C != None && C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.SameTeamAs(InstigatorController) && !C.Pawn.IsA('FireBrute') && !C.Pawn.IsA('FireChildGasbag') && !C.Pawn.IsA('FireChildSkaarjPupae') && !C.Pawn.IsA('FireGasbag') && !C.Pawn.IsA('FireGiantGasbag') && !C.Pawn.IsA('FireKrall') && !C.Pawn.IsA('FireLord') && !C.Pawn.IsA('FireManta') && !C.Pawn.IsA('FireMercenary') && !C.Pawn.IsA('FireNali') && !C.Pawn.IsA('FireNaliFighter') && !C.Pawn.IsA('FireQueen') && !C.Pawn.IsA('FireRazorfly') && !C.Pawn.IsA('FireSkaarjPupae') && !C.Pawn.IsA('FireSkaarjSniper') && !C.Pawn.IsA('FireSkaarjTrooper') && !C.Pawn.IsA('FireSkaarjSuperHeat') && !C.Pawn.IsA('FireSlith') && !C.Pawn.IsA('FireSlug') && !C.Pawn.IsA('FireTitan')  && !C.Pawn.IsA('FireTentacle')
		     && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) && MagicShieldInv(C.Pawn.FindInventoryType(class'MagicShieldInv')) == None )
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
				if(rand(99) < int(BaseChance))
				{
					Inv = spawn(class'SuperHeatInv', C.Pawn,,, rot(0,0,0));
					if(Inv != None)
					{
						Inv.LifeSpan = (damageScale * HeatLifeSpan);	
						Inv.Modifier = (damageScale * HeatLifeSpan);	// *3 because the NullEntropyInv divides by 3
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
	
   	PlaySound(ImpactSound, SLOT_Misc);
    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'NewExplosionA',,,HitLocation + HitNormal*20,rotator(HitNormal));
    	PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5000 )
	        Spawn(class'ExplosionCrap',,, HitLocation + HitNormal*20, rotator(HitNormal));
	}
    if ( Role == ROLE_Authority )
    {
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    }
	SetCollisionSize(0.0, 0.0);
	Destroy();
}

defaultproperties
{
     ModifierOverlay=Texture'AW-2004Particles.Cubes.RedS1'
     BaseChance=25.000000
     HeatLifespan=4.000000
     Speed=900.000000
     MaxSpeed=900.000000
     bSwitchToZeroCollision=True
     Damage=45.000000
     DamageRadius=200.000000
     MomentumTransfer=70000.000000
     MyDamageType=Class'DEKMonsters208.DamTypeFireSkaarjSuperHeat'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     MaxEffectDistance=7000.000000
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=30
     LightSaturation=60
     LightBrightness=255.000000
     LightRadius=4.000000
     DrawType=DT_Sprite
     CullDistance=4000.000000
     bDynamicLight=True
     bOnlyDirtyReplication=True
     AmbientSound=Sound'WeaponSounds.ShockRifle.ShockRifleProjectile'
     LifeSpan=10.000000
     Texture=Texture'AW-2004Particles.Fire.NapalmSpot'
     DrawScale=0.065000
     Skins(0)=Texture'XEffects.Skins.MuzFlashWhite_t'
     Style=STY_Translucent
     FluidSurfaceShootStrengthMod=8.000000
     SoundVolume=255
     SoundRadius=60.000000
     bProjTarget=True
     bAlwaysFaceCamera=True
     ForceType=FT_Constant
     ForceRadius=40.000000
     ForceScale=5.000000
}
