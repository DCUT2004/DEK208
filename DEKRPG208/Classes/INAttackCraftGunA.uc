//-----------------------------------------------------------
// FROM the ONSAVRIL/INAVRIL CODE with modif
//-----------------------------------------------------------
class INAttackCraftGunA extends ONSAttackCraftGun;

var bool bLockedOn;
var pawn HomingTarget;
var int bmonsterLockon[12]; // 0-Warlord, 1-brute, 2-skaarj, 3-krall, 4-gasbag, 5-manta, 6-razorfly, 7-Mercenary, 8-Titan, 9-Queen, 10-Slith, 11-Nali
var int MaxM;
var string monsterClassName[5];
var float LockCheckFreq, LockCheckTime;
var float MaxLockRange, LockAim;
var string packName;
var int version;
var int MinimumHealth, MinimumHealthFM ; //Minimum monster health required for the lock on

replication
{
	reliable if (bNetDirty && bNetOwner && Role == ROLE_Authority)
		bLockedOn, HomingTarget;
}

// myPart.. allow the lock on Monsters
function bool CanLockOnTo(Actor Other)
{
    local Vehicle V;
    local Monster m;
    local int i;

    V = Vehicle(Other);
    m = Monster(other);

    if (V == None && m == None)
        return false;
    else if ( m != None && Instigator.GetTeamNum() != m.GetTeamNum())
    {
        if (m.bCanFly && m.default.Health >= MinimumHealthFM || !m.bCanFly && m.default.Health >= MinimumHealth)
        {
              return true;
        }
    	for (i=0;i<=MaxM;i++)
    		if (bool(bmonsterLockon[i]))
    		{
    			switch(i)
    			{
    			    case 0:if (WarLord(Other) != None) return true;break;
    				case 1:if (Brute(Other) != None) return true;break;
    				case 2:if (Skaarj(Other) != None) return true;break;
    				case 3:if (Krall(Other) != None) return true;break;
    				case 4:if (Gasbag(Other) != None) return true;break;
    				case 5:if (manta(Other) != None) return true;break;
    				case 6:if (Razorfly(Other) != None) return true;break;
    				case 7:if (monster(Other) != None) return true;break;
    				case 8:if (ClassIsChildOf(m.Class,class<Monster>(DynamicLoadObject(packName$version$monsterClassName[0],class'Class')))) return true;break;
    				case 9:if (ClassIsChildOf(m.Class,class<Monster>(DynamicLoadObject(packName$version$monsterClassName[1],class'Class')))) return true;break;
    				case 10:if (ClassIsChildOf(m.Class,class<Monster>(DynamicLoadObject(packName$version$monsterClassName[2],class'Class')))) return true;break;
    				case 11:if (ClassIsChildOf(m.Class,class<Monster>(DynamicLoadObject(packName$version$monsterClassName[3],class'Class')))) return true;break;
					case 12:if (ClassIsChildOf(m.Class,class<Monster>(DynamicLoadObject(packName$version$monsterClassName[4],class'Class')))) return true;break;
    			}
    		}
    	return false;
    }
    else if (V == None || V == Instigator)
	return false;

    return (V.Team != Instigator.PlayerReplicationInfo.Team.TeamIndex && (V.bCanFly || V.IsA('ONSHoverCraft')));
}

function byte BestMode()
{
	if ( Instigator.Controller.Enemy != None
	     && ( CanLockOnTo(Instigator.Controller.Enemy)) && FRand() < 0.75 )
		return 1;
	else
		return 0;
}

state ProjectileFireMode
{
	function Fire(Controller C)
	{
		if (Vehicle(Owner) != None && Vehicle(Owner).Team < 2)
			ProjectileClass = TeamProjectileClasses[Vehicle(Owner).Team];
		else
			ProjectileClass = TeamProjectileClasses[0];

		Super.Fire(C);
	}

	function AltFire(Controller C)
	{
		local INAttackCraftMissleA M;
		local pawn P, Best;
		local float CurAim, BestAim;

		M = INAttackCraftMissleA(SpawnProjectile(AltFireProjectileClass, True));
		if (M != None)
		{
			if (AIController(Instigator.Controller) != None)
			{
				P = Instigator.Controller.Enemy;
				if (P != None && CanLockOnTo(P) && Instigator.FastTrace(P.Location, Instigator.Location))
				{
					M.SetHomingTarget(P);
					HomingTarget=P;
				}
			}
			else
			{
				BestAim = MinAim;
				ForEach DynamicActors(class'Pawn',P)
					if (CanLockOnTo(P) && P != Instigator )
					{
						CurAim = Normal (P.Location - WeaponFireLocation) dot vector(WeaponFireRotation);
						if (CurAim > BestAim && Instigator.FastTrace(P.Location, Instigator.Location))
						{
							Best = P;
							BestAim = CurAim;
						}
					}
				if (Best != None)
				{
					M.SetHomingTarget(Best);
					HomingTarget=Best;
				}
			}
		}
	}
}
simulated function Tick(float deltaTime)
{
	local vector StartTrace;
	local rotator Aim;
	local float BestAim, BestDist;
	local bool bLastLockedOn;
	local pawn LastHomingTarget;

	if (Role < ROLE_Authority)
	{
		return;
	}

	if (Instigator == None || Instigator.Controller == None)
	{
		LoseLock();
		return;
	}

	if (Level.TimeSeconds < LockCheckTime)
		return;

	LockCheckTime = Level.TimeSeconds + LockCheckFreq;

	bLastLockedOn = bLockedOn;
	LastHomingTarget = HomingTarget;
	if (AIController(Instigator.Controller) != None)
	{
		if (CanLockOnTo(AIController(Instigator.Controller).Focus))
		{
			HomingTarget = pawn(AIController(Instigator.Controller).Focus);
			bLockedOn = true;
		}
		else
			bLockedOn = false;
	}
	else if ( HomingTarget == None || Normal(HomingTarget.Location - Instigator.Location) Dot vector(Instigator.Controller.Rotation) < LockAim
		  || VSize(HomingTarget.Location - Instigator.Location) > MaxLockRange
		  || !FastTrace(HomingTarget.Location, Instigator.Location + Instigator.EyeHeight * vect(0,0,1)) )
	{

		StartTrace = Instigator.Location + Instigator.EyePosition();
		Aim = Instigator.Controller.Rotation;
		BestAim = LockAim;
		HomingTarget = Instigator.Controller.PickTarget(BestAim, BestDist, Vector(Aim), StartTrace, MaxLockRange);

		bLockedOn = CanLockOnTo(HomingTarget);
	}

	if (!bLastLockedOn && bLockedOn)
	{
		if ( HomingTarget != None && vehicle(HomingTarget) != None)
			vehicle(HomingTarget).NotifyEnemyLockedOn();
		if ( PlayerController(Instigator.Controller) != None )
			PlayerController(Instigator.Controller).ClientPlaySound(Sound'WeaponSounds.LockOn');
	}
	else if (bLastLockedOn && !bLockedOn && LastHomingTarget != None && vehicle(LastHomingTarget) != None)
		vehicle(LastHomingTarget).NotifyEnemyLostLock();
}

function LoseLock()
{
	if (bLockedOn && HomingTarget != None && vehicle(HomingTarget) != None)
		vehicle(HomingTarget).NotifyEnemyLostLock();
	bLockedOn = false;
}

simulated function Destroyed()
{
	LoseLock();
	super.Destroyed();
}

defaultproperties
{
     bmonsterLockon(0)=1
     bmonsterLockon(1)=1
     bmonsterLockon(2)=1
     bmonsterLockon(3)=1
     bmonsterLockon(4)=1
     bmonsterLockon(5)=1
     bmonsterLockon(6)=1
     bmonsterLockon(8)=1
     bmonsterLockon(9)=1
     MaxM=7
     MonsterClassName(0)=".SMPMercenary"
     MonsterClassName(1)=".SMPTitan"
     MonsterClassName(2)=".SMPQueen"
     MonsterClassName(3)=".SMPSlith"
     MonsterClassName(4)=".SMPNaliFighter"
     LockCheckFreq=0.200000
     MaxLockRange=17000.000000
     LockAim=0.996000
     packName="satoreMonsterPackv"
     Version=104
     TeamProjectileClasses(0)=Class'DEKRPG208.DEKONSAttackCraftPlasmaProjectileRed'
     TeamProjectileClasses(1)=Class'DEKRPG208.DEKONSAttackCraftPlasmaProjectileBlue'
     ProjectileClass=Class'DEKRPG208.DEKONSAttackCraftPlasmaProjectileBlue'
     AltFireProjectileClass=Class'DEKRPG208.INAttackCraftMissleA'
}
