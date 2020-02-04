class DEKLoadedWarrior extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

// these config variables just affect the server so ok
var config Array< String > WarOneWeapons;
var config Array< String > WarTwoWeapons;
var config Array< String > WarThreeWeapons;

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
	local Inventory CHN;
	local Inventory SWD;
	local Inventory BLD;
	local Inventory KTN;
	local Inventory HMR;
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
		if(LoadedInv.bGotLoadedWarrior && LoadedInv.LWarAbilityLevel == AbilityLevel)
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

	LoadedInv.bGotLoadedWarrior = true;
	OldLevel = LoadedInv.LWarAbilityLevel;		// keep old level so only add new weapons
	LoadedInv.LWarAbilityLevel = AbilityLevel;

	if(Other.Role != ROLE_Authority)
		return;

	for (OInv=Other.Inventory ; OInv != None && (CHN == None || SWD == None || BLD == None || KTN == None || HMR == None) ; OInv=OInv.Inventory)
	{
// You can't delete within the for, as Deleting results in OInv == None, so
// the AR is never found.  Instead, grab them both in their own var ...
		if(instr(caps(OInv.ItemName), "CHAINSAW") > -1)
		{
			CHN=OInv;
		}
		if(instr(caps(OInv.ItemName), "SWORD") > -1)
		{
			SWD=OInv;
		}
		if(instr(caps(OInv.ItemName), "BLADE") > -1)
		{
			BLD=OInv;
		}
		if(instr(caps(OInv.ItemName), "KATANA") > -1)
		{
			KTN=OInv;
		}
		if(instr(caps(OInv.ItemName), "HAMMER") > -1)
		{
			HMR=OInv;
		}
	}

// This stops the client from erroneously deleting the SG and AR - like
// after a ghost, getting into and out of a vehicle ... all those dumb
// cases where the client likes to run ModifyPawn when it probably
// shouldn't.

	// And delete them after they're both found.
	if(CHN != None && LoadedInv != None)
		Other.DeleteInventory(CHN);
	if(SWD != None && LoadedInv != None)
		Other.DeleteInventory(SWD);
	if(BLD != None && LoadedInv != None)
		Other.DeleteInventory(BLD);
	if(KTN != None && LoadedInv != None)
		Other.DeleteInventory(KTN);
	if(HMR != None && LoadedInv != None)
		Other.DeleteInventory(HMR);			

	// so give them the weapons
	// but only ones granted as part of this upgrade. otherwise get multiple copies of each
	if (OldLevel < 1)
		for(x = 0; x < default.WarOneWeapons.length; x++)
			giveWeapon(Other, default.WarOneWeapons[x], AbilityLevel, RPGMut);
	if (OldLevel < 2)
		for(x = 0; AbilityLevel >= 2 && x < default.WarTwoWeapons.length; x++)
			giveWeapon(Other, default.WarTwoWeapons[x], AbilityLevel, RPGMut);
	if (OldLevel < 3)
		for(x = 0; Other.Level.Game.IsA('Invasion') && AbilityLevel >= 3 && x < default.WarThreeWeapons.length; x++)
			giveWeapon(Other, default.WarThreeWeapons[x], AbilityLevel, RPGMut);

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

	if(AbilityLevel >= 5)
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

	if(AbilityLevel >= 5)		// need better modifier
	{
		if (AbilityLevel > 5)
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

	if(AbilityLevel == 5)
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
     WarOneWeapons(0)="UTClassic.ClassicSniperRifle"
     WarTwoWeapons(0)="UTClassic.ClassicSniperRifle"
     WarThreeWeapons(0)="XWeapons.Redeemer"
     PlayerLevelReqd(1)=1
     PlayerLevelReqd(2)=40
     PlayerLevelReqd(3)=40
     PlayerLevelReqd(4)=1255
     PlayerLevelReqd(5)=1255
     PlayerLevelReqd(6)=1255
     AbilityName="Extra Weapons"
     Description="When you spawn:|Level 1: You are granted a Warrior's Weapon.|Level 2: You are granted an additional Warrior's Weapon.|You must be level 40 before you can buy level 2.|Cost (per level): 7,10.."
     StartingCost=7
     CostAddPerLevel=3
     MaxLevel=3
}
