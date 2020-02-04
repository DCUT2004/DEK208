//=============================================================================
// DEK Ice. 2x HP, 0.7x Speed, 1.50x Score, 1.5x Mass
//=============================================================================

class IceQueen extends SMPQueen;

var bool bRocketDir;
var int IceLifespan;
var int IceModifier;
var bool SummonedMonster;
var RPGRules RPGRules;
var float IceBeamMultiplier, HeatDamageMultiplier;

function PostNetBeginPlay()
{
	Instigator = self;
	CheckController();
	Super.PostNetBeginPlay();
}

function CheckController()
{
	if (Instigator.ControllerClass == class'DEKFriendlyMonsterController')
		SummonedMonster = true;
	else
		SummonedMonster = false;
}


function SpawnChildren()
{
	local NavigationPoint N;
	local IceChildSkaarjPupae P;

	For ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
		if(numChildren>=MaxChildren)
			return;
		else if(vsize(N.Location-Location)<2000 && FastTrace(N.Location,Location))
		{
			P=spawn(class 'IceChildSkaarjPupae' ,self,,N.Location);
		    if(P!=none)
		    {
		    	P.LifeSpan=20+Rand(10);
				numChildren++;
			}
		}

	}

}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield' || P.class == class'IceBrute' || P.Class == class'IceChildGasbag' || P.Class == class'IceChildSkaarjPupae' || P.Class == class'IceGasbag' || P.Class == class'IceGiantGasbag' || P.Class == class'IceKrall' || P.Class == class'IceWarlord' || P.Class == class'IceManta' || P.Class == class'IceMercenary' || P.Class == class'IceNali' || P.Class == class'IceNaliFighter' || P.Class == class'IceQueen' || P.Class == class'IceRazorfly' || P.Class == class'IceSkaarjPupae' || P.Class == class'IceSkaarjSniper' || P.Class == class'IceSkaarjFreezing' || P.Class == class'IceSlith' || P.Class == class'IceSlug' || P.Class == class'IceTitan');
	else
		return ( P.class == class'IceBrute' || P.Class == class'IceChildGasbag' || P.Class == class'IceChildSkaarjPupae' || P.Class == class'IceGasbag' || P.Class == class'IceGiantGasbag' || P.Class == class'IceKrall' || P.Class == class'IceWarlord' || P.Class == class'IceManta' || P.Class == class'IceMercenary' || P.Class == class'IceNali' || P.Class == class'IceNaliFighter' || P.Class == class'IceQueen' || P.Class == class'IceRazorfly' || P.Class == class'IceSkaarjPupae' || P.Class == class'IceSkaarjSniper' || P.Class == class'IceSkaarjFreezing' || P.Class == class'IceSlith' || P.Class == class'IceSlug' || P.Class == class'IceTitan' || P.Class == class'SMPQueen' || P.Class == class'DCQueen' || P.Class == class'PoisonQueen');
}

function PostBeginPlay()
{
	Local GameRules G;
	super.PostBeginPlay();
	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			RPGRules = RPGRules(G);
			break;
		}
	}

}

function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.5 * CollisionRadius * (X+Z-Y);
}

function PoisonTarget(Actor Victim, class<DamageType> DamageType)
{
	local FreezeInv Inv;
	local Pawn P;
	local MagicShieldInv MInv;

	P = Pawn(Victim);
	if (P != None && P.Controller != None && P.Health > 0 && !P.Controller.SameTeamAs(Instigator.Controller))
	{
		MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
		if (MInv == None)
		{
			Inv = FreezeInv(P.FindInventoryType(class'FreezeInv'));
			if (Inv == None)
			{
				Inv = spawn(class'FreezeInv', P,,, rot(0,0,0));
				Inv.Modifier = IceModifier;
				Inv.LifeSpan = IceLifespan;
				Inv.GiveTo(P);
			}
			else
			{
				Inv.Modifier = max(IceModifier,Inv.Modifier);
				Inv.LifeSpan = max(IceLifespan,Inv.LifeSpan);
			}
		}
		else
			return;
	}
}

function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local vector HitLocation, HitNormal;
	local actor HitActor;
	
	// check if still in melee range
	if ( (Controller.Target != None) && (VSize(Controller.Target.Location - Location) <= MeleeRange * 1.4 + Controller.Target.CollisionRadius + CollisionRadius)
		&& ((Physics == PHYS_Flying) || (Physics == PHYS_Swimming) || (Abs(Location.Z - Controller.Target.Location.Z) 
			<= FMax(CollisionHeight, Controller.Target.CollisionHeight) + 0.5 * FMin(CollisionHeight, Controller.Target.CollisionHeight))) )
	{	
		HitActor = Trace(HitLocation, HitNormal, Controller.Target.Location, Location, false);
		if ( HitActor != None )
			return false;

		// hee hee  got a hit. Poison the dude
		PoisonTarget(Controller.Target, class'MeleeDamage');

		return super.MeleeDamageTarget(hitdamage, pushdir);
	}
	return false;
}

function SpawnShot()
{
		local vector FireStart,X,Y,Z;
        local rotator ProjRot;
		local IceQueenSeekingProjectile S;
		if ( Controller != None )
		{
			GetAxes(Rotation,X,Y,Z);
			FireStart = GetFireStart(X,Y,Z);
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

            ProjRot = Controller.AdjustAim(SavedFireProperties,FireStart,1000);

            if ( bRocketDir )
				ProjRot.Yaw += 3072;
			else
				ProjRot.Yaw -= 3072;
			bRocketDir = !bRocketDir;
			S = Spawn(class'IceQueenSeekingProjectile',,,FireStart,ProjRot);
	        S.Seeking = Controller.Enemy;
			PlaySound(FireSound,SLOT_Interact);

			if ( bRocketDir )
				ProjRot.Yaw += 3072;
			else
				ProjRot.Yaw -= 3072;
			bRocketDir = !bRocketDir;
			S = Spawn(class'IceQueenSeekingProjectile',,,FireStart,ProjRot);
	        S.Seeking = Controller.Enemy;
			PlaySound(FireSound,SLOT_Interact);
        }
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	if (DamageType == class'DamTypeIceBeam' || DamageType == class'DamTypeFrostTrap')
	{
		Damage *= IceBeamMultiplier;
	}
	if (DamageType == class'DamTypeFireBall' || DamageType == class'DamTypeDEKSolarTurretBeam' || DamageType == class'DamTypeDEKSolarTurretHeatWave' || DamageType == class'DamTypeWildfireTrap' || DamageType == class'DamTypeFireBrute' || DamageType == class'DamTypeFireGasbag' || DamageType == class'DamTypeFireGiantGasbag' || DamageType == class'DamTypeFireKrall' || DamageType == class'DamTypeFireLord' || DamageType == class'DamTypeFireMercenary' || DamageType == class'DamTypeFireQueen' || DamageType == class'DamTypeFireSkaarjSuperHeat' || DamageType == class'DamTypeFireSkaarjTrooper' || DamageType == class'DamTypeFireSlith' || DamageType == class'DamTypeFireSlug' || DamageType == class'DamTypeFireTentacle' || DamageType == class'DamTypeFireTitan' || DamageType == class'DamTypeFireTitanSuperHeat' || DamageType == class'DamTypeMeteor')
	{
		Damage *= HeatDamageMultiplier;
	}
	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damagetype);
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     IceLifespan=3
     IceModifier=3
     IceBeamMultiplier=0.500000
     HeatDamageMultiplier=1.500000
     AmmunitionClass=Class'DEKMonsters208.IceQueenAmmo'
     ScoringValue=21
     GibGroupClass=Class'DEKMonsters208.IceGibGroup'
     GroundSpeed=420.000000
     AirSpeed=100.000000
     Health=1200
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.IceMonsters.IceQueenFinalBlend'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster206E.IceMonsters.IceQueenFinalBlend'
     Mass=1500.000000
}
