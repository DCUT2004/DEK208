class UpgradeShockRifleBlackHole extends Projectile;

var float AttractionRadius;
var float AttractionStrength;
var class<Emitter> SingularityEffectClass;
var class<DamageType> LightningDamageType;
var float LightningRechargeTime;
var float LightningRangeMax;
var float LightningDamageMin;
var float LightningDamageMax;
var float LightningCharge;
var Emitter SingularityEffect;
var float DetonationTime;

#exec obj load file=GeneralAmbience.uax

simulated event PreBeginPlay()
{
    Super.PreBeginPlay();

    if( Pawn(Owner) != None )
        Instigator = Pawn( Owner );
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Level.NetMode != NM_DedicatedServer)
	{
		SingularityEffect = Spawn(SingularityEffectClass, Self);
		SingularityEffect.SetBase(Self);
	}

	Velocity = Speed * Vector(Rotation);
	SetTimer(DetonationTime, true);
}

simulated function Destroyed()
{
	if (SingularityEffect != None)
	{
		if (bNoFX)
			SingularityEffect.Destroy();
		else
			SingularityEffect.Kill();
	}

	Super.Destroyed();
}


simulated function DestroyTrails()
{
	if (SingularityEffect != None)
		SingularityEffect.Destroy();
}

/**
Attract nearby actors and potentially damage them with electric discharges.
*/
simulated function Attract(float DeltaTime, float RadiusScale, float StrengthScale)
{
	const WantedPhysicsModes = 0xEA5E; // each bit stands for a physics mode to be considered
	local Actor A;
	local Pawn P;
	local float actualAttractRadius, actualAttractStrength, dist;
	local vector dir, attraction;

	actualAttractRadius = AttractionRadius * RadiusScale;
	actualAttractStrength = AttractionStrength * StrengthScale;
	foreach DynamicActors(class'Actor', A)
	{
		P = Pawn(A);
		if ( A == None || P == None || A.Role != ROLE_Authority && !A.bNetTemporary || A.Location == Location || P.Controller == None || (P.Controller != None && P.Controller.SameTeamAs(Instigator.Controller)) || (1 << A.Physics & WantedPhysicsModes) == 0)
			continue; //stop. don't go through with the Attract function.
		if (Invasion(Level.Game) != None && !P.IsA('Monster'))
			continue;
		if (P == Class'ONSWeaponPawn')
			continue;
		if (ClassIsChildOf(P.Class,Class'ONSWeaponPawn'))
			continue;
		if (ClassIsChildOf(P.Class,Class'Vehicle'))
			continue;
		if (P.GetTeamNum() == Instigator.GetTeamNum())
			continue;
		dir = Location - A.Location;
		dist = VSize(dir);
		dir /= dist;

		if (dist > actualAttractRadius)
			continue;

		attraction = dir * (actualAttractStrength * Square(1 - dist / actualAttractRadius));

		if (P != None && P.Health > 0 && P.Controller != None && !P.Controller.SameTeamAs(Instigator.Controller) && (!ClassIsChildOf(P.Class,Class'Vehicle') || P != Class'ONSWeaponPawn' || !ClassIsChildOf(P.Class,Class'ONSWeaponPawn') || P != Class'ASTurret' || !ClassIsChildOf(P.Class,Class'ASTurret')))
		{
			if (P.Physics == PHYS_Ladder && P.OnLadder != None)
			{
				if (vector(P.OnLadder.WallDir) dot attraction < -100)
					P.SetPhysics(PHYS_Falling);
			}
			else if (P.Physics == PHYS_Walking)
			{
				if (P.PhysicsVolume.Gravity dot attraction < -100)
					P.SetPhysics(PHYS_Falling);
			}
			else if (P.Physics == PHYS_Spider)
			{
				// probably not a good idea as I have no idea what people use spider physics for
				if (P.Floor dot attraction > 1000)
					P.SetPhysics(PHYS_Falling);
			}
		}
		//else continue;

		// check this, in case physics change
		if (A.Physics == PHYS_Karma || A.Physics == PHYS_KarmaRagdoll)
		{
			A.KAddImpulse(DeltaTime * 10 * Sqrt(A.KGetMass()) * attraction, vect(0,0,0));
		}
		else if (P != None && P != Class'Vehicle')
		{
			A.Velocity += DeltaTime * attraction / Sqrt(A.Mass);
			P.Velocity.Z=50;
		}
		else if (UpgradeShockRifleBlackHole(A) != None && dist < 3 * (CollisionRadius + A.CollisionRadius))
		{
			A.Velocity -= DeltaTime * attraction / Sqrt(A.Mass);
		}
		else
		{
			A.Velocity += DeltaTime * attraction / Sqrt(A.Mass);
		}
	}
}

simulated function Tick(float DeltaTime)
{
	Attract(DeltaTime, 1.0, 1.0);
}

simulated function Timer() 
{
	local Vector HitNormal;
	
	Explode(Location, HitNormal);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	//do nothing. We don't want people getting sucked in to explode the projectile right away. Have it suck in players, then explode when the timer calls it.
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local actor HitActor;
	local vector HL, HN;

	BlowUp(HitLocation); //Blowup calls HurtRadius

	Spawn(class'ONSShockTankShockExplosion');
	if ( (Level.NetMode != NM_DedicatedServer) && EffectIsRelevant(Location,false) )
	{
		HitActor = Trace(HL, HN, Location - Vect(0,0,120), Location, false);
		if (HitActor != None)
			Spawn(class'ComboDecal',self,, HL, rotator(vect(0,0,-1)));
	}
	PlaySound(ImpactSound, SLOT_None, 1.0,, 800);
	DestroyTrails();
	Destroy();
}

simulated function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
	local Actor Victims;
	local float damageScale, momentumScale, dist;
	local vector dir;

	if (bHurtEntry)
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors(class'Actor', Victims, 2 * DamageRadius, HitLocation)
	{
		if (Victims != self && Hurtwall != Victims && (Victims.Role == ROLE_Authority || Victims.bNetTemporary) && !Victims.IsA('FluidSurfaceInfo'))
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1, VSize(dir));
			dir = dir / dist;
			damageScale   = 1 - FClamp((dist - Victims.CollisionRadius) /      DamageRadius,  0, 1);
			momentumScale = 1 - FClamp((dist - Victims.CollisionRadius) / (2 * DamageRadius), 0, 1);

			if (Instigator == None || Instigator.Controller == None)
				Victims.SetDelayedDamageInstigatorController(InstigatorController);
			if (Victims == LastTouched)
				LastTouched = None;

			Victims.TakeDamage(FMax(0.001, damageScale * DamageAmount), Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir, momentumScale * Momentum * dir, DamageType);
			if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

		}
	}
	if (LastTouched != None && LastTouched != self && LastTouched.Role == ROLE_Authority && !LastTouched.IsA('FluidSurfaceInfo'))
	{
		Victims = LastTouched;
		LastTouched = None;
		dir = Victims.Location - HitLocation;
		dist = FMax(1, VSize(dir));
		dir = dir / dist;
		damageScale   = FMax(Victims.CollisionRadius / (Victims.CollisionRadius + Victims.CollisionHeight), 1 - FMax(0, (dist - Victims.CollisionRadius) /      DamageRadius ));
		momentumScale = FMax(Victims.CollisionRadius / (Victims.CollisionRadius + Victims.CollisionHeight), 1 - FMax(0, (dist - Victims.CollisionRadius) / (2 * DamageRadius)));

		if (Instigator == None || Instigator.Controller == None)
			Victims.SetDelayedDamageInstigatorController(InstigatorController);
		Victims.TakeDamage(damageScale * DamageAmount, Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir, momentumScale * Momentum * dir, DamageType);
		if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
			Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
	}

	bHurtEntry = false;
}

defaultproperties
{
     AttractionRadius=1000.000000
     AttractionStrength=80000.000000
     SingularityEffectClass=Class'DEKWeapons208.UpgradeShockRifleBlackHoleEffect'
     LightningDamageType=Class'DEKWeapons208.DamTypeUpgradeShockRifleBlackHoleLightning'
     LightningRechargeTime=2.000000
     LightningRangeMax=500.000000
     LightningDamageMin=10.000000
     LightningDamageMax=20.000000
     DetonationTime=1.000000
     MaxSpeed=0.000000
     Damage=200.000000
     DamageRadius=275.000000
     MomentumTransfer=-100000.000000
     MyDamageType=Class'XWeapons.DamTypeShockCombo'
     ImpactSound=Sound'ONSBPSounds.ShockTank.ShockBallExplosion'
     ExploWallOut=50.000000
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=195
     LightSaturation=85
     LightBrightness=200.000000
     LightRadius=10.000000
     DrawType=DT_None
     bDynamicLight=True
     Physics=PHYS_Flying
     AmbientSound=Sound'GeneralAmbience.computerfx31'
     LifeSpan=11.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     bBounce=True
     ForceType=FT_Constant
     ForceRadius=1000.000000
     ForceScale=-5.000000
}
