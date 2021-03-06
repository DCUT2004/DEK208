class DEKLoadedClassicAR extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

// these config variables just affect the server so ok
var config Array< String > ClassicAROne;

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
	local Inventory OInv;
	local Inventory AR;
	local Inventory DEKAVRIL;
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
		if(LoadedInv.bGotLoadedClassicAR && LoadedInv.LARAbilityLevel == AbilityLevel)
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

	LoadedInv.bGotLoadedClassicAR = true;
	OldLevel = LoadedInv.LARAbilityLevel;		// keep old level so only add new weapons
	LoadedInv.LARAbilityLevel = AbilityLevel;

	if(Other.Role != ROLE_Authority)
		return;

	for (OInv=Other.Inventory ; OInv != None && (AR == None || DEKAVRIL == None) ; OInv=OInv.Inventory)
	{
// You can't delete within the for, as Deleting results in OInv == None, so
// the AR is never found.  Instead, grab them both in their own var ...
		if(instr(caps(OInv.ItemName), "ASSAULT RIFLE") > -1)
		{
			AR=OInv;
		}
		if(instr(caps(OInv.ItemName), "AVRIL") > -1)
		{
			DEKAVRIL=OInv;
		}
	}

// This stops the client from erroneously deleting the AR and DEKAVRIL - like
// after a ghost, getting into and out of a vehicle ... all those dumb
// cases where the client likes to run ModifyPawn when it probably
// shouldn't.

	// And delete them after they're both found.
	if(AR != None && LoadedInv != None)
		Other.DeleteInventory(AR);
	if(DEKAVRIL != None && LoadedInv != None)
		Other.DeleteInventory(DEKAVRIL);

	// so give them the weapons
	// but only ones granted as part of this upgrade. otherwise get multiple copies of each
	if (OldLevel < 1)
		for(x = 0; x < default.ClassicAROne.length; x++)
			giveWeapon(Other, default.ClassicAROne[x], AbilityLevel, RPGMut);

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
	else if(AbilityLevel > 2)
	{
		if (oldName == "XWeapons.AssaultRifle")
		{
			RPGWeapon.Loaded();
		}
		RPGWeapon.MaxOutAmmo();
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
     ClassicAROne(0)="XWeapons.AssaultRifle"
     PlayerLevelReqd(1)=1
     PlayerLevelReqd(2)=1
     ExcludingAbilities(0)=Class'DEKRPG208.DEKLoadedAVRiL'
     AbilityName="Starting Weapon: Assault Rifle"
     Description="When you spawn:|You are granted an Assault Rifle, replacing your AVRiL.||Level 2 generates a magic weapon with a positive enchantment and full ammo.||Cost: 1,5"
     StartingCost=1
     CostAddPerLevel=4
     MaxLevel=2
}
