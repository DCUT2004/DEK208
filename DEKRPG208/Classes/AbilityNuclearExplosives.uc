class AbilityNuclearExplosives extends CostRPGAbility
	config(UT2004RPG);

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local WeaponFire FireMode[2];
	local Weapon W;
	
	if (Weapon == None || Weapon.Owner == None || Pawn(Weapon.Owner) == None || Pawn(Weapon.Owner).PlayerReplicationInfo == None || PlayerController(Pawn(Weapon.Owner).Controller) == None)
		return;
	if (Weapon.Role != ROLE_Authority)
		return;
		
	if (RPGWeapon(Weapon) != None)
		W = RPGWeapon(Weapon).ModifiedWeapon;
	else
		W = Weapon;
		
	FireMode[0] = Weapon.GetFireMode(0);
	FireMode[1] = Weapon.GetFireMode(1);
		
	if (BombTrapFire(FireMode[0]) != None && BombTrap(W) != None)
	{
		BombTrapFire(FireMode[0]).ProjectileClass=class'DEKRPG208.BombTrapProjectileNuclear';
	}
	if (WildfireTrapFire(FireMode[0]) != None && WildfireTrap(W) != None)
	{
		WildfireTrapFire(FireMode[0]).ProjectileClass=class'DEKRPG208.WildfireTrapProjectileNuclear';
	}
	if (FrostTrapFire(FireMode[0]) != None && FrostTrap(W) != None)
	{
		FrostTrapFire(FireMode[0]).ProjectileClass=class'DEKRPG208.FrostTrapProjectileNuclear';
	}
	if (ShockTrapFire(FireMode[0]) != None && ShockTrap(W) != None)
	{
		ShockTrapFire(FireMode[0]).ProjectileClass=class'DEKRPG208.ShockTrapProjectileNuclear';
	}
	if (AerialTrapFire(FireMode[0]) != None && AerialTrap(W) != None)
	{
		AerialTrapFire(FireMode[0]).ProjectileClass=class'DEKRPG208.AerialTrapProjectileNuclear';
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=180
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityBombardierExplosives'
     AbilityName="Niche: Nuclear"
     Description="Increases the damage radius of all traps, but decreases the time between trap explosions.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.||Cost(per level): 50"
     StartingCost=50
     MaxLevel=1
}
