class HolographActor extends Pawn
	config(UT2004RPG);

var byte Team;
var Pawn PlayerSpawner;
var config float TargetRadius;

simulated function PostBeginPlay()
{
	SetCollision(False,false,False);
	bCollideWorld = True;
	
	Super.PreBeginPlay();
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

function Tick(float DeltaTime)
{
	local Monster M;
	
	foreach VisibleCollidingActors(class'Monster',M,TargetRadius,Self.Location)
	{
		if(M != None && M.Health > 0 && M.MaxFallSpeed != 100000)
		{
			if(M.Controller != None && M.Controller.Enemy != None && FriendlyMonsterInv(M.FindInventoryType(class'FriendlyMonsterInv')) == None && !ClassIsChildOf(M.Class, class'SMPNali') && !M.IsA('MissionCow'))
			{
				M.Controller.Enemy = Self;
				M.Controller.Target = Self;
				M.CanAttack(Self);
				M.RangedAttack(Self);
				M.Controller.Focus = self;
				M.Controller.FireWeaponAt(self);
			}
		}
	}
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	return;
}

defaultproperties
{
	 TargetRadius=1000.00
	 Lifespan=20.000
     bCanBeBaseForPawns=True
     bNoTeamBeacon=True
     HealthMax=100.000000
     Health=100
     ControllerClass=None
     DrawType=DT_Mesh
     bOrientOnSlope=True
     bAlwaysRelevant=True
     bIgnoreVehicles=True
     Physics=PHYS_None
     DrawScale=1.200000
	 Mesh=SkeletalMesh'XanRobots.EnigmaM'
     Skins(0)=FinalBlend'D-E-K-HoloGramFX.FullFB.HoloMaterial_3'
	 Skins(1)=FinalBlend'D-E-K-HoloGramFX.FullFB.HoloMaterial_3'
	 CollisionHeight=10.00
	 CollisionRadius=10.00
     AmbientGlow=10
     bShouldBaseAtStartup=False
     bBlockPlayers=False
     bUseCollisionStaticMesh=True
     Mass=10000.000000
}
