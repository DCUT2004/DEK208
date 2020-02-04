class DEKLynxVehicle extends ONSRV;

#exec OBJ LOAD FILE=..\textures\DEKRPGTexturesMaster207P.utx

var bool IsLockedForSelf;
var Controller PlayerSpawner;
var Material LockOverlay;
var() int RegenPerSecond;
var() int BladeDamage;
var() bool bBladesBreak;

function SetPlayerSpawner(Controller PlayerC)
{
	PlayerSpawner = PlayerC;
}

function bool TryToDrive(Pawn P)
{
	if ( (P.Controller == None) || !P.Controller.bIsPlayer || Health <= 0 )
		return false;

	// Check for Locking by engineer....
	if ( IsEngineerLocked() && P.Controller != PlayerSpawner )
	{
		if (PlayerController(P.Controller) != None)
		{
		    if (PlayerSpawner != None)
				PlayerController(P.Controller).ReceiveLocalizedMessage(class'VehicleEngLockedMessage', 0, PlayerSpawner.PlayerReplicationInfo);
			else
				PlayerController(P.Controller).ReceiveLocalizedMessage(class'VehicleEngLockedMessage', 0);
		}
		return false;
	}
	else
	{
		return super.TryToDrive(P);
	}
}

function EngineerLock()
{
    IsLockedForSelf = True;
	SetOverlayMaterial(LockOverlay, 50000.0, false);
}

function EngineerUnlock()
{
    IsLockedForSelf = False;
	SetOverlayMaterial(LockOverlay, 0.0, false);
}

function bool IsEngineerLocked()
{
    return IsLockedForSelf;
}

//override to make blade breaking optional
simulated event Tick(float dt) {
    local Coords ArmBaseCoords, ArmTipCoords;
    local vector HitLocation, HitNormal;
    local actor Victim;

    Super(ONSWheeledCraft).Tick(dt);

    // Left Blade Arm System
    if(Role == ROLE_Authority && bWeaponIsAltFiring && !bLeftArmBroke)
    {
        ArmBaseCoords = GetBoneCoords('CarLShoulder');
        ArmTipCoords = GetBoneCoords('LeftBladeDummy');
        Victim = Trace(HitLocation, HitNormal, ArmTipCoords.Origin, ArmBaseCoords.Origin);

        if(Victim != None && Victim.bBlockActors)
        {
            if(Victim.IsA('Pawn') && !Victim.IsA('Vehicle'))
            {
                Pawn(Victim).TakeDamage(BladeDamage, self, HitLocation, Velocity * 100, class'DamTypeLynxBlade');
            }
            else if(bBladesBreak)
            {
                bLeftArmBroke = True;
                bClientLeftArmBroke = True;
                BladeBreakOff(4, 'CarLSlider', class'ONSRVLeftBladeBreakOffEffect');
                // We use slot 4 here because slots 0-3 can be used by BigWheels mutator.
            }
        }
    }
    
    if(Role < ROLE_Authority && bClientLeftArmBroke)
    {
        bLeftArmBroke = True;
        bClientLeftArmBroke = False;
        BladeBreakOff(4, 'CarLSlider', class'ONSRVLeftBladeBreakOffEffect');
    }

    // Right Blade Arm System
    if (Role == ROLE_Authority && bWeaponIsAltFiring && !bRightArmBroke)
    {
        ArmBaseCoords = GetBoneCoords('CarRShoulder');
        ArmTipCoords = GetBoneCoords('RightBladeDummy');
        Victim = Trace(HitLocation, HitNormal, ArmTipCoords.Origin, ArmBaseCoords.Origin);

        if (Victim != None && Victim.bBlockActors)
        {
            if (Victim.IsA('Pawn') && !Victim.IsA('Vehicle'))
            {
                Pawn(Victim).TakeDamage(BladeDamage, self, HitLocation, Velocity * 100, class'DamTypeLynxBlade');
            }
            else if(bBladesBreak)
            {
                bRightArmBroke = True;
                bClientRightArmBroke = True;
                BladeBreakOff(5, 'CarRSlider', class'ONSRVRightBladeBreakOffEffect');
            }
        }
    }
    if (Role < ROLE_Authority && bClientRightArmBroke)
    {
        bRightArmBroke = True;
        bClientRightArmBroke = False;
        BladeBreakOff(5, 'CarRSlider', class'ONSRVRightBladeBreakOffEffect');
    }
    
    if(Health < HealthMax && RegenPerSecond > 0)
        Health = Min(HealthMax, Health + int(float(RegenPerSecond) * dt));
}

event RanInto(Actor Other) {
    local vector Momentum;
    local float Speed;

    if (Pawn(Other) == None || Vehicle(Other) != None || Other == Instigator || Other.Role != ROLE_Authority)
        return;

    Speed = VSize(Velocity);
    if (Speed > MinRunOverSpeed) {
        Momentum = Velocity * 0.25 * Other.Mass;

        if(Controller != None && Controller.SameTeamAs(Pawn(Other).Controller))
            Momentum += Speed * 0.25 * Other.Mass * Normal(Velocity cross vect(0,0,1));
            
        if(RanOverSound != None)
            PlaySound(RanOverSound,,TransientSoundVolume*2.5);

           Other.TakeDamage(BladeDamage, Self, Other.Location, Velocity * 100, RanOverDamageType);
    }
}

function bool RecommendLongRangedAttack()
{
	return true;
}

defaultproperties
{
     LockOverlay=Shader'DEKRPGTexturesMaster207P.fX.PulseRedShader'
     DriverWeapons(0)=(WeaponClass=Class'DEKRPG208.DEKLynxRocketPack')
     VehiclePositionString="in a Lynx"
     VehicleNameString="Lynx"
     RanOverDamageType=Class'DEKRPG208.DamTypeLynxRoadkill'
     CrushedDamageType=Class'DEKRPG208.DamTypeLynxPancake'
     HealthMax=400.000000
     Health=400
     Skins(0)=Shader'DEKRPGTexturesMaster207P.Skins.Lynx'
}
