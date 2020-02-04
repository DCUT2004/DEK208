class DEKRailGun extends SniperRifle;

#exec OBJ LOAD FILE="..\Animations\DEKAnimationMaster206.ukx"
#exec OBJ LOAD FILE=DEKWeaponsMaster206.utx package=DEKWeapons208

var int weaponLevel;
var material fullchargeSkin;
var bool		bDoOverlay;
var() vector ChargeEffectOffset;

replication
{
	reliable if ( Role == Role_Authority )
		ClientSetWeaponLevel,WeaponLevel,bDoOverlay;
}

// Set initial powerlevel settings
simulated function PostNetBeginPlay()
{
	/*if ( Role == ROLE_Authority )
	{
		ServerSetWeaponLevel(false);
	}*/
	super.PostNetBeginPlay();
}

simulated function Destroyed()
{
	if ( DEKRailGunFire(FireMode[0]).ChargeEffect != None )
	{
		DEKRailGunFire(FireMode[0]).ChargeEffect.Destroy();
	}

	super.Destroyed();
}

// We need playfireend() for our sniperfire mode
simulated event StopFire(int Mode)
{
	if ( FireMode[Mode].bIsFiring )
	    FireMode[Mode].bInstantStop = true;
    
	if (Instigator.IsLocallyControlled() /*&& !FireMode[Mode].bFireOnRelease*/)
        FireMode[Mode].PlayFireEnd();

    FireMode[Mode].bIsFiring = false;
    FireMode[Mode].StopFiring();
    
	if (!FireMode[Mode].bFireOnRelease)
        ZeroFlashCount(Mode);
}

simulated function vector GetEffectStart()
{
    local Vector X,Y,Z;

    // jjs - this function should actually never be called in third person views
    // any effect that needs a 3rdp weapon offset should figure it out itself

    // 1st person
    if (Instigator.IsFirstPerson())
    {
        if ( WeaponCentered() )
			return CenteredEffectStart();
 
        GetViewAxes(X, Y, Z);
			return (Instigator.Location +
				Instigator.CalcDrawOffset(self) +
				EffectOffset.X * X +
				EffectOffset.Y * Y * Hand +
				EffectOffset.Z * Z);
    }
    // 3rd person
    else
    {
        return (Instigator.Location +
            Instigator.EyeHeight*Vect(0,0,0.5) +
            Vector(Instigator.Rotation) * 40.0);
    }
}

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	super.DisplayDebug(Canvas,YL,YPOs);
	Canvas.DrawText("WeaponLevel "$WeaponLevel);
	Canvas.DrawText("DoOverlay "$bDoOverlay);
}

simulated function DrawPowerBar(Canvas Canvas)
{
	if ( WeaponLevel == 2 && !Instigator.HasUDamage() && bDoOverlay )
		OverLayMaterial=FullChargeSkin;

}

function SetBerserkWeaponLevel(optional bool bSetLevel, optional int newLevel)
{
	if (WeaponLevel < 2 )
	{
		FireMode[0].fireRate *= 0.75;
		FireMode[1].FireRate *= 0.75;
		WeaponLevel++;

		if ( WeaponLevel >= 2 && ThirdPersonActor != None )
			WeaponAttachment(ThirdPersonActor).SetOverlayMaterial(FullChargeSkin,999,true);
		
		if ( ROLE == Role_Authority && Level.NetMode != NM_StandAlone )
			ClientSetBerserkWeaponLevel(bSetLevel,WeaponLevel);
	}
}

simulated function ClientSetBerserkWeaponLevel(optional bool bSetLevel, optional int newLevel)
{
	FireMode[0].fireRate *= 0.75;
	FireMode[1].FireRate *= 0.75;
}

function ServerSetWeaponLevel(optional bool bSetLevel, optional int newLevel)
{
	local Mutator M;
	
	// Superberserk support :S
	for (M = Level.Game.BaseMutator; M != None; M = M.NextMutator)
	{
		if ( M.IsA('MutBerserk') )
		{
			SetBerserkWeaponLevel(bSetLevel, newLevel);
			return;
		}
	}

	if ( bSetLevel )
	{
		if ( newLevel == 1 )
		{
			FireMode[0].FireRate=0.6;
			DEKRailGunFire(FireMode[0]).EOFireRate=0.6;
			WeaponLevel=1;
		}
		else if ( newLevel == 2 )
		{
			FireMode[0].FireRate=0.55;
			DEKRailGunFire(FireMode[0]).EOFireRate=0.55;
			WeaponLevel=2;
		}
	}
	else
	{
		if (WeaponLevel == 0 )
		{
			FireMode[0].FireRate=0.6;
			DEKRailGunFire(FireMode[0]).EOFireRate=0.6;
			//FireMode[1].FireRate-=0.025;
			
			WeaponLevel=1;
		}
		else if ( WeaponLevel == 1 )
		{
			FireMode[0].FireRate=0.55;
			DEKRailGunFire(FireMode[0]).EOFireRate=0.55;
			WeaponLevel=2;
			if ( ThirdPersonActor != None )
				WeaponAttachment(ThirdPersonActor).SetOverlayMaterial(FullChargeSkin,999,true);
		}

		NewLevel=WeaponLevel;

	}
	
	if ( Level.NetMode == NM_DedicatedServer )
		ClientSetWeaponLevel(bSetLevel,newLevel);
	
}

simulated function ClientSetWeaponLevel(optional bool bSetLevel, optional int newLevel)
{
	if ( newLevel == 1 )
	{
		FireMode[0].FireRate=0.6;
		DEKRailGunFire(FireMode[0]).EOFireRate=0.6;
	}
	else if ( newLevel == 2 )
	{
		FireMode[0].FireRate=0.55;
		DEKRailGunFire(FireMode[0]).EOFireRate=0.55;
	}
}
/*
function ServerSetWeaponLevel()
{

	if (WeaponLevel < 2 )
	{
		FireMode[0].FireRate-=0.02;
		//FireMode[1].FireRate-=0.025;

		if ( Level.NetMode == NM_DedicatedServer )
			ClientSetWeaponLevel();
		
		WeaponLevel+=1;fl
	}
	if ( WeaponLevel == 2 )
		WeaponAttachment(ThirdPersonActor).SetOverlayMaterial(FullChargeSkin,999,true);
}

simulated function ClientSetWeaponLevel()
{
		FireMode[0].FireRate-=0.02;
		//FireMode[1].FireRate-=0.025;
}*/

/// temp;
state TickEffects
{
    simulated function Tick( float t )
    {
        if (chargeEmitter == None)
        {
            chargeEmitter = Spawn(class'DEKRailGunLightningCharge',self);
            AttachToBone(chargeEmitter, 'Bone_Flash' );
        }
        chargeEmitter.mRegenPause = ( FireMode[0].NextFireTime > Level.TimeSeconds || AmmoAmount(0) == 0 );
    
		if ( DEKRailGunFire(FireMode[0]) != None )
		{
			if ( DEKRailGunFire(FireMode[0]).ChargeEffect != None )
			{
				DEKRailGunFire(FireMode[0]).ChargeEffect.SetRelativeLocation(ChargeEffectOffset);
			}
		}
	}
}

defaultproperties
{
     HudColor=(B=229,G=216,R=139)
     fullchargeSkin=Combiner'AWGlobal.Shaders.Combiner29'
     ChargeEffectOffset=(X=-1.000000)
     FireModeClass(0)=Class'DEKWeapons208.DEKRailGunFire'
     SelectAnimRate=1.363600
     BringUpTime=0.330000
     AIRating=0.400000
     bCanThrow=False
     bSniping=True
     Priority=4
     PickupClass=Class'DEKWeapons208.DEKRailGunPickup'
     AttachmentClass=Class'DEKWeapons208.DEKRailGunAttachment'
     ItemName="Rail Gun"
     Mesh=SkeletalMesh'DEKAnimationMaster206.Railgun'
     Skins(0)=Shader'DEKWeapons208.Skins.RailgunShader'
     Skins(1)=Shader'DEKWeapons208.Skins.RailgunShader'
     DrawScale=0.900000
}
