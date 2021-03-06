class DruidBlock extends Pawn;
#exec OBJ LOAD FILE=..\StaticMeshes\DEKStaticsMaster207P.usx
var byte Team;

function SetTeamNum(byte T)
{
    Team = T;
}

simulated function int GetTeamNum()
{
	return Team;
}

function Landed(vector hitNormal)
{
	Super.Landed(hitNormal);
	Velocity = vect(0,0,0);
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local int actualDamage;
	local Controller Killer;
	
	if ( damagetype == None )
	{
		if ( InstigatedBy != None )
			warn("No damagetype for damage by "$instigatedby$" with weapon "$InstigatedBy.Weapon);
		DamageType = class'DamageType';
	}

	if ( Role < ROLE_Authority )
		return;

	if ( Health <= 0 )
		return;

	if ((instigatedBy == None || instigatedBy.Controller == None) && DamageType.default.bDelayedDamage && DelayedDamageInstigatorController != None)
		instigatedBy = DelayedDamageInstigatorController.Pawn;

	if ( (InstigatedBy != None) && InstigatedBy.HasUDamage() )
		Damage *= 2;

	momentum = vect(0,0,0);		// blocks do not move

	if (self != None)
	{
		actualDamage = Level.Game.ReduceDamage(Damage, self, instigatedBy, HitLocation, momentum, DamageType);
		momentum = vect(0,0,0);		// reset in case changed
	}

	Health -= actualDamage;
	if ( HitLocation == vect(0,0,0) )
		HitLocation = Location;

	PlayHit(actualDamage,InstigatedBy, hitLocation, damageType, momentum);
	if ( Health <= 0 )
	{
		// pawn died
		if ( DamageType.default.bCausedByWorld && (instigatedBy == None || instigatedBy == self) && LastHitBy != None )
			Killer = LastHitBy;
		else if ( instigatedBy != None )
			Killer = instigatedBy.GetKillerController();
		if ( Killer == None && DamageType.Default.bDelayedDamage )
			Killer = DelayedDamageInstigatorController;
		Died(Killer, damageType, HitLocation);
	}
	else
	{
		if ( Controller != None )
			Controller.NotifyTakeHit(instigatedBy, HitLocation, actualDamage, DamageType, momentum);
		if ( instigatedBy != None && instigatedBy != self )
			LastHitBy = instigatedBy.Controller;
	}
	MakeNoise(1.0);

	if (Health <= 0)
		destroy();
	else
		Velocity = vect(0,0,0);
}

//event EncroachedBy( actor Other )
//{
	// do nothing. Adding this stub stops telefragging of blocks
//}

defaultproperties
{
     bCanBeBaseForPawns=True
     bNoTeamBeacon=True
     HealthMax=2000.000000
     Health=2000
     ControllerClass=None
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DEKStaticsMaster207P.Meshes.TestBlock'
     bOrientOnSlope=True
     bAlwaysRelevant=True
     bIgnoreVehicles=True
     Physics=PHYS_Falling
     NetUpdateFrequency=4.000000
     DrawScale=1.200000
     Skins(0)=Texture'DEKRPGTexturesMaster207P.Skins.ConcreteBlock'
     AmbientGlow=10
     bShouldBaseAtStartup=False
     CollisionRadius=29.500000
     CollisionHeight=15.000000
     bBlockPlayers=True
     bUseCollisionStaticMesh=True
     Mass=10000.000000
}
