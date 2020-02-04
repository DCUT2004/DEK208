class DEKRailGunFire extends SniperFire;

var float EOFireRate;

var() float ChargeUpRate;
var() int	MaxChargeLoad;
var() int	ChargeLoad;
var() Sound HoldSound;
var vector	ChargeEffectOffset;

var Emitter NewFireEffect,
			ChargeEffect;

var bool bBerserkStarted;
var() Name BigFireAnim;
var() Name ChargeUpAnim;
var() float BigFireAnimRate;
var() float ChargeUpAnimRate;

simulated function InitEffects()
{
	if ( ChargeEffect == None )
	{
		ChargeEffect = spawn(class'DEKRailGunChargeEffect');

		if ( ChargeEffect != None )
		{
			SpriteEmitter(ChargeEffect.Emitters[0]).StartSizeRange.X.Min = 0;
			SpriteEmitter(ChargeEffect.Emitters[0]).StartSizeRange.X.Max = 0;
				
			SpriteEmitter(ChargeEffect.Emitters[1]).StartSizeRange.X.Min = 0;
			SpriteEmitter(ChargeEffect.Emitters[1]).StartSizeRange.X.Max = 0;
			SpriteEmitter(ChargeEffect.Emitters[1]).StartVelocityRange.X.Min = 0;
			SpriteEmitter(ChargeEffect.Emitters[1]).StartVelocityRange.X.Max = 0;

			ChargeEffect.bHidden=true;
		}
	}

	Weapon.AttachToBone(ChargeEffect,'SlideR');
	//ChargeEffect.SetRelativeLocation(ChargeEffectOffset);

	super.InitEffects();
}

function ModeHoldFire()
{
    if ( Weapon.AmmoAmount(ThisModeNum) > 0 )
    {
        Super.ModeHoldFire();
        GotoState('Hold');
    }
}

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X,Y,Z, End, HitLocation, HitNormal, RefNormal;
    local Actor Other, mainArcHitTarget;
    local int Damage, ReflectNum, arcsRemaining;
    local bool bDoReflect;
    local xEmitter hitEmitter;
    local class<Actor> tmpHitEmitClass;
    local float tmpTraceRange;
    local vector arcEnd, mainArcHit;
	local Pawn HeadShotPawn;
	local BeamEmitter myBeam;
	local vector RealStartLoc;

    Weapon.GetViewAxes(X, Y, Z);
    if ( Weapon.WeaponCentered() )
        arcEnd = (Instigator.Location + 
			Weapon.EffectOffset.X * X + 
			1.5 * Weapon.EffectOffset.Z * Z); 
	else
        arcEnd = (Instigator.Location + 
			Instigator.CalcDrawOffset(Weapon) + 
			Weapon.EffectOffset.X * X + 
			Weapon.Hand * Weapon.EffectOffset.Y * Y + 
			Weapon.EffectOffset.Z * Z); 
	
    RealStartLoc = arcEnd;
	arcsRemaining = NumArcs;

    tmpHitEmitClass = HitEmitterClass;
    tmpTraceRange = TraceRange;
    
    ReflectNum = 0;
    while (true)
    {
        bDoReflect = false;
        X = Vector(Dir);
        End = Start + tmpTraceRange * X;
        Other = Trace(HitLocation, HitNormal, End, Start, true);

        if ( Other != None && (Other != Instigator || ReflectNum > 0) )
        {
            if (bReflective && Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, 0))
            {
                bDoReflect = true;
            }
            else if ( Other != mainArcHitTarget )
            {
                if ( !Other.bWorldGeometry )
                {
                    Damage = (DamageMin + Rand(DamageMax - DamageMin)) * DamageAtten;

                    if (Vehicle(Other) != None)
                        HeadShotPawn = Vehicle(Other).CheckForHeadShot(HitLocation, X, 1.0);

                    if (HeadShotPawn != None)
                        HeadShotPawn.TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, Momentum*X, DamageTypeHeadShot);
					
					else if ( (Pawn(Other) != None) && (arcsRemaining == NumArcs)
						&& Pawn(Other).IsHeadShot(HitLocation, X, 1.0) )
                        Other.TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, Momentum*X, DamageTypeHeadShot);
                    
					else
                    {
						if ( arcsRemaining < NumArcs )
							Damage *= SecDamageMult;

						else 
						{
							Damage *= fClamp(ChargeLoad,1,5);
							//Log(Damage);
						}
	
                        Other.TakeDamage(Damage, Instigator, HitLocation, Momentum*X, DamageType);
					}
                }
                else
					HitLocation = HitLocation + 2.0 * HitNormal;
            }
        }
        else
        {
            HitLocation = End;
            HitNormal = Normal(Start - End);
        }
        hitEmitter = xEmitter(Spawn(tmpHitEmitClass,,, arcEnd, Rotator(HitNormal)));
        if ( hitEmitter != None )
		{
			hitEmitter.mSpawnVecA = HitLocation;
			
			hitEmitter.mSizeRange[0] = 30 + 4 * ChargeLoad;
			hitEmitter.mSizeRange[1] = 30 + 4 * ChargeLoad;

			if ( ChargeLoad > 1 )
			{
				NewFireEffect = spawn(class'DEKRailGunChargedBeam');
				if ( NewFireEffect != None )
					myBeam = BeamEmitter(NewFireEffect.Emitters[0]);
		
				if ( myBeam != None )
				{
					if ( myBeam.BeamEndPoints.Length <= 0 )
						myBeam.BeamEndPoints.Insert(0,1);

					// Set the endpoint of the beam emitter
					myBeam.BeamEndPoints[0].Offset.X.Min = arcEnd.X;
					myBeam.BeamEndPoints[0].Offset.X.Max = arcEnd.X;

					myBeam.BeamEndPoints[0].Offset.Y.Min = arcEnd.Y;
					myBeam.BeamEndPoints[0].Offset.Y.Max = arcEnd.Y;

					myBeam.BeamEndPoints[0].Offset.Z.Min = arcEnd.Z;
					myBeam.BeamEndPoints[0].Offset.Z.Max = arcEnd.Z;

					myBeam.StartSizeRange.X.Min = 2 * fClamp(ChargeLoad,1,5);
					myBeam.StartSizeRange.X.Max = 3 * fClamp(ChargeLoad,1,5);
				}

				DEKRailGunChargedBeam(NewFireEffect).arcEnd = arcEnd;
				DEKRailGunChargedBeam(NewFireEffect).Charge = ChargeLoad;

				NewFireEffect.SetLocation(RealStartLoc);
			}
		}

		if ( HitScanBlockingVolume(Other) != None )
			return;

		//log("arcsRemaingin" @ arcsRemaining @ "numArcs" @ NumArcs);
        if( arcsRemaining == NumArcs )
        {
            mainArcHit = HitLocation + (HitNormal * 2.0);
            if ( Other != None && !Other.bWorldGeometry )
                mainArcHitTarget = Other;
        }
        
        if (bDoReflect && ++ReflectNum < 4)
        {
            //Log("reflecting off"@Other@Start@HitLocation);
            Start = HitLocation;
            Dir = Rotator( X - 2.0*RefNormal*(X dot RefNormal) );
        }
        else if ( arcsRemaining > 0 )
        {
            arcsRemaining--;

            // done parent arc, now move trace point to arc trace hit location and try child arcs from there
            Start = mainArcHit;
            Dir = Rotator(VRand());
            tmpHitEmitClass = SecHitEmitterClass;
            tmpTraceRange = SecTraceDist;
            arcEnd = mainArcHit;
        }
        else
        {
            break;
        }

    }
	GotoState('');
}

function PlayFiring()
{
	Super.PlayFiring();
    if ( Weapon.AmmoAmount(0) > 0 )
        Weapon.PlayOwnedSound(Sound'WeaponSounds.LightningGunChargeUp', SLOT_Misc,,,,1.1,false);
	if (ChargeLoad > 1 || (ChargeLoad > 1 && DEKRailGun(Weapon).zoomed))
		Weapon.PlayAnim(ChargeUpAnim, ChargeUpRate, 0.0);
	if (ChargeLoad == MaxChargeLoad || (ChargeLoad == MaxChargeLoad && DEKRailGun(Weapon).zoomed))
		Weapon.PlayAnim(BigFireAnim, BigFireAnimRate, TweenTime);
	else
		Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
		
}

function PlayFireEnd()
{
	if ( ChargeEffect != None )
	{
		SpriteEmitter(ChargeEffect.Emitters[0]).StartSizeRange.X.Min = 0;
		SpriteEmitter(ChargeEffect.Emitters[0]).StartSizeRange.X.Max = 0;
				
		SpriteEmitter(ChargeEffect.Emitters[1]).StartSizeRange.X.Min = 0;
		SpriteEmitter(ChargeEffect.Emitters[1]).StartSizeRange.X.Max = 0;
		SpriteEmitter(ChargeEffect.Emitters[1]).StartVelocityRange.X.Min = 0;
		SpriteEmitter(ChargeEffect.Emitters[1]).StartVelocityRange.X.Max = 0;
	
		ChargeEffect.bHidden = False;
	}
	GotoState('');
}

function StartBerserk()
{
    if ( !bBerserkStarted )
	{
		EOFireRate = FireRate;
	
		FireRate = FireRate * 0.75;
		FireAnimRate = default.FireAnimRate/0.75;
		ReloadAnimRate = default.ReloadAnimRate/0.75;
		bBerserkStarted = true;
	}
}

function StopBerserk()
{
    super.StopBerserk();
    if ( EOFireRate != 0 )
		FireRate = EOFireRate;

	bBerserkStarted = false;
}

function StartSuperBerserk()
{
    FireRate = FireRate/Level.GRI.WeaponBerserk;
    FireAnimRate = default.FireAnimRate * Level.GRI.WeaponBerserk;
    ReloadAnimRate = default.ReloadAnimRate * Level.GRI.WeaponBerserk;
}

state Hold
{
    simulated function BeginState()
    {
        if ( ChargeEffect != None )
		{
			SpriteEmitter(ChargeEffect.Emitters[0]).StartSizeRange.X.Min = 0;
			SpriteEmitter(ChargeEffect.Emitters[0]).StartSizeRange.X.Max = 0;
				
			SpriteEmitter(ChargeEffect.Emitters[1]).StartSizeRange.X.Min = 0;
			SpriteEmitter(ChargeEffect.Emitters[1]).StartSizeRange.X.Max = 0;
			SpriteEmitter(ChargeEffect.Emitters[1]).StartVelocityRange.X.Min = 0;
			SpriteEmitter(ChargeEffect.Emitters[1]).StartVelocityRange.X.Max = 0;
		
			ChargeEffect.Reset();
			ChargeEffect.bHidden = False;
		}

		ChargeLoad = 0;
        SetTimer(ChargeUpRate, true);
		Weapon.PlayAnim(ChargeUpAnim, ChargeUpAnimRate, 0.0);
        if ((bIsFiring) && ChargeLoad == MaxChargeLoad || Weapon.AmmoAmount(ThisModeNum) == 0)
		{
			Weapon.LoopAnim(FireLoopAnim, FireLoopAnimRate, TweenTime);
		}
        Weapon.PlayOwnedSound(Sound'ONSVehicleSounds-S.PRV.PRVChargeUp',SLOT_Interact,TransientSoundVolume);
        Weapon.ClientPlayForceFeedback( "BioRiflePowerUp" );  // jdf
        Timer();
    }

    simulated function Timer()
    {
		if ( Weapon.AmmoAmount(ThisModeNum) > 0 )
			ChargeLoad++;
        
		Weapon.ConsumeAmmo(ThisModeNum, 1);
        
		NumArcs = Max(1,ChargeLoad);
		//log("NumArcs" @ NumArcs);

		if (ChargeLoad == MaxChargeLoad || Weapon.AmmoAmount(ThisModeNum) == 0 || ChargeLoad == MaxChargeLoad && DEKRailGun(Weapon).zoomed) //holding a max charge now.
        {
            SetTimer(0.0, false);
			Instigator.AmbientSound = Sound'ONSVehicleSounds-S.PRV.PRVChargeLoop';
			Instigator.SoundRadius = 150;
			Instigator.SoundVolume = 150;
			FireSound = Sound'ONSVehicleSounds-S.PRV.PRVFire04';
			Weapon.LoopAnim(FireLoopAnim, FireLoopAnimRate, TweenTime);
        }
		else
			FireSound = Default.FireSound;
		
		if ( ChargeEffect != None )
		{
			SpriteEmitter(ChargeEffect.Emitters[0]).StartSizeRange.X.Min = 20.0 * fClamp(float(ChargeLoad) / 15.0,0,1);
			SpriteEmitter(ChargeEffect.Emitters[0]).StartSizeRange.X.Max = 20.0 * fClamp(float(ChargeLoad) / 15.0,0,1);
				
			SpriteEmitter(ChargeEffect.Emitters[1]).StartSizeRange.X.Min = 5 * fClamp(float(ChargeLoad) / 15.0,0,1);
			SpriteEmitter(ChargeEffect.Emitters[1]).StartSizeRange.X.Max = 8 * fClamp(float(ChargeLoad) / 15.0,0,1);
			SpriteEmitter(ChargeEffect.Emitters[1]).StartVelocityRange.X.Min = 70 * fClamp(float(ChargeLoad) / 15.0,0,1);
			SpriteEmitter(ChargeEffect.Emitters[1]).StartVelocityRange.X.Max = 80 * fClamp(float(ChargeLoad) / 15.0,0,1);
		}
    }

    simulated function EndState()
    {
		if ( (Instigator != None) && (Instigator.AmbientSound == Sound'ONSVehicleSounds-S.PRV.PRVChargeLoop') )
			Instigator.AmbientSound = None;
		
		Instigator.SoundRadius = Instigator.Default.SoundRadius;
		Instigator.SoundVolume = Instigator.Default.SoundVolume;

        StopForceFeedback( "BioRiflePowerUp" );  // jdf

		if ( ChargeEffect != None )
			ChargeEffect.bHidden = true;
    }
}

simulated function ModeTick(float dt)
{
    if ( !bIsFiring )
    {
        return;
    }
	if (ChargeLoad == MaxChargeLoad) //holding a max charge now.
    {
		Recoil();
	}
}


function Recoil()
{
    local Rotator NewRotation;
    local float NewPitch, NewYaw;

    if ( (Instigator != None))  //&& Instigator.IsFirstPerson()
	{
    NewPitch = int(Frand()*25); NewYaw = int(Frand()*25);
    if (Frand() > 0.5) NewYaw *= -1;
    if (Frand() > 0.5) NewPitch *= -1;
    NewRotation = Instigator.GetViewRotation();
    NewRotation.Pitch += NewPitch;
    NewRotation.Yaw += NewYaw;
    Instigator.SetViewRotation(NewRotation);
	}
}

defaultproperties
{
     ChargeUpRate=0.720000
     MaxChargeLoad=5
     HoldSound=Sound'ONSVehicleSounds-S.PRV.PRVChargeLoop'
     ChargeEffectOffset=(X=-50.000000)
     BigFireAnim="BigFire"
     ChargeUpAnim="Charge"
     BigFireAnimRate=1.500000
     ChargeUpAnimRate=0.500000
	 AmmoClass=Class'DEKWeapons208.DEKRailGunAmmo'
     HitEmitterClass=Class'DEKWeapons208.DEKRailGunBolt'
     SecHitEmitterClass=Class'DEKWeapons208.DEKRailGunBoltChild'
     SecTraceDist=700.000000
     DamageTypeHeadShot=Class'DEKWeapons208.DamTypeDEKRailGunHeadShot'
     DamageType=Class'DEKWeapons208.DamTypeDEKRailGunShot'
     DamageMin=40
     DamageMax=120
     TraceRange=60000.000000
     Momentum=50000.000000
     bReflective=True
     bFireOnRelease=True
     FireLoopAnim="ChargedLoop"
     FireAnimRate=1.964286
     TweenTime=0.010000
     FireRate=0.914286
}
