// Invasion AVRiL - Player held anti-Warlord weapon
// from the original ONSAVRIL code

class INAVRiL extends Weapon
	config(User);

var Material BaseMaterial;
var Material ReticleOFFMaterial;
var Material ReticleONMaterial;
var bool bLockedOn;
var pawn HomingTarget;  //now it's all pawn
var float LockCheckFreq, LockCheckTime;
var float MaxLockRange, LockAim;
var Color CrosshairColor;
var float CrosshairX, CrosshairY;
var Texture CrosshairTexture;
var int bmonsterLockon[12]; // 0-Warlord, 1-brute, 2-skaarj, 3-krall, 4-gasbag, 5-manta, 6-razorfly, 7-Mercenary, 8-Titan, 9-Queen, 10-Slith, 11-Nali
var int MaxM;
var string monsterClassName[5];
var string packName;
var int version;
var int MinimumHealth, MinimumHealthFM; //Minimum monster health required for the lock on

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
	local Pawn P;

    V = Vehicle(Other);
    m = Monster(other);
	P = Pawn(Other);

    if (V == None && m == None && P == None )
        return false;
    else if ( m != None && Instigator.GetTeamNum() != m.GetTeamNum() && !ClassIsChildOf(m.class, class'SMPNali') && !ClassIsChildOf(m.class, class'SMPNaliCow'))
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
    				case 7:if (ClassIsChildOf(m.Class,class<Monster>(DynamicLoadObject(packName$version$monsterClassName[0],class'Class')))) return true;break;
    				case 8:if (ClassIsChildOf(m.Class,class<Monster>(DynamicLoadObject(packName$version$monsterClassName[1],class'Class')))) return true;break;
    				case 9:if (ClassIsChildOf(m.Class,class<Monster>(DynamicLoadObject(packName$version$monsterClassName[2],class'Class')))) return true;break;
    				case 10:if (ClassIsChildOf(m.Class,class<Monster>(DynamicLoadObject(packName$version$monsterClassName[3],class'Class')))) return true;break;
    				case 11:if (ClassIsChildOf(m.Class,class<Monster>(DynamicLoadObject(packName$version$monsterClassName[4],class'Class')))) return true;break;
    			}
    		}
    	return false;
     }
    else if (V == None || V == Instigator)
	    return false;
		
	else if (P == None || P == Instigator || !P.bProjTarget)
        return false;	

    return (V.Team != Instigator.PlayerReplicationInfo.Team.TeamIndex);
}


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Skins[0] = ReticleOFFMaterial;
	Skins[1] = BaseMaterial;
}

simulated function OutOfAmmo()
{
}

simulated function ActivateReticle(bool bActivate)
{
    if(bActivate)
        Skins[0] = ReticleONMaterial;
    else
        Skins[0] = ReticleOFFMaterial;
}

simulated function WeaponTick(float deltaTime)
{
	local vector StartTrace;
	local rotator Aim;
	local float BestAim, BestDist;
	local bool bLastLockedOn;
	local pawn LastHomingTarget;

	if (Role < ROLE_Authority)
	{
		ActivateReticle(bLockedOn);
		return;
	}

	if (Instigator == None || Instigator.Controller == None)
	{
		LoseLock();
		ActivateReticle(false);
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
		Aim = Instigator.GetViewRotation();
		BestAim = LockAim;
		HomingTarget = Instigator.Controller.PickTarget(BestAim, BestDist, Vector(Aim), StartTrace, MaxLockRange);
		bLockedOn = CanLockOnTo(HomingTarget);
	}

	ActivateReticle(bLockedOn);
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

simulated function DetachFromPawn(Pawn P)
{
	LoseLock();
	Super.DetachFromPawn(P);
}

simulated event RenderOverlays(Canvas Canvas)
{
	if (!FireMode[1].bIsFiring || INAVRiLAltFire(FireMode[1]) == None)
	{
		if (bLockedOn)
		{
			Canvas.DrawColor = CrosshairColor;
			Canvas.DrawColor.A = 200;
			Canvas.Style = ERenderStyle.STY_Alpha;
			Canvas.SetPos(Canvas.SizeX*0.5-CrosshairX, Canvas.SizeY*0.5-CrosshairY);
			Canvas.DrawTile(CrosshairTexture, CrosshairX*2.0, CrosshairY*2.0, 0.0, 0.0, CrosshairTexture.USize, CrosshairTexture.VSize);
		}

		Super.RenderOverlays(Canvas);
	}
}

// AI Interface
function float SuggestAttackStyle()
{
    return -0.4;
}

function float SuggestDefenseStyle()
{
    return 0.5;
}

function byte BestMode()
{
	return 0;
}

function float GetAIRating()
{
	local Bot B;
	local float ZDiff, dist, Result;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	if (B.Enemy == None)
		return 0;

	result = AIRating;
	ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;
	if ( ZDiff < -200 )
		result += 0.1;
	dist = VSize(B.Enemy.Location - Instigator.Location);
	if ( dist > 2000 )
		return ( FMin(2.0,result + (dist - 2000) * 0.0002) );

	return result;
}

function bool RecommendRangedAttack()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return true;

	return ( VSize(B.Enemy.Location - Instigator.Location) > 2000 * (1 + FRand()) );
}
// end AI Interface

defaultproperties
{
     BaseMaterial=Texture'VMWeaponsTX.PlayerWeaponsGroup.AVRiLtex'
     ReticleOFFMaterial=Shader'VMWeaponsTX.PlayerWeaponsGroup.AVRiLreticleTEX'
     ReticleONMaterial=Shader'VMWeaponsTX.PlayerWeaponsGroup.AVRiLreticleTEXRed'
     LockCheckFreq=0.200000
     MaxLockRange=15000.000000
     LockAim=0.996000
     CrossHairColor=(B=225,G=55,R=90,A=200)
     CrosshairX=32.000000
     CrosshairY=32.000000
     CrosshairTexture=Texture'ONSInterface-TX.avrilRETICLE'
     bmonsterLockon(0)=1
     bmonsterLockon(1)=1
     bmonsterLockon(2)=1
     bmonsterLockon(8)=1
     bmonsterLockon(9)=1
     MaxM=6
     MonsterClassName(0)=".SMPMercenary"
     MonsterClassName(1)=".SMPTitan"
     MonsterClassName(2)=".SMPQueen"
     MonsterClassName(3)=".SMPSlith"
     MonsterClassName(4)=".SMPNaliFighter"
     packName="satoreMonsterPackv"
     Version=107
     FireModeClass(0)=Class'DEKWeapons208.INAVRiLFire'
     FireModeClass(1)=Class'DEKWeapons208.INAVRiLAltFire'
     PutDownAnim="PutDown"
     SelectAnimRate=1.500000
     PutDownAnimRate=1.000000
     BringUpTime=0.400000
     SelectSound=Sound'WeaponSounds.FlakCannon.SwitchToFlakCannon'
     SelectForce="SwitchToFlakCannon"
     AIRating=0.590000
     CurrentRating=0.590000
     Description="The DEK AVRiL, or Anti-Vehicle Rocket Launcher, shoots homing missiles that pack quite a punch. These have been modified to target monsters as well as vehicles."
     EffectOffset=(X=100.000000,Y=32.000000,Z=-20.000000)
     DisplayFOV=45.000000
     Priority=200
     HudColor=(B=225,G=55,R=90)
     SmallViewOffset=(X=116.000000,Y=43.500000,Z=-40.500000)
     CenteredRoll=5500
     CustomCrosshair=6
     CustomCrossHairColor=(B=225,G=55,R=90,A=200)
     CustomCrossHairTextureName="ONSInterface-TX.avrilRETICLEtrack"
     MinReloadPct=0.000000
     InventoryGroup=2
     GroupOffset=1
     PickupClass=Class'DEKWeapons208.INAVRiLPickup'
     PlayerViewOffset=(X=100.000000,Y=35.500000,Z=-32.500000)
     BobDamping=2.200000
     AttachmentClass=Class'Onslaught.ONSAVRiLAttachment'
     IconMaterial=Texture'HUDContent.Generic.HUD'
     IconCoords=(X1=429,Y1=212,X2=508,Y2=251)
     ItemName="AVRiL"
     Mesh=SkeletalMesh'ONSWeapons-A.AVRiL_1st'
     AmbientGlow=56
}
