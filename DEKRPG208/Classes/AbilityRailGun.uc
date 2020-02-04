class AbilityRailGun extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

// these config variables just affect the server so ok
var config Array< String > WeaponRailGunOne;

static function bool AbilityIsAllowed(GameInfo Game, MutUT2004RPG RPGMut)
{
	if(RPGMut.WeaponModifierChance == 0)
		return false;

	return true;
}

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local Mutator m;
	local MutUT2004RPG RPGMut;
	local int x;
	local LoadedInv LoadedInv;
	local int OldLevel;

	if (Other == None)
			return;
			
	if (Other.Level != None && Other.Level.Game != None)
	{
		for (m = Other.Level.Game.BaseMutator; m != None; m = m.NextMutator)
		if (MutUT2004RPG(m) != None)
		{
			RPGMut = MutUT2004RPG(m);
			break;
		}
	}

	LoadedInv = LoadedInv(Other.FindInventoryType(class'LoadedInv'));

	if (LoadedInv != None)
	{
		if(LoadedInv.bGotRailGun && LoadedInv.LRailGunAbilityLevel == AbilityLevel)
			return;
	}
	else
	{
		LoadedInv = Other.spawn(class'LoadedInv');
		if(LoadedInv != None)
			LoadedInv.giveTo(Other);
	}

	if(LoadedInv == None)
		return;

	LoadedInv.bGotRailGun = true;
	OldLevel = LoadedInv.LRailGunAbilityLevel;		// keep old level so only add new weapons
	LoadedInv.LRailGunAbilityLevel = AbilityLevel;

	if(Other.Role != ROLE_Authority)
		return;

	if (OldLevel < 1)
		for(x = 0; x < default.WeaponRailGunOne.length; x++)
			giveWeapon(Other, default.WeaponRailGunOne[x], AbilityLevel, RPGMut);
	
}

static function giveWeapon(Pawn Other, String oldName, int AbilityLevel, MutUT2004RPG RPGMut)
{
	Local string newName;
	local class<Weapon> WeaponClass;
	local class<RPGWeapon> RPGWeaponClass;
	local Weapon NewWeapon;
	local RPGWeapon RPGWeapon;
	local int x;

	if(Other == None || Other.IsA('Monster'))
		return;

	if(oldName == "")
		return;

	if (Other.Level != None && Other.Level.Game != None && Other.Level.Game.BaseMutator != None)
	{
		newName = Other.Level.Game.BaseMutator.GetInventoryClassOverride(oldName);
		WeaponClass = class<Weapon>(Other.DynamicLoadObject(newName, class'Class'));
	}
	else
		WeaponClass = class<Weapon>(Other.DynamicLoadObject(oldName, class'Class'));

	newWeapon = Other.spawn(WeaponClass, Other,,, rot(0,0,0));
	if(newWeapon == None)
		return;
///After this is special stuff for the higher levels of WM Loaded.	
	while(newWeapon.isA('RPGWeapon'))
		newWeapon = RPGWeapon(newWeapon).ModifiedWeapon;

	if(AbilityLevel >= 2)
		RPGWeaponClass = GetRandomWeaponModifier(WeaponClass, Other, RPGMut);
	else
		RPGWeaponClass = RPGMut.GetRandomWeaponModifier(WeaponClass, Other);

	RPGWeapon = Other.spawn(RPGWeaponClass, Other,,, rot(0,0,0));
	if(RPGWeapon == None)
		return;
	RPGWeapon.Generate(None);
	
	//I'm checking the state of RPG Weapon a bunch because sometimes it becomes none mid method.
	if(RPGWeapon == None)
		return;

	if(AbilityLevel >= 2)		// need better modifier
	{
		if (AbilityLevel > 2)
		{
			RPGWeapon.Modifier = RPGWeapon.MaxModifier;
		}
		else
		{
			for(x = 0; x < 50; x++)
			{
				if(RPGWeapon.Modifier > -1)
					break;
				RPGWeapon.Generate(None);
				if(RPGWeapon == None)
					return;
			}
		}
	}

	if(RPGWeapon == None)
		return;

	RPGWeapon.SetModifiedWeapon(newWeapon, true);

	if(RPGWeapon == None)
		return;

	RPGWeapon.GiveTo(Other);

	if(RPGWeapon == None)
		return;

	if(AbilityLevel == 2)
	{
		RPGWeapon.FillToInitialAmmo();
	}

}

static function class<RPGWeapon> GetRandomWeaponModifier(class<Weapon> WeaponType, Pawn Other, MutUT2004RPG RPGMut)
{
	local int x, Chance;

	Chance = Rand(RPGMut.TotalModifierChance);
	for (x = 0; x < RPGMut.WeaponModifiers.Length; x++)
	{
		Chance -= RPGMut.WeaponModifiers[x].Chance;
		if (Chance < 0 && RPGMut.WeaponModifiers[x].WeaponClass.static.AllowedFor(WeaponType, Other))
			return RPGMut.WeaponModifiers[x].WeaponClass;
	}

	return class'RPGWeapon';
}

defaultproperties
{
     WeaponRailGunOne(0)="DEKWeapons208.DEKRailGun"
     AbilityName="Rail Gun"
     Description="You are granted the Rail Gun.||Level 2 generates a magic weapon with a positive enchantment and full ammo.||Cost(per level): 5,10."
     StartingCost=5
     CostAddPerLevel=5
     MaxLevel=2
}
