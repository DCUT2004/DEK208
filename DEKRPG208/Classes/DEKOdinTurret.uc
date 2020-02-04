// From Wormbo's WV Hover Tank vehicle collection - the Odin. Thanks Wormbo!!

class DEKOdinTurret extends DruidEnergyTurret;

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
 // do nothing. Don't want the energy turret first person view for the Odin.
}

simulated function Explode( vector HitLocation )
{
   Local Actor A;
   
	A = spawn(class'IonCannonDeathEffect', self,, instigator.Location, instigator.Rotation);
	if (A != None)
	{
		A.RemoteRole = ROLE_SimulatedProxy;
	}
	Instigator.PlaySound(Sound'VehicleExplosion01', SLOT_None, 500.0);	
	Destroy();
}

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache( L );

	L.AddPrecacheMaterial( Material'AS_FX_TX.Beams.HotBolt_2' );
	L.AddPrecacheMaterial( Material'AS_FX_TX.Beams.HotBolt_3' );
	L.AddPrecacheMaterial( Material'AS_FX_TX.Beams.HotBolt_4' );
	L.AddPrecacheMaterial( Material'AS_FX_TX.Beams.HotBolt_1' );
	L.AddPrecacheMaterial( Material'AS_Weapons_TX.IonCanon.ASIonCannon1' );
	L.AddPrecacheMaterial( Material'AS_Weapons_TX.IonCanon.ASIonCannon2' );

	// FX
	L.AddPrecacheMaterial( Material'AW-2004Particles.Weapons.HardSpot' );
	L.AddPrecacheMaterial( Material'AW-2004Particles.Energy.AirBlastP' );
	L.AddPrecacheMaterial( Material'AW-2004Particles.Energy.PurpleSwell' );
	L.AddPrecacheMaterial( Material'ExplosionTex.Framed.exp2_framesP' );
	L.AddPrecacheMaterial( Texture'EpicParticles.Flares.SoftFlare' );
	L.AddPrecacheMaterial( Texture'EpicParticles.Beams.WhiteStreak01aw' );
	L.AddPrecacheMaterial( Texture'AW-2004Particles.Energy.EclipseCircle' );
	L.AddPrecacheMaterial( Texture'EpicParticles.Flares.HotSpot' );
	L.AddPrecacheMaterial( Material'AW-2004Particles.Weapons.GrenExpl' );
	L.AddPrecacheMaterial( Material'AS_FX_TX.Flares.Laser_Flare' );
	L.AddPrecacheMaterial( Material'AW-2004Particles.Weapons.PlasmaStar' );

	L.AddPrecacheStaticMesh( StaticMesh'AW-2004Particles.Weapons.PlasmaSphere' );
}

simulated function UpdatePrecacheStaticMeshes()
{
	Level.AddPrecacheStaticMesh( StaticMesh'AW-2004Particles.Weapons.PlasmaSphere' );

	super.UpdatePrecacheStaticMeshes();
}

simulated function UpdatePrecacheMaterials()
{
	Level.AddPrecacheMaterial( Material'AS_FX_TX.Beams.HotBolt_2' );
	Level.AddPrecacheMaterial( Material'AS_FX_TX.Beams.HotBolt_3' );
	Level.AddPrecacheMaterial( Material'AS_FX_TX.Beams.HotBolt_4' );
	Level.AddPrecacheMaterial( Material'AS_FX_TX.Beams.HotBolt_1' );
	Level.AddPrecacheMaterial( Material'AS_Weapons_TX.IonCanon.ASIonCannon1' );
	Level.AddPrecacheMaterial( Material'AS_Weapons_TX.IonCanon.ASIonCannon2' );

	// FX
	Level.AddPrecacheMaterial( Material'AW-2004Particles.Weapons.HardSpot' );
	Level.AddPrecacheMaterial( Material'AW-2004Particles.Energy.AirBlastP' );
	Level.AddPrecacheMaterial( Material'AW-2004Particles.Energy.PurpleSwell' );
	Level.AddPrecacheMaterial( Material'ExplosionTex.Framed.exp2_framesP' );
	Level.AddPrecacheMaterial( Texture'EpicParticles.Flares.SoftFlare' );
	Level.AddPrecacheMaterial( Texture'EpicParticles.Beams.WhiteStreak01aw' );
	Level.AddPrecacheMaterial( Texture'AW-2004Particles.Energy.EclipseCircle' );
	Level.AddPrecacheMaterial( Texture'EpicParticles.Flares.HotSpot' );
	Level.AddPrecacheMaterial( Material'AW-2004Particles.Weapons.GrenExpl' );
	Level.AddPrecacheMaterial( Material'AS_FX_TX.Flares.Laser_Flare' );
	Level.AddPrecacheMaterial( Material'AW-2004Particles.Weapons.PlasmaStar' );

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
     TurretBaseClass=Class'DEKRPG208.DruidIonCannon_Base'
     TurretSwivelClass=Class'DEKRPG208.DruidIonCannon_Swivel'
     GunClass=Class'DEKRPG208.DEKOdinTurretWeapon'
     CameraBone="Object03"
     bDrawDriverInTP=False
     bDrawMeshInFP=False
     bHideRemoteDriver=True
     ExitPositions(0)=(X=0.000000,Y=100.000000,Z=100.000000)
     ExitPositions(1)=(X=0.000000,Y=-100.000000,Z=100.000000)
     FPCamPos=(X=100.000000,Z=100.000000)
     VehicleNameString="Odin Turret"
     HealthMax=900.000000
     Health=900
     Mesh=SkeletalMesh'AS_VehiclesFull_M.IonCannon'
     DrawScale=0.180000
     CollisionRadius=62.400002
     CollisionHeight=96.000000
}
