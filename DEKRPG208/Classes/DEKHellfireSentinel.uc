class DEKHellfireSentinel extends ASVehicle_Sentinel_Floor;

var config float TargetRange;

simulated event PostBeginPlay()
{
	DefaultWeaponClassName=string(class'DEKHellfireSentinelWeapon');

	super.PostBeginPlay();
}

simulated function Explode( vector HitLocation, vector HitNormal )
{
	local DEKHellfireSentinelController C;
	
	C = DEKHellfireSentinelController(self.Controller);
	
	if (C != None && C.PlayerSpawner != None && PlayerController(C.PlayerSpawner) != None)
		PlayerController(C.PlayerSpawner).ClientPlaySound(Sound'AnnouncerAssault.Generic.MS_sentinel_destroyed');
		
	super(ASTurret).Explode( HitLocation, Vect(0,0,1) ); // Overriding Explosion direction
}

defaultproperties
{
     TargetRange=600.000000
     DefaultWeaponClassName="DEKHellfireSentinelWeapon"
     VehicleProjSpawnOffset=(X=122.500000)
     VehicleNameString="Hellfire Sentinel"
     bNoTeamBeacon=False
}
