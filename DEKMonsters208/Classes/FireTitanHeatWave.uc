class FireTitanHeatWave extends Projectile;

#exec obj load file=GeneralAmbience.uax

var float HeatLifeSpan;
var config float BaseChance;

simulated function PostBeginPlay()
{
	if (Role == ROLE_Authority && Instigator != None && Instigator.Controller != None) {
		if (Instigator.Controller.ShotTarget != None && Instigator.Controller.ShotTarget.Controller != None)
			Instigator.Controller.ShotTarget.Controller.ReceiveProjectileWarning(Self);

		InstigatorController = Instigator.Controller;
	}

	Velocity = Speed * vector(Rotation);

	bReadyToSplash = True;
	Super.PostBeginPlay();
}

simulated function bool CanSplash()
{
	return False;
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ClientSideTouch(Actor Other, Vector HitLocation);
simulated function Explode(vector HitLocation, vector HitNormal)
{
	SpawnEffects( Location, HitNormal );
	Destroy(); // for def sents that call Explode, we want the heat wave to get destroyed.
}
simulated function BlowUp(vector HitLocation);
simulated function HitWall(vector HitNormal, Actor Wall)
{
	Explode(Location,HitNormal);
}

simulated singular function Touch(Actor Other)
{
	local vector HitLocation, HitNormal;

	if (Other == None) // Other just got destroyed in its touch?
		return;

	if (Other.bProjTarget || Other.bBlockActors)
	{
		LastTouched = Other;
		if (Velocity == vect(0,0,0) || Other.IsA('Mover'))
		{
			ProcessTouch(Other, Location);
			LastTouched = None;
			return;
		}

		if (Other.TraceThisActor(HitLocation, HitNormal, Other.Location, Location, vect(1,1,1)))
			HitLocation = Location;

		ProcessTouch(Other, HitLocation);
		LastTouched = None;
		if (Role < ROLE_Authority && Other.Role == ROLE_Authority && Pawn(Other) != None)
			ClientSideTouch(Other, HitLocation);
	}
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local Vector X, RefNormal, RefDir;
	local Pawn P;
	local Actor A;

	if (Other == Instigator)
		return;
    if (Other == Owner)
		return;
		
	P = Pawn(Other);
	
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
	if ( Role == ROLE_Authority )
	{
		if (P != None && P.Controller != None && P.Health > 0 && !P.Controller.SameTeamAs(Instigator.Controller))
		{
			Burn(P);
			Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
			A = P.Spawn(class'LavaDeath',,,P.Location);
			if (A != None)
				A.RemoteRole = ROLE_SimulatedProxy;
			//Do nothing else here. Let projectile continue through.
		}
	}	
}

function Burn(Pawn P)
{
	local MagicShieldInv MInv;
	local SuperHeatInv Inv;
	
	MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
	if (P != None && P.Controller != None && P.Health > 0 && !P.Controller.SameTeamAs(InstigatorController) && class'RW_Freeze'.static.canTriggerPhysics(P))
	{
		if (MInv == None)
		{
			if(rand(99) < int(BaseChance))
			{
				Inv = SuperHeatInv(P.FindInventoryType(class'SuperHeatInv'));
				if (Inv == None)
				{
					Inv = spawn(class'SuperHeatInv', P,,, rot(0,0,0));
					Inv.Modifier = 4;
					Inv.LifeSpan = HeatLifespan;
					Inv.GiveTo(P);
				}
			}				
		}
		else
			return;
	}
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	local PlayerController PC;
	local Actor A;

	PlaySound (Sound'WeaponSounds.BExplosion3',,3*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
		PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 3000 )
		A.spawn(class'FlashExplosion',,,HitLocation + HitNormal*16 );
		A.spawn(class'RocketSmokeRing',,,HitLocation + HitNormal*16, rotator(HitNormal) );
		A.SetDrawScale(A.DrawScale*2);
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}
}

defaultproperties
{
     HeatLifespan=4.000000
     BaseChance=25.000000
     Speed=300.000000
     MaxSpeed=300.000000
     Damage=100.000000
     MyDamageType=Class'DEKMonsters208.DamTypeFireTitanSuperHeat'
     ImpactSound=Sound'ONSVehicleSounds-S.Explosions.VehicleExplosion02'
     LightType=LT_Steady
     LightEffect=LE_Spotlight
     LightHue=20
     LightSaturation=50
     LightBrightness=300.000000
     LightRadius=30.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DEKStaticsMaster207P.fX.SolarWave'
     bDynamicLight=True
     bIgnoreEncroachers=True
     AmbientSound=Sound'GeneralAmbience.firefx8'
     LifeSpan=3.000000
     PrePivot=(X=210.000000)
     Skins(0)=FinalBlend'DEKRPGTexturesMaster207P.fX.ShieldHitOrangeEdgesFinal'
     Skins(1)=Texture'AW-2k4XP.Weapons.ElectricShockTex2'
     AmbientGlow=254
     SoundVolume=255
     SoundRadius=100.000000
     CollisionRadius=140.000000
     CollisionHeight=80.000000
     bCollideWorld=False
     bIgnoreOutOfWorld=True
}
