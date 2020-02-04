class TechTitan extends DCTitan;

var TechTitanShield Shield;
var int numChildren;
var() int MaxChildren;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return (  P.class == class'DCTitan' || P.class == class'DCStoneTitan' || P.class == class'DEKGoldTitan' || P.class == class'DEKGhostTitan' || P.class == class'CosmicTitan' || P.class == class'TechTitan' || P.Class == class'IceTitan' || P.Class == class'FireTitan' || P.class == class'TechBehemoth' || P.Class == class'TechPupae' || P.Class == class'TechRazorfly' || P.Class == class'TechSkaarj' || P.Class == class'TechSlith' || P.Class == class'TechSlug' || P.Class == class'TechQueen' || P.Class == class'TechWarlord' || P.Class == class'FruitCakeTitan' || P.Class == class'IceTitan');
}

function Stomp()
{
}

function FootStep()
{
	local pawn Thrown;

	TriggerEvent(StepEvent,Self, Instigator);
	foreach CollidingActors( class 'Pawn', Thrown,Mass*0.5)
		ThrowOther(Thrown,Mass/12);
	PlaySound(Step, SLOT_Interact, 24);
	
        SpawnShield();
}

function SpawnShield()
{
//	log("SpawnShield");
	if(Shield!=none)
		Shield.Destroy();

	Shield = Spawn(class'TechTitanShield',,,Location);
	if(Shield!=none)
	{
		Shield.SetDrawScale(Shield.DrawScale*(drawscale/default.DrawScale));
	    Shield.AimedOffset.X=CollisionRadius;
		Shield.AimedOffset.Y=CollisionRadius;
		Shield.SetCollisionSize(CollisionRadius*1.2,CollisionHeight*1.2);
	}
//	Shield.SetBase(self);

}

function SpawnChildren() //we're not going to actually spawn children. Just a hack for the Tech Skaarj mine
{
	local NavigationPoint N;
	local SMPChildPupae P;

	if(numChildren>=MaxChildren)
		return;
	else if(vsize(N.Location-Location)<2000 && FastTrace(N.Location,Location))
	{
		P=spawn(class 'SMPChildPupae' ,self,,N.Location);
		   if(P!=none)
		   {
		    P.LifeSpan=20+Rand(10);
			numChildren++;
			}
	}

}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, vector momentum, class<DamageType> damageType)
{
   	local vector HitNormal;
	
	if(CheckReflect(HitLocation,HitNormal,Damage))
		Damage*=0;
	Momentum = vect(0,0,0);		// its a ghost - you can't knock it back
	Super.TakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, damageType);
}

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int Damage )
{
	local Vector HitDir;
	local Vector FaceDir;
	
        if ( Shield != None )
        {
           FaceDir=vector(Rotation);
	   HitDir = Normal(Location-HitLocation+ Vect(0,0,8));
	   RefNormal=FaceDir;
	                     if ( FaceDir dot HitDir < -0.26 && Shield!=none) // 68 degree protection arc
	                     {
		             Shield.Flash(Damage);

		             return true;
	                     }
        }

        return false;


}

function SpawnRock()
{
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;
	local Projectile   Proj;

	GetAxes(Rotation,X,Y,Z);
	FireStart = Location + 1.2*CollisionRadius * X + 0.4 * CollisionHeight * Z;
	if ( !SavedFireProperties.bInitialized )
	{
		SavedFireProperties.AmmoClass = MyAmmo.Class;
		SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
		SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
		SavedFireProperties.MaxRange = MyAmmo.MaxRange;
		SavedFireProperties.bTossed = MyAmmo.bTossed;
		SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
		SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
		SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
		SavedFireProperties.bInitialized = true;
	}
	
	if (Controller != None)
		FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
	if (FRand() < 0.4)
	{
		Proj=Spawn(class'TechTitanProjectile',,,FireStart,FireRotation);
		if(Proj!=none)
		{
			Proj.SetPhysics(PHYS_Projectile);
			Proj.setDrawScale(Proj.DrawScale*DrawScale/default.DrawScale);
			Proj.SetCollisionSize(Proj.CollisionRadius*DrawScale/default.DrawScale,Proj.CollisionHeight*DrawScale/default.DrawScale);
			Proj.Velocity = (ProjectileSpeed+Rand(ProjectileMaxSpeed-ProjectileSpeed)) *vector(Proj.Rotation)*DrawScale/default.DrawScale;
		}
		return;
	}

	Proj=Spawn(MyAmmo.ProjectileClass,,,FireStart,FireRotation);
	if(Proj!=none)
	{
		Proj.SetPhysics(PHYS_Projectile);
		Proj.setDrawScale(Proj.DrawScale*DrawScale/default.DrawScale);
		Proj.SetCollisionSize(Proj.CollisionRadius*DrawScale/default.DrawScale,Proj.CollisionHeight*DrawScale/default.DrawScale);
		Proj.Velocity = (ProjectileSpeed+Rand(ProjectileMaxSpeed-ProjectileSpeed)) *vector(Proj.Rotation)*DrawScale/default.DrawScale;
	}
	FireStart=Location + 1.2*CollisionRadius * X -40*Y+ 0.4 * CollisionHeight * Z;
	Proj=Spawn(MyAmmo.ProjectileClass,,,FireStart,FireRotation);
	if(Proj!=none)
	{
		Proj.SetPhysics(PHYS_Projectile);
		Proj.setDrawScale(Proj.DrawScale*DrawScale/default.DrawScale);
		Proj.SetCollisionSize(Proj.CollisionRadius*DrawScale/default.DrawScale,Proj.CollisionHeight*DrawScale/default.DrawScale);
		Proj.Velocity = (ProjectileSpeed+Rand(ProjectileMaxSpeed-ProjectileSpeed)) *vector(Proj.Rotation)*DrawScale/default.DrawScale;
	}
	bStomped=false;
	ThrowCount++;
	if(ThrowCount>=2)
	{
		bThrowed=true;
		ThrowCount=0;
	}
}

function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local int OldHealth, HealthTaken, TakePercent;


	// increase damage if a block or vehicle
	If ( (Controller.target != None) && Pawn(Controller.target) != None  && Pawn(Controller.target).Health > 0)
	{
	    OldHealth = Pawn(Controller.target).Health;
        TakePercent = 0;
	    if (DruidBlock(Controller.target) != None)
	    {
            hitdamage *= 50;        // if invasion damage to block will get reduced to 40%
            TakePercent = 30;
		}
		else if (vehicle(Controller.target) != None)
		{
            hitdamage *= 50;
            TakePercent = 25;
		}
	}

	if (super.MeleeDamageTarget(hitdamage, pushdir))
	{
	    // hit it
	    if (Controller.target == None || Pawn(Controller.target).Health <= 0)
	        HealthTaken = OldHealth;
		else
		    HealthTaken = OldHealth - Pawn(Controller.target).Health;
		if (HealthTaken < 0)
		    HealthTaken = 0;
		// now take some health back
		if (HealthTaken > 0)
		{
			HealthTaken = max((HealthTaken * TakePercent)/100.0, 1);
			GiveHealth(HealthTaken, HealthMax);
		}

		return true;
	}

	return false;
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local TechTitanMine M;
	
	foreach DynamicActors(class'TechTitanMine', M)
	{
		if (M != None && M.Instigator == Instigator && M.InstigatorController == Instigator.Controller)
			M.BlowUp(M.Location);
	}
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     AmmunitionClass=Class'DEKMonsters208.TechTitanAmmo'
     ScoringValue=15
     GibGroupClass=Class'DEKMonsters208.DEKTechGibGroup'
     GroundSpeed=200.000000
     WaterSpeed=100.000000
     AirSpeed=200.000000
     AccelRate=400.000000
     Health=750
     ControllerClass=Class'DEKMonsters208.TechMonsterController'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.TechMonsters.TechProjFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster206E.TechMonsters.TechProjFB'
     Buoyancy=80.000000
}
