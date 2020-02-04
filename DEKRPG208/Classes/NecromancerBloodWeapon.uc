class NecromancerBloodWeapon extends Weapon
	CacheExempt;

defaultproperties
{
     ItemName="Blood Magic"
     FireModeClass(0)=Class'DEKRPG208.NecromancerBloodWeaponFire'
     FireModeClass(1)=Class'DEKRPG208.NecromancerBloodWeaponAltFire'
     bCanThrow=False
     InventoryGroup=1
     DrawScale=0.050000
	 HudColor=(R=77,B=0,G=0)
	 IconMaterial=Texture'DEKRPGTexturesMaster207P.NecroIcons.BloodMagicIcon'
	 IconCoords=(X1=1,Y1=1,X2=64,Y2=64)
}
