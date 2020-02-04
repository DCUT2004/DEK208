class FrostTrap extends Weapon
	config(DEKWeapons);

#exec OBJ LOAD FILE=HudContent.utx

var array<FrostTrapProjectile> Mines;
var int CurrentMines; //should be sync'ed with Mines.length
var int MaxMines;
var color FadedColor;

replication
{
	reliable if (bNetOwner && bNetDirty && ROLE == ROLE_Authority)
		CurrentMines;
	reliable if (ROLE == ROLE_Authority)
		MaxMines;
}

simulated function DrawWeaponInfo(Canvas Canvas)
{
	NewDrawWeaponInfo(Canvas, 0.705*Canvas.ClipY);
}

simulated function NewDrawWeaponInfo(Canvas Canvas, float YPos)
{
	local int i, Half;
	local float ScaleFactor;

	ScaleFactor = 99 * Canvas.ClipX/3200;
	Half = (MaxMines + 1) / 2;
	Canvas.Style = ERenderStyle.STY_Alpha;
	Canvas.DrawColor = class'HUD'.Default.WhiteColor;
	for (i = 0; i < Half; i++)
	{
		if (i >= CurrentMines)
			Canvas.DrawColor = FadedColor;
		Canvas.SetPos(Canvas.ClipX - (i+1) * ScaleFactor * 1.25, YPos);
		Canvas.DrawTile(Material'HudContent.Generic.HUD', ScaleFactor, ScaleFactor, 324, 325, 54, 54);
	}
	for (i = Half; i < MaxMines; i++)
	{
		if (i >= CurrentMines)
			Canvas.DrawColor = FadedColor;
		Canvas.SetPos(Canvas.ClipX - (i-Half+1) * ScaleFactor * 1.25, YPos - ScaleFactor);
		Canvas.DrawTile(Material'HudContent.Generic.HUD', ScaleFactor, ScaleFactor, 324, 325, 54, 54);
	}
}

simulated function bool HasAmmo()
{
    if (CurrentMines > 0)
    	return true;

    return Super.HasAmmo();
}

simulated function bool CanThrow()
{
	if ( AmmoAmount(0) <= 0 )
		return false;

	return Super.CanThrow();
}

simulated function OutOfAmmo()
{
}

simulated singular function ClientStopFire(int Mode)
{
	if (Mode == 1 && !HasAmmo())
		DoAutoSwitch();

	Super.ClientStopFire(Mode);
}

simulated function Destroyed()
{
	local int x;

	if (Role == ROLE_Authority)
	{
		for (x = 0; x < Mines.Length; x++)
			if (Mines[x] != None)
				Mines[x].Explode(Mines[x].Location, vect(0,0,1));
		Mines.Length = 0;
	}

	Super.Destroyed();
}

// AI Interface
function float GetAIRating()
{
	local Bot B;
	local float EnemyDist;
	local vector EnemyDir;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return AIRating;
	if ( B.Enemy == None )
	{
		if ( (B.Target != None) && VSize(B.Target.Location - B.Pawn.Location) > 1000 )
			return 0.2;
		return AIRating;
	}

	// if retreating, favor this weapon
	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if ( EnemyDist > 1500 )
		return 0.1;
	if ( B.IsRetreating() )
		return (AIRating + 0.4);
	if ( -1 * EnemyDir.Z > EnemyDist )
		return AIRating + 0.1;
	if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon )
		return (AIRating + 0.3);
	if ( EnemyDist > 1000 )
		return 0.35;
	return AIRating;
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	local int x;

	if (CurrentMines >= MaxMines || (AmmoAmount(0) <= 0 && FireMode[0].NextFireTime <= Level.TimeSeconds))
		return 1;

	for (x = 0; x < Mines.length; x++)
		if (Mines[x] != None && Pawn(Mines[x].Base) != None)
			return 1;

	return 0;
}

function float SuggestAttackStyle()
{
	local Bot B;
	local float EnemyDist;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0.4;

	EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
	if ( EnemyDist > 1500 )
		return 1.0;
	if ( EnemyDist > 1000 )
		return 0.4;
	return -0.4;
}

function float SuggestDefenseStyle()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	if ( VSize(B.Enemy.Location - Instigator.Location) < 1600 )
		return -0.6;
	return 0;
}

// End AI Interface

simulated function AnimEnd(int Channel)
{
    local name anim;
    local float frame, rate;
    GetAnimParams(0, anim, frame, rate);

    if (anim == 'AltFire')
        LoopAnim('Hold', 1.0, 0.1);
    else
        Super.AnimEnd(Channel);
}

defaultproperties
{
     MaxMines=1
     FadedColor=(B=128,G=128,R=128,A=128)
     FireModeClass(0)=Class'DEKRPG208.FrostTrapFire'
     FireModeClass(1)=Class'DEKRPG208.FrostTrapAltFire'
     PutDownAnim="PutDown"
     SelectAnimRate=3.100000
     PutDownAnimRate=2.500000
     PutDownTime=0.200000
     SelectSound=Sound'WeaponSounds.FlakCannon.SwitchToFlakCannon'
     SelectForce="SwitchToFlakCannon"
     AIRating=0.550000
     CurrentRating=0.550000
     bCanThrow=False
     Description="The Frost Trap automatically detones when an enemy target comes into contact."
     EffectOffset=(X=30.000000,Y=10.000000,Z=-10.000000)
     DisplayFOV=60.000000
     Priority=10
     HudColor=(B=251,R=193)
     SmallViewOffset=(X=23.000000,Y=6.000000,Z=-6.000000)
     CenteredOffsetY=-5.000000
     CenteredRoll=5000
     CenteredYaw=-300
     CustomCrosshair=15
     CustomCrossHairTextureName="ONSInterface-TX.grenadeLauncherReticle"
     GroupOffset=1
     PickupClass=Class'DEKRPG208.FrostTrapPickup'
     PlayerViewOffset=(X=11.000000)
     BobDamping=2.200000
     AttachmentClass=Class'XWeapons.BallAttachment'
     IconMaterial=Texture'HUDContent.Generic.HUD'
     IconCoords=(X1=434,Y1=253,X2=506,Y2=292)
     ItemName="Frost Trap"
     Mesh=SkeletalMesh'Weapons.BallLauncher_1st'
     DrawScale=0.400000
     AmbientGlow=64
}
