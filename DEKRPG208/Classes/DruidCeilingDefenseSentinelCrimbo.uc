class DruidCeilingDefenseSentinelCrimbo extends DruidDefenseSentinelCrimbo;
#exec OBJ LOAD FILE=..\Animations\AS_Vehicles_M.ukx

defaultproperties
{
     TurretBaseClass=None
     VehicleNameString="Ceiling Defense Sentinel"
     Mesh=SkeletalMesh'AS_Vehicles_M.CeilingTurretBase'
     Skins(0)=Combiner'DEKRPGTexturesMaster207P.CeilingSentCombiner'
     Skins(1)=Combiner'DEKRPGTexturesMaster207P.CeilingSentCombiner'
     CollisionRadius=45.000000
     CollisionHeight=60.000000
}
