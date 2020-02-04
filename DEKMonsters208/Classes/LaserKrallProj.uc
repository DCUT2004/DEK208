class LaserKrallProj extends Projectile;


var xEmitter Trail;
var texture TrailTex;
var class<Emitter> ExplosionEffectClass;
var	xEmitter SmokeTrail;

simulated function Destroyed()
{
	if ( SmokeTrail != None )
		SmokeTrail.mRegen = False;

	if (Trail != None)
        	Trail.Destroy();

	Super.Destroyed();
}


simulated function PostBeginPlay()
{

    local Rotator R;

	Super.PostBeginPlay();

    if ( EffectIsRelevant(vect(0,0,0),false) )
    {
		Trail = Spawn(class'LinkProjEffect',self);
		if ( Trail != None ) 
			Trail.Skins[0] = TrailTex;
	}
	
	Velocity = Speed * Vector(Rotation);

    R = Rotation;
    R.Roll = Rand(65536);
    SetRotation(R);
    
	if ( Level.bDropDetail || Level.DetailMode == DM_Low )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}

 if ( Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrail = Spawn(class'LaserKrallTrailSmoke',self);
		
	}
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
            Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
        }
        Destroy();
    }
    else if ( Other.bProjTarget )
	{
		if ( Role == ROLE_Authority )
			Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}

defaultproperties
{
     ExplosionEffectClass=Class'Onslaught.ONSPlasmaHitRed'
     Speed=1500.000000
     MaxSpeed=4000.000000
     Damage=60.000000
     MyDamageType=Class'XWeapons.DamTypeLinkPlasma'
     ExplosionDecal=Class'XEffects.LinkBoltScorch'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=170
     LightBrightness=255.000000
     LightRadius=1.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.LinkProjectile'
     bDynamicLight=True
     AmbientSound=SoundGroup'WeaponSounds.ShieldGun.ShieldNoise'
     LifeSpan=3.000000
     DrawScale3D=(X=5.295000,Y=1.530000,Z=1.530000)
     PrePivot=(X=10.000000)
     Skins(0)=FinalBlend'XEffectMat.Link.LinkProjGreenFB'
     AmbientGlow=217
     Style=STY_Translucent
     SoundVolume=255
     SoundRadius=100.000000
     bFixedRotationDir=True
     RotationRate=(Roll=80000)
     ForceType=FT_Constant
     ForceRadius=30.000000
     ForceScale=7.000000
}
