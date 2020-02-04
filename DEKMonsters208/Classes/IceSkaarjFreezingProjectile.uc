class IceSkaarjFreezingProjectile extends Projectile;

var IceBall IceBallEffect;
//var	xEmitter SmokeTrail;
var config float BaseChance;
var float IceLifeSpan;
var Sound FreezeSound;

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
        IceBallEffect = Spawn(class'IceBall', self);
        IceBallEffect.SetBase(self);
       //SmokeTrail = Spawn(class'IceKrallTrailSmoke',self);
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
    if (IceBallEffect != None)
    {
		if ( bNoFX )
			IceBallEffect.Destroy();
		else
			IceBallEffect.Kill();
	}
	//if ( SmokeTrail != None )
		//SmokeTrail.mRegen = False;
	Super.Destroyed();
}

simulated function DestroyTrails()
{
    if (IceBallEffect != None)
        IceBallEffect.Destroy();
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

function NullInBlast(float Radius)
{
	local float damageScale, pawndist;
	local vector pawndir;
	local Controller C, NextC;
	Local FreezeInv Inv;
	Local Actor A;

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
		if ( C != None && C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.SameTeamAs(InstigatorController) && !C.Pawn.IsA('IceBrute') && !C.Pawn.IsA('IceChildGasbag') && !C.Pawn.IsA('IceChildSkaarjPupae') && !C.Pawn.IsA('IceGasbag') && !C.Pawn.IsA('IceGiantGasbag') && !C.Pawn.IsA('IceKrall') && !C.Pawn.IsA('Manta') && !C.Pawn.IsA('IceMercenary') && !C.Pawn.IsA('IceNali') && !C.Pawn.IsA('IceNaliFighter') && !C.Pawn.IsA('IceQueen') && !C.Pawn.IsA('IceRazorfly') && !C.Pawn.IsA('IceSkaarjFreezing') && !C.Pawn.IsA('IceSkaarjPupae') && !C.Pawn.IsA('IceSkaarjSniper') && !C.Pawn.IsA('IceSkaarjTrooper') && !C.Pawn.IsA('IceSlith') && !C.Pawn.IsA('IceSlug') && !C.Pawn.IsA('IceTitan') && !C.Pawn.IsA('IceWarlord')
		     && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) && MagicShieldInv(C.Pawn.FindInventoryType(class'MagicShieldInv')) == None )
		{
			pawndir = C.Pawn.Location - Location;
			pawndist = FMax(1,VSize(pawndir));
			damageScale = 1 - FMax(0,pawndist/Radius);

			if(!C.Pawn.isA('Vehicle') && class'RW_Freeze'.static.canTriggerPhysics(C.Pawn) && (C.Pawn.FindInventoryType(class'FreezeInv') == None))
			{
				if(C.Pawn == None)
				{
					C = NextC;
					break;
				}
				if(rand(99) < int(BaseChance))
				{
					Inv = spawn(class'FreezeInv', C.Pawn,,, rot(0,0,0));
					if(Inv != None)
					{
						Inv.LifeSpan = (damageScale * IceLifeSpan);	
						Inv.Modifier = (damageScale * IceLifeSpan);	// *3 because the NullEntropyInv divides by 3
						Inv.GiveTo(C.Pawn);
						A = C.Pawn.spawn(class'IceKrallSmoke', C.Pawn,, C.Pawn.Location, C.Pawn.Rotation);  // cant use IceSmoke as it assumes a PlayerController exists
						if(C.Pawn == None)
						{
							C = NextC;
							break;
						}
						if (A != None)
						{
							A.RemoteRole = ROLE_SimulatedProxy;
							A.PlaySound(FreezeSound,,2.5*A.TransientSoundVolume,,A.TransientSoundRadius);
						}
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

function BlowUp(vector HitLocation)
{
	Super.BlowUp(HitLocation);
	// ok, lets null them according to how close to the centre they are
	NullInBlast(DamageRadius);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController PC;

   	PlaySound(ImpactSound, SLOT_Misc);
    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'BlueGoopSmokeLarge',,,HitLocation + HitNormal*20,rotator(HitNormal));
    	PC = Level.GetLocalPlayerController();
		//if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5000 )
	        Spawn(class'ExplosionCrap',,, HitLocation + HitNormal*20, rotator(HitNormal));
//		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
//			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
    }

	BlowUp(HitLocation);
	Destroy();
}

defaultproperties
{
     BaseChance=25.000000
     IceLifespan=4.000000
     FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
     Speed=1250.000000
     MaxSpeed=1250.000000
     bSwitchToZeroCollision=True
     Damage=25.000000
     DamageRadius=150.000000
     MomentumTransfer=70000.000000
     MyDamageType=Class'DEKMonsters208.DamTypeIceSkaarjFreezing'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     MaxEffectDistance=7000.000000
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=120
     LightSaturation=195
     LightBrightness=255.000000
     LightRadius=4.000000
     DrawType=DT_Sprite
     CullDistance=4000.000000
     bDynamicLight=True
     bOnlyDirtyReplication=True
     AmbientSound=Sound'WeaponSounds.ShockRifle.ShockRifleProjectile'
     LifeSpan=10.000000
     Texture=Texture'EmitterTextures.SingleFrame.WaterDrop-04'
     DrawScale=0.075000
     Skins(0)=Texture'XEffectMat.Link.link_muz_blue'
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
