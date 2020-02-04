class MissionPortalBall extends Pawn;

event EncroachedBy( actor Other )
{
	// do nothing. Adding this stub stops telefragging
}

defaultproperties
{
    bUpdateSimulatedPosition=True
	AccelRate=1000.000000
	bBounce=True
	bCanBeDamaged=False
   	bCanBeBaseForPawns=True
	bNoTeamBeacon=True
	HealthMax=99999.00
	Health=99999
	ControllerClass=None
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'Editor.TexPropSphere'
	Skins(0)=Texture'MissionsTex4.Colors.Yellow'
	AirSpeed=100.000000
	bOrientOnSlope=True
	bAlwaysRelevant=True
	bIgnoreVehicles=True
	Physics=PHYS_Falling
	NetUpdateFrequency=4.000000
	DrawScale=0.200
	AmbientGlow=10
	bShouldBaseAtStartup=False
	CollisionRadius=29.500000
	CollisionHeight=25.000000
	bBlockPlayers=True
	bUseCollisionStaticMesh=True
	Mass=50.000000
}
