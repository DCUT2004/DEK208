class DruidCeilingSentinel extends ASVehicle_Sentinel_Ceiling;

var config float TargetRange;

simulated function PostBeginPlay()
{
	DefaultWeaponClassName=string(class'DruidWeaponSentinel');

	super.PostBeginPlay();
}

defaultproperties
{
     TargetRange=1200.000000
     DefaultWeaponClassName="DruidWeaponSentinel"
     bNoTeamBeacon=False
}
