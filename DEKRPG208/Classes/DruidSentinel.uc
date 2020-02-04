class DruidSentinel extends ASVehicle_Sentinel_Floor;

var config float TargetRange;

#exec OBJ LOAD FILE=..\Sounds\AnnouncerAssault.uax

simulated event PostBeginPlay()
{
	DefaultWeaponClassName=string(class'DruidWeaponSentinel');

	super.PostBeginPlay();
}

simulated function Explode( vector HitLocation, vector HitNormal )
{
	local DruidSentinelController C;
	
	C = DruidSentinelController(self.Controller);
	
	if (C != None && C.PlayerSpawner != None && PlayerController(C.PlayerSpawner) != None)
		PlayerController(C.PlayerSpawner).ClientPlaySound(Sound'AnnouncerAssault.Generic.MS_sentinel_destroyed');
		
	super(ASTurret).Explode( HitLocation, Vect(0,0,1) ); // Overriding Explosion direction
}

defaultproperties
{
     TargetRange=1200.000000
     DefaultWeaponClassName="DruidWeaponSentinel"
     bNoTeamBeacon=False
}
