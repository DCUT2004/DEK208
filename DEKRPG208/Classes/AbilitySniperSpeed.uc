class AbilitySniperSpeed extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float SpeedMultiplier;

static simulated function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local float Modifier;
	local WeaponFire FireMode[2];
	local RPGStatsInv StatsInv;
	local int WeaponSpeed;

	if (Weapon == None)
		return;
	
	WeaponSpeed = 0;
	if (Pawn(Weapon.Owner) != None)
	{
		StatsInv = RPGStatsInv(Pawn(Weapon.Owner).FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None)
			WeaponSpeed =  StatsInv.Data.WeaponSpeed;
	}

	Modifier = 1.f + 0.01 * WeaponSpeed;	// first add on his weaponspeed stats
	Modifier *= 1.f + (default.SpeedMultiplier * AbilityLevel);	// now take off the speed due to this ability
	if (Modifier < 0.1)
		Modifier = 0.1;

	FireMode[0] = Weapon.GetFireMode(0);
	FireMode[1] = Weapon.GetFireMode(1);
	if (FireMode[0].IsA('ShockBeamFire') || FireMode[0].IsA('SniperFire') || FireMode[0].IsA('ClassicSniperFire') || FireMode[0].IsA('CryoarithmeticBeamFire') || FireMode[1].IsA('CryoarithmeticBeamAltFire') || FireMode[0].IsA('DEKMercuryFire'))
	{
		if (FireMode[0] != None)
		{
			FireMode[0].FireRate = FireMode[0].default.FireRate / Modifier;
			FireMode[0].FireAnimRate = FireMode[0].default.FireAnimRate * Modifier;
			FireMode[0].MaxHoldTime = FireMode[0].default.MaxHoldTime / Modifier;
		}
		if (FireMode[1] != None)
		{
			FireMode[1].FireRate = FireMode[1].default.FireRate / Modifier;
			FireMode[1].FireAnimRate = FireMode[1].default.FireAnimRate * Modifier;
			FireMode[1].MaxHoldTime = FireMode[1].default.MaxHoldTime / Modifier;
		}
	}
	if (DEKRailGunFire(FireMode[0]) != None)
	{
		DEKRailGunFire(FireMode[0]).ChargeUpRate = (DEKRailGunFire(FireMode[0]).default.ChargeUpRate / Modifier);
	}
}

defaultproperties
{
     SpeedMultiplier=0.030000
     AbilityName="Sniper Speed"
     Description="Increases your weapon speed on sniper-type weapons by 3% per level. This includes the shock rifle, sniper rifle, lightning gun, cryoarithmetic equalizer, mercury launcher and rail gun.|Cost (per level): 7,10,13.."
     StartingCost=7
	 CostAddPerLevel=3
     MaxLevel=20
}
