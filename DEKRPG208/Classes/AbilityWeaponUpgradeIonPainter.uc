class AbilityWeaponUpgradeIonPainter extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local WeaponFire FireMode[2];
		
	FireMode[0] = Weapon.GetFireMode(0);
	FireMode[1] = Weapon.GetFireMode(1);
		
	if (PainterFire(FireMode[0]) != None)
	{
		PainterFire(FireMode[0]).PaintDuration=0.3000000;
	}
	if (RPGPainterFire(FireMode[0]) != None)
	{
		RPGPainterFire(FireMode[0]).PaintDuration=0.3000000;
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=40
     AbilityName="Upgrade: Ion Painter"
     Description="Upgrades your Ion Painter.||Activation time for the Ion Painter is reduced.||You must be level 40 before purchasing this ability.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=1
}
