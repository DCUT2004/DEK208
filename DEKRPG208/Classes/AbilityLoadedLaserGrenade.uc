class AbilityLoadedLaserGrenade extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

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
	local LoadedInv LoadedInv;
	local Inventory OInv;
	local int OldLevel;
	local RW_EngineerLaserGrenade LG;
	local Weapon NewWeapon;

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
		if(LoadedInv.bGotLoadedLaser && LoadedInv.LLaserAbilityLevel == AbilityLevel)
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

	LoadedInv.bGotLoadedLaser = true;
	OldLevel = LoadedInv.LLaserAbilityLevel;		// keep old level so only add new weapons
	LoadedInv.LLaserAbilityLevel = AbilityLevel;

	if(Other.Role != ROLE_Authority)
		return;
	// Now let's give the Laser Grenade
	LG = None;
	for (OInv=Other.Inventory; OInv != None; OInv = OInv.Inventory)
	{
		if(ClassIsChildOf(OInv.Class,class'RW_EngineerLaserGrenade'))
		{
			LG = RW_EngineerLaserGrenade(OInv);
			break;
		}
	}
	if (LG != None)
		return; //already got one

	// now add the new one.
	NewWeapon = Other.spawn(class'DEKLaserGrenadeLauncher', Other,,, rot(0,0,0));
	if(NewWeapon == None)
		return;
	while(NewWeapon.isA('RPGWeapon'))
		NewWeapon = RPGWeapon(NewWeapon).ModifiedWeapon;

	LG = Other.spawn(class'RW_EngineerLaserGrenade', Other,,, rot(0,0,0));
	if(LG == None)
		return;

	LG.Generate(None);

	//I'm checking the state of RPG Weapon a bunch because sometimes it becomes none mid method.
	if(LG != None)
		LG.SetModifiedWeapon(NewWeapon, true);

	if(LG != None)
		LG.GiveTo(Other);
		
	if (DEKLaserGrenadeLauncher(NewWeapon) != None)
		DEKLaserGrenadeLauncher(NewWeapon).MaxMines += (AbilityLevel - 1); //default is 3 for DC Server
}

defaultproperties
{
     AbilityName="Laser Mines"
     Description="You are granted the Laser Mine Deployer. Any enemy that comes into contact with the laser will take damage.||Each level after the first increases the maximum deployable mines by one.||Cost(per level): 10,12,14,16,18,20..."
     StartingCost=10
     CostAddPerLevel=2
     MaxLevel=20
}
