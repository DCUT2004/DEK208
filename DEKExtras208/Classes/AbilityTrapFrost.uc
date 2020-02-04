class AbilityTrapFrost extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local Mutator m;
	local MutUT2004RPG RPGMut;
	local Inventory OInv;
	local int OldLevel;
	local RW_TrapInfinity LG;
	local Weapon NewWeapon;
	local LoadedInv LoadedInv;

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
		if(LoadedInv.bGotFrostTrap && LoadedInv.FTrapAbilityLevel == AbilityLevel)
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

	LoadedInv.bGotFrostTrap = true;
	OldLevel = LoadedInv.FTrapAbilityLevel;		// keep old level so only add new weapons
	LoadedInv.FTrapAbilityLevel = AbilityLevel;
	
	if(Other.Role != ROLE_Authority)
		return;
	// Now let's give the Laser Grenade
	LG = None;
	for (OInv=Other.Inventory; OInv != None; OInv = OInv.Inventory)
	{
		if(ClassIsChildOf(OInv.Class,class'RW_TrapInfinity'))
		{
			LG = RW_TrapInfinity(OInv);
			break;
		}
	}
	//if (LG != None)
		//return; //already got one

	// now add the new one.
	NewWeapon = Other.spawn(class'FrostTrap', Other,,, rot(0,0,0));
	if(NewWeapon == None)
		return;
	while(NewWeapon.isA('RPGWeapon'))
		NewWeapon = RPGWeapon(NewWeapon).ModifiedWeapon;

	LG = Other.spawn(class'RW_TrapInfinity', Other,,, rot(0,0,0));
	if(LG == None)
		return;

	LG.Generate(None);

	//I'm checking the state of RPG Weapon a bunch because sometimes it becomes none mid method.
	if(LG != None)
		LG.SetModifiedWeapon(NewWeapon, true);

	if(LG != None)
		LG.GiveTo(Other);
		
	if (FrostTrap(NewWeapon) != None)
		FrostTrap(NewWeapon).MaxMines += (AbilityLevel - 1); //default is 3 for DC Server
}

defaultproperties
{
     ExcludingAbilities(0)=Class'DEKExtras208.AbilityTrapWildfire'
     AbilityName="Frost Trap"
     Description="You are granted the Frost Trap, which will allow you to lay traps. This trap does more damage to Fire monsters, and will also freeze targets.||Each level after the first adds an additional deployable trap. You can not have Wildfire Trap at the same time as this ability.||Cost(per level): 5,7,9,11,13,15...||Note: You must reconnect for the extra mines to show up."
     StartingCost=10
     CostAddPerLevel=2
     MaxLevel=20
}
