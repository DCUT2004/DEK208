//-----------------------------------------------------------
//   Customized SuperBeast for the DC Invasion Server.  
//-----------------------------------------------------------
class MTDC extends ONSWheeledCraft;
var()               Material        RedSkin1;
var()               Material        BlueSkin1;
var		SBXMPRaptorGrinderD Grinder1, Grinder2;
var		SBXMPTurretCam	GrinderBase1, GrinderBase2;
var		Emitter GutBlowA,GutBlowB,GutBlowC;
var		Vector	GutBlowALocation;
var		Rotator	GutBlowARotation;
var		class<Emitter> GutBlowAEffect;
var		Vector	GutBlowBLocation;
var		Rotator	GutBlowBRotation;
var		class<Emitter> GutBlowBEffect;
var		Vector	GutBlowCLocation;
var		Rotator	GutBlowCRotation;
var		class<Emitter> GutBlowCEffect;
var		float	GrinderDelta;
var		byte GutIndex,LastGutIndex;

replication
{

unreliable if( bNetDirty && Role==ROLE_Authority )
		GutIndex;
}

simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	LastGutIndex = GutIndex;
}

simulated function PostBeginPlay()
{
	local rotator GrinderRotation;
	local vector GOffset;
    Super.PostBeginPlay();
	if (bPendingDelete)
		return;

//only have grinders on client
	if(Level.NetMode != NM_DedicatedServer)
	{
		GrinderRotation=Rotation;
		GrinderRotation.Pitch+=6918;
		GOffset=class'SBXMPRaptorGrinderD'.default.LocationOffset;
		GOffset.X*=-1;
		GrinderBase1 = spawn (class'SBXMPTurretCam', self,, Location + (GOffset >> Rotation),GrinderRotation);
		GrinderBase1.SetBase(self);
		Grinder1 = spawn (class'SBXMPRaptorGrinderD', self,, Location + (GOffset >> Rotation),GrinderRotation);
		Grinder1.SetBase(GrinderBase1);
		GOffset=class'SBXMPRaptorGrinderD'.default.LocationOffset2;
		GOffset.X*=-1;
		GrinderBase2 = spawn (class'SBXMPTurretCam', self,, Location + (GOffset >> Rotation),GrinderRotation);
		GrinderBase2.SetBase(self);
		Grinder2 = spawn (class'SBXMPRaptorGrinderD', self,, Location + (GOffset >> Rotation),GrinderRotation);
		Grinder2.SetBase(GrinderBase2);
		GrinderDelta=0;
	}
}

simulated event Destroyed()
{
	//Log("SBXMPVehicle Destroyed");

	// Clean up random stuff attached to the car
	if(Level.NetMode != NM_DedicatedServer)
	{
		if (Grinder1!=none)
			Grinder1.Destroy();
		if (Grinder2!=none)
			Grinder2.Destroy();
		if (GrinderBase1!=none)
			GrinderBase1.Destroy();
		if (GrinderBase2!=none)
			GrinderBase2.Destroy();

		if ( GutBlowA != none )
			GutBlowA.Destroy();
		if ( GutBlowB != none )
			GutBlowB.Destroy();
		if ( GutBlowC != none )
			GutBlowC.Destroy();
	}
	// This will destroy wheels & joints
	Super.Destroyed();
}

// RanInto() called for encroaching actors which successfully moved the other actor out of the way
event RanInto(Actor Other)
{
	local vector EnemyVector;

	if ( XPawn(Other) != None )
	{
		if ( Pawn(Other).GetTeamNum() != GetTeamNum() && Role == ROLE_Authority && Pawn(Other).Health > 0 /*&& Other.bHasBlood*/ )
		{
			EnemyVector = Normal( Location - Other.Location);
			if (EnemyVector dot vector(Rotation) < -0.89)
			{
				GutIndex++;
				Other.bHidden=true;

				GutBlowA = Spawn(GutBlowAEffect);
				GutblowA.SetBase(self);
				GutblowA.SetRelativeLocation(GutBlowALocation);

				GutBlowB = Spawn(GutBlowBEffect);
				GutblowB.SetBase(self);
				GutblowB.SetRotation(Rotation);

//				XPawn(Other).NotifyGutBlowed( Controller );
				Other.TakeDamage(
					150
					, Self
					, Other.Location
					, vect(0,0,0)
					, class'DamTypeMTIIRoadkill');
			} else
				Super.RanInto(Other);
		} else
			Super.RanInto(Other);
	}
}

// This will get called if we couldn't move a pawn out of the way.
function bool EncroachingOn(Actor Other)
{
	if ( Other == None || Other == Instigator || Other.Role != ROLE_Authority || (!Other.bCollideActors && !Other.bBlockActors)
	     || VSize(Velocity) < 10 )
		return false;

	// If its a non-vehicle pawn, do lots of damage.
	if( (Pawn(Other) != None) && (Vehicle(Other) == None) )
	{
		Other.TakeDamage(150, Instigator, Other.Location, Velocity * Other.Mass, CrushedDamageType);
		return false;
	}
}

simulated event DestroyAppearance()
{
    super.DestroyAppearance();


	if (Grinder1!=none)
		Grinder1.Destroy();
	if (Grinder2!=none)
		Grinder2.Destroy();
	if (GrinderBase1!=none)
		GrinderBase1.Destroy();
	if (GrinderBase2!=none)
		GrinderBase2.Destroy();

	if ( GutBlowA != none )
		GutBlowA.Destroy();
	if ( GutBlowB != none )
		GutBlowB.Destroy();
	if ( GutBlowC != none )
		GutBlowC.Destroy();

}

simulated event TeamChanged()
{

    Super.TeamChanged();

    if (Team == 0 && RedSkin1 != None)
        Skins[1] = RedSkin1;
    else if (Team == 1 && BlueSkin1 != None)
        Skins[1] = BlueSkin1;


	}

////////////////////////////////////////////////////////
	

defaultproperties
{
     RedSkin1=Texture'MTII.MTRed'
     BlueSkin1=Texture'MTII.MTBlue'
     GutBlowALocation=(X=101.970001,Z=-6.910000)
     GutBlowAEffect=Class'DEKRPG208.MTGutblowFX'
     GutBlowBEffect=Class'DEKRPG208.MTGutblowFXB'
     WheelSoftness=0.025000
     WheelPenScale=1.200000
     WheelPenOffset=0.010000
     WheelRestitution=0.100000
     WheelInertia=0.100000
     WheelLongFrictionFunc=(Points=(,(InVal=100.000000,OutVal=1.000000),(InVal=200.000000,OutVal=0.900000),(InVal=10000000000.000000,OutVal=0.900000)))
     WheelLongSlip=0.001000
     WheelLatSlipFunc=(Points=(,(InVal=30.000000,OutVal=0.009000),(InVal=45.000000),(InVal=10000000000.000000)))
     WheelLongFrictionScale=1.100000
     WheelLatFrictionScale=1.350000
     WheelHandbrakeSlip=0.010000
     WheelHandbrakeFriction=0.100000
     WheelSuspensionTravel=42.000000
     WheelSuspensionMaxRenderTravel=42.000000
     FTScale=0.030000
     ChassisTorqueScale=0.900000
     MinBrakeFriction=4.000000
     MaxSteerAngleCurve=(Points=((OutVal=25.000000),(InVal=1500.000000,OutVal=11.000000),(InVal=1000000000.000000,OutVal=11.000000)))
     TorqueCurve=(Points=((OutVal=9.000000),(InVal=200.000000,OutVal=10.000000),(InVal=1500.000000,OutVal=11.000000),(InVal=2800.000000)))
     GearRatios(0)=-0.500000
     GearRatios(1)=0.275000
     GearRatios(2)=0.550000
     GearRatios(3)=0.750000
     GearRatios(4)=1.000000
     TransRatio=0.160000
     ChangeUpPoint=2000.000000
     ChangeDownPoint=1000.000000
     LSDFactor=1.000000
     EngineBrakeFactor=0.000100
     EngineBrakeRPMScale=0.100000
     MaxBrakeTorque=20.000000
     SteerSpeed=125.000000
     TurnDamping=35.000000
     StopThreshold=100.000000
     HandbrakeThresh=200.000000
     EngineInertia=0.175000
     IdleRPM=650.000000
     EngineRPMSoundRange=9000.000000
     SteerBoneName="SteeringWheel"
     SteerBoneAxis=AXIS_Z
     SteerBoneMaxAngle=95.000000
     RevMeterScale=4000.000000
     bMakeBrakeLights=True
     BrakeLightOffset(0)=(X=-140.419998,Y=43.680000,Z=64.290001)
     BrakeLightOffset(1)=(X=-140.419998,Y=-43.680000,Z=64.290001)
     BrakeLightMaterial=Texture'EpicParticles.Flares.FlashFlare1'
     DaredevilThreshInAirSpin=640.000000
     DaredevilThreshInAirTime=10.000000
     DaredevilThreshInAirDistance=221.000000
     bDoStuntInfo=True
     bAllowAirControl=True
     bAllowChargingJump=True
     MaxJumpForce=300000.000000
     AirTurnTorque=35.000000
     AirPitchTorque=55.000000
     AirPitchDamping=35.000000
     AirRollTorque=35.000000
     AirRollDamping=35.000000
     DriverWeapons(0)=(WeaponClass=Class'DEKRPG208.MTMachineGun',WeaponBone="RFrontStrut")
     PassengerWeapons(0)=(WeaponPawnClass=Class'DEKRPG208.MTRearGunPawn',WeaponBone="Attachment")
     RedSkin=Texture'MTII.MTUnderside'
     BlueSkin=Texture'MTII.MTUnderside'
     IdleSound=Sound'MTII.MTEng01'
     StartUpSound=Sound'MTII.MTStart'
     ShutDownSound=Sound'MTII.MTStop'
     StartUpForce="RVStartUp"
     DestroyedVehicleMesh=StaticMesh'ONSBP_DestroyedVehicles.SPMA.DestroyedSPMA'
     DestructionEffectClass=Class'UT2k4Assault.FX_SpaceFighter_Explosion'
     DisintegrationEffectClass=Class'Onslaught.ONSVehDeathPRV'
     DisintegrationHealth=-100.000000
     DestructionLinearMomentum=(Min=200000.000000,Max=300000.000000)
     DestructionAngularMomentum=(Min=100.000000,Max=150.000000)
     DamagedEffectOffset=(X=60.000000,Y=10.000000,Z=10.000000)
     ImpactDamageMult=0.001000
     HeadlightCoronaOffset(0)=(X=124.430000,Y=37.139999,Z=66.459999)
     HeadlightCoronaOffset(1)=(X=124.430000,Y=-37.139999,Z=66.459999)
     HeadlightCoronaOffset(2)=(X=-18.090000,Y=21.070000,Z=106.809998)
     HeadlightCoronaOffset(3)=(X=-18.090000,Y=-21.070000,Z=106.809998)
     HeadlightCoronaOffset(4)=(X=-18.090000,Y=7.510000,Z=106.809998)
     HeadlightCoronaOffset(5)=(X=-18.090000,Y=-7.510000,Z=106.809998)
     HeadlightCoronaMaterial=Texture'EpicParticles.Flares.FlashFlare1'
     HeadlightCoronaMaxSize=20.000000
     HeadlightProjectorMaterial=Texture'VMVehicles-TX.RVGroup.RVprojector'
     HeadlightProjectorOffset=(X=90.000000,Z=7.000000)
     HeadlightProjectorRotation=(Pitch=-1000)
     HeadlightProjectorScale=0.300000
     CrossHairColor=(B=255,G=120,R=100,A=225)
     Begin Object Class=SVehicleWheel Name=RRWheel
         bPoweredWheel=True
         bHandbrakeWheel=True
         BoneName="tire02"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=7.000000)
         WheelRadius=40.000000
         SupportBoneName="RrearStrut"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(0)=SVehicleWheel'DEKRPG208.MTDC.RRWheel'

     Begin Object Class=SVehicleWheel Name=LRWheel
         bPoweredWheel=True
         bHandbrakeWheel=True
         BoneName="tire04"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=-7.000000)
         WheelRadius=40.000000
         SupportBoneName="LrearStrut"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(1)=SVehicleWheel'DEKRPG208.MTDC.LRWheel'

     Begin Object Class=SVehicleWheel Name=RFWheel
         bPoweredWheel=True
         SteerType=VST_Steered
         BoneName="tire"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=7.000000)
         WheelRadius=40.000000
         SupportBoneName="RFrontStrut"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(2)=SVehicleWheel'DEKRPG208.MTDC.RFWheel'

     Begin Object Class=SVehicleWheel Name=LFWheel
         bPoweredWheel=True
         SteerType=VST_Steered
         BoneName="tire03"
         BoneRollAxis=AXIS_Y
         BoneOffset=(Y=-7.000000)
         WheelRadius=40.000000
         SupportBoneName="LfrontStrut"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(3)=SVehicleWheel'DEKRPG208.MTDC.LFWheel'

     VehicleMass=7.250000
     bDrawDriverInTP=True
     bCanDoTrickJumps=True
     bDrawMeshInFP=True
     bHasHandbrake=True
     bSeparateTurretFocus=True
     bDriverHoldsFlag=False
     DrivePos=(X=15.000000,Y=-20.000000,Z=102.599998)
     ExitPositions(0)=(Y=-165.000000,Z=100.000000)
     ExitPositions(1)=(Y=165.000000,Z=100.000000)
     ExitPositions(2)=(Y=-165.000000,Z=-100.000000)
     ExitPositions(3)=(Y=165.000000,Z=-100.000000)
     EntryRadius=180.000000
     FPCamPos=(Y=-20.000000,Z=82.599998)
     TPCamDistance=550.000000
     CenterSpringForce="SpringONSSRV"
     TPCamLookat=(X=10.000000)
     TPCamWorldOffset=(Z=100.000000)
     DriverDamageMult=0.050000
     VehiclePositionString="in a Super Beast"
     VehicleNameString="Super Beast"
     RanOverDamageType=Class'MTII.DamTypeMTIIRoadkill'
     CrushedDamageType=Class'MTII.DamTypeMTIIPancake'
     MaxDesireability=0.400000
     ObjectiveGetOutDist=1500.000000
     FlagBone="RVchassis"
     FlagOffset=(Z=130.000000)
     FlagRotation=(Yaw=32768)
     HornSounds(0)=Sound'ONSBPSounds.Artillery.SPMAHorn'
     HornSounds(1)=Sound'MTII.Superbeast'
     GroundSpeed=850.000000
     HealthMax=450.000000
     Health=450
     bReplicateAnimations=True
     Mesh=SkeletalMesh'MTII.MTB'
     Skins(0)=Texture'MTII.MTUnderside'
     Skins(1)=Texture'MTII.MTRed'
     Skins(2)=Shader'MTII.MTIIGlass'
     Skins(3)=Texture'MTII.MTSusp'
     Skins(4)=Texture'MTII.MTWheel'
     AmbientGlow=2
     bShadowCast=True
     SoundVolume=180
     CollisionRadius=95.000000
     CollisionHeight=40.000000
     Begin Object Class=KarmaParamsRBFull Name=KParams0
         KInertiaTensor(0)=1.000000
         KInertiaTensor(3)=3.000000
         KInertiaTensor(5)=3.000000
         KCOMOffset=(X=-0.250000,Z=-0.400000)
         KLinearDamping=0.050000
         KAngularDamping=0.050000
         KStartEnabled=True
         bKNonSphericalInertia=True
         bHighDetailOnly=False
         bClientOnly=False
         bKDoubleTickRate=True
         bDestroyOnWorldPenetrate=True
         bDoSafetime=True
         KFriction=0.500000
         KImpactThreshold=700.000000
     End Object
     KParams=KarmaParamsRBFull'DEKRPG208.MTDC.KParams0'

}
