class DEKCeilingDamageSentinel extends DEKDamageSentinel ;
#exec OBJ LOAD FILE=..\Animations\AS_Vehicles_M.ukx

defaultproperties
{
     TurretBaseClass=None
     Mesh=SkeletalMesh'AS_Vehicles_M.CeilingTurretBase'
     DrawScale=0.300000
     Skins(0)=Combiner'DEKRPGTexturesMaster207P.Skins.MineChargerCeilingCombiner'
     Skins(1)=Combiner'DEKRPGTexturesMaster207P.Skins.MineChargerCeilingCombiner'
     CollisionRadius=45.000000
     CollisionHeight=60.000000
}
