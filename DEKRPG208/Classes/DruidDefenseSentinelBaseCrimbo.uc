class DruidDefenseSentinelBaseCrimbo extends ASTurret_Base;

#exec OBJ LOAD FILE=..\StaticMeshes\DEKStaticsMaster207P.usx
#exec OBJ LOAD FILE=..\Textures\DEKRPGTexturesMaster207P.utx

defaultproperties
{
     StaticMesh=StaticMesh'DEKStaticsMaster207P.ChristmasMeshes.FloorCandyCane'
     DrawScale=0.300000
     Skins(0)=Shader'DEKRPGTexturesMaster207P.SkinsChristmas.FloorSentShader'
     Skins(1)=FinalBlend'DEKRPGTexturesMaster207P.fX.DefensePanFinal'
     AmbientGlow=1
     CollisionRadius=1.000000
     CollisionHeight=10.000000
}
