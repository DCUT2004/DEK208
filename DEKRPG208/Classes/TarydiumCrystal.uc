class TarydiumCrystal extends Pawn;

var byte Team;
var config float TargetRadius;
var Pawn Spawner;

#exec OBJ LOAD FILE=..\StaticMeshes\AW-2004Crystals.usx

replication
{
	reliable if (Role == ROLE_Authority)
		Spawner;
}

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

simulated function Timer()
{
	local Controller C;
	local MissionMultiplayerInv MMPI;
	
	C = Level.ControllerList;
	while (C != None)
	{	
		if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn.IsA('Monster') && (C.Pawn.GetTeamNum() != GetTeamNum()) && VSize(C.Pawn.Location - Self.Location) < TargetRadius && FastTrace(C.Pawn.Location, Self.Location) && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow'))
		{
		    if (C.Enemy == None || FRand() < 0.50 )
				MonsterController(C).ChangeEnemy(Self, C.CanSee(Self));
		}
		C = C.NextController;
	}
	if (Spawner != None)
		MMPI = MissionMultiplayerInv(Spawner.FindInventoryType(class'MissionMultiplayerInv'));
	if (Spawner != None && Spawner.Health > 0 && MMPI != None && !MMPI.stopped && MMPI.Countdown <= 0 && MMPI.TarydiumKeepActive)
	{
		MMPI.UpdateCounts(1);
	}
	if (Spawner == None || Spawner.Health <= 0)
		Destroy();
}

event EncroachedBy( actor Other )
{
	// do nothing. Adding this stub stops telefragging
}

defaultproperties
{	
   	bCanBeBaseForPawns=True
	bNoTeamBeacon=True
	HealthMax=2000.000000
	Health=2000
	ControllerClass=None
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'AW-2004Crystals.Crops.CrystalOutcrop1'
	//Skins(0)=Shader'AW-2004Shaders.Shaders.StoneScaler'
	bOrientOnSlope=True
	bAlwaysRelevant=True
	bIgnoreVehicles=True
	Physics=PHYS_Falling
	NetUpdateFrequency=4.000000
	DrawScale=1.200000
	AmbientGlow=10
	bShouldBaseAtStartup=False
	CollisionRadius=29.500000
	CollisionHeight=15.000000
	bBlockPlayers=True
	bUseCollisionStaticMesh=True
	Mass=10000.000000
	TargetRadius=1600.00
}
