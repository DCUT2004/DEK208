class BloodSpearProj extends Projectile;

var BloodSpearTrail FX;

simulated function PostBeginPlay()
{
	Velocity = Speed * vector(Rotation);
	FX = spawn(class'BloodSpearTrail');
	if (FX != None)
	{
		FX.SetBase(Self);
		FX.Lifespan = 2.00;
	}
	Super.PostBeginPlay();
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ClientSideTouch(Actor Other, Vector HitLocation);
simulated function Explode(vector HitLocation, vector HitNormal)
{
	if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);	
	}
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
	
	if (Other == Instigator)
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
	local Pawn P;

	if (Other == Instigator)
		return;
    if (Other == Owner)
		return;
		
	P = Pawn(Other);

	if (P != None && P.Controller != None && P.Health > 0 && !P.Controller.SameTeamAs(Instigator.Controller))
	{
		P.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
		//Do nothing else here. Let projectile continue through.
	}
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	local PlayerController PC;

	PlaySound (Sound'PlayerSounds.NewGibs.NewGib1',,3*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
		PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 3000 )
			spawn(class'DEKRPG208.BloodSpearExplosion',,,HitLocation + HitNormal*16 );
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}
}

defaultproperties
{
     Speed=3000.000000
     MaxSpeed=5000.000000
     Damage=200.000000
	 DamageRadius=300.00000
     MomentumTransfer=70000.000000
     MyDamageType=Class'DEKRPG208.DamTypeBloodSpear'
     AmbientSound=Sound'WeaponSounds.ShockRifle.ShockRifleProjectile'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'AS_Weapons_SM.Projectiles.Skaarj_Energy'
	 Skins(0)=Shader'AWGlobal.Shaders.WetBlood01aw'
	 Skins(1)=Shader'AWGlobal.Shaders.WetBlood01aw'
	 bDynamicLight=False
	 Drawscale=1.5000000
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     //ExplosionDecal=Class'XEffects.Shark.BloodSplat2'
     LifeSpan=5.000000
     SoundVolume=50
     SoundRadius=100.000000
     ForceType=FT_Constant
     ForceRadius=40.000000
     ForceScale=5.000000
}
