// From Wormbo's WV Hover Tank vehicle collection - the Poltergeist. Thanks Wormbo!!

class DEKSolarTurret extends DruidEnergyTurret;

var		class<ASTurret_Base>	TurretBaseClass;
var		ASTurret_Base			TurretBase;
var		Rotator					OriginalRotation;

var		class<ASTurret_Base>	TurretSwivelClass;
var		ASTurret_Base			TurretSwivel;

replication
{
	reliable if ( bNetInitial && Role==ROLE_Authority)
		OriginalRotation;
}

simulated event PostBeginPlay()
{
	if ( Role == Role_Authority )
		OriginalRotation = Rotation;	// Save original Rotation to place client versions well...

	super.PostBeginPlay();
}

simulated event PostNetBeginPlay()
{
	// Static (non rotating) base
	if ( TurretBaseClass != None )
		TurretBase = Spawn(TurretBaseClass, Self,, Location, OriginalRotation);

	// Swivel, rotates left/right (Yaw)
	if ( TurretSwivelClass != None )
		TurretSwivel = Spawn(TurretSwivelClass, Self,, Location, OriginalRotation);

	super.PostNetBeginPlay();
}

simulated function ActivateOverlay(bool bActive)
{
 // do nothing. Don't want the energy turret first person view for the Solar turret.
}

simulated function Explode( vector HitLocation )
{
   Local Actor A;
   
	A = spawn(class'FX_SpaceFighter_Explosion', self,, instigator.Location, instigator.Rotation);
	if (A != None)
	{
		A.RemoteRole = ROLE_SimulatedProxy;
	}
	Instigator.PlaySound(Sound'Explosion01', SLOT_None, 500.0);	
	Destroy();
}

simulated function AltFire(optional float F)
{
	local PlayerController PC;

	PC = PlayerController(Controller);
	if (PC == None)
		return;
		
	bWeaponIsAltFiring = true;
	//PC.ToggleZoom(); - don't want zooming.
}

simulated function UpdateLinkColor( LinkAttachment.ELinkColor Color )
{
	switch ( Color )
	{
		case LC_Gold	:	Skins[2] = material'PowerPulseShaderYellow';	break;
		case LC_Green	:	Skins[2] = material'PowerPulseShader';			break;
		case LC_Red		: 	Skins[2] = material'PowerPulseShaderRed';		break;
		case LC_Blue	: 	Skins[2] = material'PowerPulseShaderBlue';		break;
	}
	Skins[0] = Combiner'AS_Weapons_TX.LinkTurret.LinkTurret_Skin2_C';
}

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache( L );

	L.AddPrecacheMaterial( Material'AS_Weapons_TX.LinkTurret.LinkTurret_skin1' );		// Skins
	L.AddPrecacheMaterial( Material'AS_Weapons_TX.LinkTurret.LinkTurret_skin2' );
	L.AddPrecacheMaterial( material'PowerPulseShader' );
	L.AddPrecacheMaterial( material'PowerPulseShaderRed' );
	L.AddPrecacheMaterial( material'PowerPulseShaderBlue' );
	
	L.AddPrecacheMaterial( Material'Turrets.TurretHud2' );	// HUD
	L.AddPrecacheMaterial( Texture'AS_FX_TX.HUD.SpaceHUD_Weapon_Grey' );
	L.AddPrecacheMaterial( Texture'InterfaceContent.WhileSquare' );

	L.AddPrecacheMaterial( Material'ExplosionTex.Framed.exp7_frames' );			// Explosion Effect
	L.AddPrecacheMaterial( Material'EpicParticles.Flares.SoftFlare' );
	L.AddPrecacheMaterial( Material'AW-2004Particles.Fire.MuchSmoke2t' );
	L.AddPrecacheMaterial( Material'AS_FX_TX.Trails.Trail_red' );
	L.AddPrecacheMaterial( Material'ExplosionTex.Framed.exp1_frames' );
	L.AddPrecacheMaterial( Material'EmitterTextures.MultiFrame.rockchunks02' );

	L.AddPrecacheMaterial( Texture'AS_FX_TX.Flares.Laser_Flare' );	// Fire Effect
	L.AddPrecacheMaterial( Texture'EpicParticles.Smoke.StellarFog1aw' );
	L.AddPrecacheStaticMesh( StaticMesh'AS_Weapons_SM.Projectiles.Skaarj_Energy' );

	L.AddPrecacheStaticMesh( StaticMesh'AS_Weapons_SM.Turret.LinkBase' );
	
	//L.AddPrecacheMaterial( Material'AS_FX_TX.WhiteShield_FB' );		// Shield Effect
	//L.AddPrecacheStaticMesh( StaticMesh'LinkTurretShield' );
	L.AddPrecacheStaticMesh( StaticMesh'WeaponStaticMesh.Shield' );
	L.AddPrecacheMaterial( Material'XEffectMat.RedShell' );
	L.AddPrecacheMaterial( Material'XEffectMat.BlueShell' );
}

simulated function UpdatePrecacheStaticMeshes()
{
	Level.AddPrecacheStaticMesh( StaticMesh'AS_Weapons_SM.Turret.LinkBase' );
	//Level.AddPrecacheStaticMesh( StaticMesh'LinkTurretShield' );
	Level.AddPrecacheStaticMesh( StaticMesh'AS_Weapons_SM.Projectiles.Skaarj_Energy' );
	Level.AddPrecacheStaticMesh( StaticMesh'WeaponStaticMesh.Shield' );

	super.UpdatePrecacheStaticMeshes();
}


simulated function UpdatePrecacheMaterials()
{
	Level.AddPrecacheMaterial( Material'AS_Weapons_TX.LinkTurret.LinkTurret_skin1' );		// Skins
	Level.AddPrecacheMaterial( Material'AS_Weapons_TX.LinkTurret.LinkTurret_skin2' );
	Level.AddPrecacheMaterial( material'PowerPulseShader' );
	Level.AddPrecacheMaterial( material'PowerPulseShaderRed' );
	Level.AddPrecacheMaterial( material'PowerPulseShaderBlue' );
	Level.AddPrecacheMaterial( material'PowerPulseShaderYellow' );
	
	//Level.AddPrecacheMaterial( Material'AS_FX_TX.WhiteShield_FB' );	
	Level.AddPrecacheMaterial( Material'XEffectMat.RedShell' );
	Level.AddPrecacheMaterial( Material'XEffectMat.BlueShell' );

	Level.AddPrecacheMaterial( Material'Turrets.TurretHud2' );	// HUD
	Level.AddPrecacheMaterial( Texture'AS_FX_TX.HUD.SpaceHUD_Weapon_Grey' );
	Level.AddPrecacheMaterial( Texture'InterfaceContent.WhileSquare' );

	Level.AddPrecacheMaterial( Material'ExplosionTex.Framed.exp7_frames' );			// Explosion Effect
	Level.AddPrecacheMaterial( Material'EpicParticles.Flares.SoftFlare' );
	Level.AddPrecacheMaterial( Material'AW-2004Particles.Fire.MuchSmoke2t' );
	Level.AddPrecacheMaterial( Material'AS_FX_TX.Trails.Trail_red' );
	Level.AddPrecacheMaterial( Material'ExplosionTex.Framed.exp1_frames' );
	Level.AddPrecacheMaterial( Material'EmitterTextures.MultiFrame.rockchunks02' );

	Level.AddPrecacheMaterial( Texture'AS_FX_TX.Flares.Laser_Flare' );	// Fire Effect
	Level.AddPrecacheMaterial( Texture'EpicParticles.Smoke.StellarFog1aw' );

	super.UpdatePrecacheMaterials();
}

simulated event Destroyed()
{
	if ( TurretBase != None )
		TurretBase.Destroy();

	if ( TurretSwivel != None )
		TurretSwivel.Destroy();

	super.Destroyed();
}

defaultproperties
{
     TurretBaseClass=Class'DEKRPG208.DruidLinkTurretBase'
     TurretSwivelClass=Class'DEKRPG208.DruidLinkTurretSwivel'
     GunClass=Class'DEKRPG208.DEKSolarTurretWeapon'
     bHasAltFire=True
     CameraBone="LinkBarrel"
     bDrawDriverInTP=False
     bDrawMeshInFP=False
     bHideRemoteDriver=True
     ExitPositions(0)=(Y=100.000000,Z=100.000000)
     ExitPositions(1)=(Y=-100.000000,Z=100.000000)
     EntryRadius=120.000000
     FPCamPos=(X=100.000000,Z=100.000000)
     VehicleNameString="Solar Turret"
     HealthMax=900.000000
     Health=900
     Mesh=SkeletalMesh'AS_VehiclesFull_M.LinkBody'
     DrawScale=0.200000
     Skins(0)=Combiner'AS_Weapons_TX.LinkTurret.LinkTurret_Skin2_C'
     Skins(1)=Combiner'AS_Weapons_TX.LinkTurret.LinkTurret_Skin1_C'
     Skins(2)=Shader'UT2004Weapons.Shaders.PowerPulseShaderYellow'
     CollisionRadius=60.000000
     CollisionHeight=90.000000
}
