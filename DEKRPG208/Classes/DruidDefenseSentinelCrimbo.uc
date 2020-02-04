class DruidDefenseSentinelCrimbo extends ASTurret;
#exec OBJ LOAD FILE=..\StaticMeshes\DEKStaticsMaster207P.usx
#exec OBJ LOAD FILE=..\Textures\DEKRPGTexturesMaster207P.utx

var int ShieldHealingLevel;
var int HealthHealingLevel;
var int AdrenalineHealingLevel;
var int ResupplyLevel;
var int ArmorHealingLevel;
var float SpiderBoostLevel;

var config float HealthHealingAmount;       // the amount of health the defense sentinel heals per level (% of max health)
var config float ShieldHealingAmount;		// the amount of shield the defense sentinel heals per level (% of max shield)
var config float AdrenalineHealingAmount;	// the amount of adrenaline the defense sentinel heals per level (% of max adrenaline)
var config float ResupplyAmount;			// the amount of resupply the defense sentinel heals per level (% of max ammo)
var config float ArmorHealingAmount;		// the amount of armor the defense sentinel heals per level (% of max adrenaline)

var config float TargetRadius;
var config float XPPerHit;

function AddDefaultInventory()
{
	// do nothing. Do not want default weapon adding
}

defaultproperties
{
     HealthHealingAmount=1.000000
     ShieldHealingAmount=1.000000
     AdrenalineHealingAmount=1.000000
     ResupplyAmount=1.000000
     ArmorHealingAmount=1.000000
     TargetRadius=700.000000
     XPPerHit=0.066000
     TurretBaseClass=Class'DEKRPG208.DruidDefenseSentinelBaseCrimbo'
     VehicleNameString="Defense Sentinel"
     bCanBeBaseForPawns=False
     StaticMesh=StaticMesh'DEKStaticsMaster207P.ChristmasMeshes.FloorCandyCane'
     DrawScale=0.300000
     Skins(0)=Shader'DEKRPGTexturesMaster207P.SkinsChristmas.FloorSentShader'
     Skins(1)=FinalBlend'DEKRPGTexturesMaster207P.fX.DefensePanFinal'
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
