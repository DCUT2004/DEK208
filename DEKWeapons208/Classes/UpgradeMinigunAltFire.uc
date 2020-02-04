class UpgradeMinigunAltFire extends UpgradeMinigunFire;

var UpgradeMinigunAltExplosion ExplosionFXb;
var int SplashDamage;
var int DamageRadius;
var int MomentumTransfer;

/*
replication
{
reliable if ( Role == ROLE_Authority )
	ExplosionFXb;
}*/

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
	Weapon.HurtRadius(SplashDamage, DamageRadius, DamageType, MomentumTransfer, HitLocation );
	Weapon.MakeNoise(1.0);
}

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X, End, HitLocation, HitNormal, RefNormal;
    local Actor Other;
	local Pawn P;
    local int Damage;
    local bool bDoReflect;
    local int ReflectNum;

    ReflectNum = 0;
    while (true)
    {
        bDoReflect = false;
        X = Vector(Dir);
        End = Start + TraceRange * X;

        Other = Trace(HitLocation, HitNormal, End, Start, true);
		P = Pawn(Other);

        if ( Other != None && (Other != Instigator || ReflectNum > 0) )
        {
            if (bReflective && Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, 0))
            {
                bDoReflect = true;
                HitNormal = Vect(0,0,0);
            }
            else if (!Other.bWorldGeometry)
            {
				Damage = DamageMin;
				if ( (DamageMin != DamageMax) && (FRand() > 0.5) )
					Damage += Rand(1 + DamageMax - DamageMin);
                Damage = Damage * DamageAtten;
                
				if ( Other.isa('Vehicle') )
					Momentum=default.Momentum*0.5;
		
				Other.TakeDamage(Damage, Instigator, HitLocation, Momentum*X, DamageType);
						HitNormal = Vect(0,0,0);
				if ( P.Health > 0 && !P.Controller.SameTeamAs(Instigator.Controller))
					ExplosionFXb=Spawn(class'UpgradeMinigunAltExplosion',,, HitLocation, Rotator(HitNormal));
            }
            else if ( WeaponAttachment(Weapon.ThirdPersonActor) != None )
				WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
        }
        else
        {
            HitLocation = End;
            HitNormal = Vect(0,0,0);
        }
        
	if ( !bDoReflect )
	    SpawnBeamEffect(Start, Dir, HitLocation, HitNormal, ReflectNum);

        if (bDoReflect && ++ReflectNum < 4)
        {
            //Log("reflecting off"@Other@Start@HitLocation);
            Start = HitLocation;
            Dir = Rotator(RefNormal); //Rotator( X - 2.0*RefNormal*(X dot RefNormal) );
        }
        else
        {
            break;
        }
    }
}

defaultproperties
{
     SplashDamage=8
     DamageRadius=90
     MomentumTransfer=5000
     BarrelRotationsPerSec=1.000000
     FiringSound=Sound'WeaponSounds.Minigun.minialtfireb'
     MinigunSoundVolume=240
     WindUpTime=0.150000
     FiringForce="minialtfireb"
     DamageType=Class'XWeapons.DamTypeMinigunAlt'
     DamageMin=6
     PreFireTime=0.150000
     FireLoopAnimRate=3.000000
     AmmoPerFire=2
     SmokeEmitterClass=Class'XEffects.MinigunAltMuzzleSmoke'
     Spread=0.030000
}
