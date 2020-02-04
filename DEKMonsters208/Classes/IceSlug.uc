//Code from Special Skaarj Packv4. Credit goes to its respectful owner.
//=============================================================================
// DEK Ice. 2x HP, 0.7x Speed, 1.50x Score, 1.5x Mass based off Poison Slug
//=============================================================================
class IceSlug extends DCSlith;

var int IceLifespan;
var int IceModifier;
var Sound FreezeSound;
var float IceBeamMultiplier, HeatDamageMultiplier;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield' || P.class == class'IceBrute' || P.Class == class'IceChildGasbag' || P.Class == class'IceChildSkaarjPupae' || P.Class == class'IceGasbag' || P.Class == class'IceGiantGasbag' || P.Class == class'IceKrall' || P.Class == class'IceWarlord' || P.Class == class'IceManta' || P.Class == class'IceMercenary' || P.Class == class'IceNali' || P.Class == class'IceNaliFighter' || P.Class == class'IceQueen' || P.Class == class'IceRazorfly' || P.Class == class'IceSkaarjPupae' || P.Class == class'IceSkaarjSniper' || P.Class == class'IceSkaarjFreezing' || P.Class == class'IceSlith' || P.Class == class'IceSlug' || P.Class == class'IceTitan');
	else
		return ( P.class == class'IceBrute' || P.Class == class'IceChildGasbag' || P.Class == class'IceChildSkaarjPupae' || P.Class == class'IceGasbag' || P.Class == class'IceGiantGasbag' || P.Class == class'IceKrall' || P.Class == class'IceWarlord' || P.Class == class'IceManta' || P.Class == class'IceMercenary' || P.Class == class'IceNali' || P.Class == class'IceNaliFighter' || P.Class == class'IceQueen' || P.Class == class'IceRazorfly' || P.Class == class'IceSkaarjPupae' || P.Class == class'IceSkaarjSniper' || P.Class == class'IceSkaarjFreezing' || P.Class == class'IceSlith' || P.Class == class'IceSlug' || P.Class == class'IceTitan');
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

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	//These local variables are just for bio spawning
    local int i;
    local IceSlugMiniBioGlob Glob;
    local rotator rot;
    local vector start;

    AmbientSound = None;
    bCanTeleport = false;
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;

	HitDamageType = DamageType; // these are replicated to other clients
    TakeHitLocation = HitLoc;
	LifeSpan = RagdollLifeSpan;

    GotoState('Dying');

	Velocity += TearOffMomentum;
    BaseEyeHeight = Default.BaseEyeHeight;
	if(PhysicsVolume.bWaterVolume)
		PlayAnim('Dead2',1.2,0.05);
	else
	{
		SetPhysics(PHYS_Falling);
		PlayAnim('Dead1',1.2,0.05);
	}

    //When killed, Slug ejects two goops of bio.
    if ( Role == ROLE_Authority )
	{
        for (i=0; i<2; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			Glob = Spawn( class 'IceSlugMiniBioGlob',, '', Start, rot);
		}
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
     IceModifier=1
     IceBeamMultiplier=0.500000
     HeatDamageMultiplier=1.500000
     AmmunitionClass=Class'DEKMonsters208.IceSlugAmmo'
     ScoringValue=14
     GibGroupClass=Class'DEKMonsters208.IceGibGroup'
     GroundSpeed=469.000000
     WaterSpeed=455.000000
     Health=787.5
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
     DrawScale=2.000000
     Skins(0)=Shader'DEKMonstersTexturesMaster206E.IceMonsters.IceSlithShader'
     Skins(1)=Shader'DEKMonstersTexturesMaster206E.IceMonsters.IceSlithShader'
     CollisionRadius=96.000000
     CollisionHeight=94.000000
     Mass=750.000000
}
