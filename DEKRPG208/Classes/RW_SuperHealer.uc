class RW_SuperHealer extends RW_Healer
	Config(UT2004RPG)
	HideDropDown
	CacheExempt;

var ArtifactMakeSuperHealer AMSH; //set on construction. Used to obtain health and exp bonus numbers.

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	if
	(
		(
			Weapon.default.FireModeClass[0] != None && 
			Weapon.default.FireModeClass[0].default.AmmoClass != None && 
			Weapon.default.AmmoClass[0] != None &&
			Weapon.default.AmmoClass[0].default.MaxAmmo > 0 &&
			class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[0].default.AmmoClass)
		) ||
		(
			Weapon.default.FireModeClass[1] != None && 
			Weapon.default.FireModeClass[1].default.AmmoClass != None && 
			Weapon.default.AmmoClass[1] != None &&
			Weapon.default.AmmoClass[1].default.MaxAmmo > 0 &&
			class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[1].default.AmmoClass)
		)
	)
		return false;
		
	if(instr(caps(Weapon), "LINK") > -1)
		return false;	
	
	if(instr(caps(Weapon), "MERCURY") > -1)
		return false;	
	
	if(instr(caps(Weapon), "D-E-K UTILITY RIFLE") > -1)
		return false;		
		
	if(instr(caps(Weapon), "PROASS") > -1)
		return false;			

	if(instr(caps(Weapon), "TRANSLAUNCHER") > -1)
		return false;

	if(instr(caps(Weapon), "MINE LAYER") > -1)
		return false;			

	return true;
}

simulated function bool CanThrow()
{
	return false;
}

function DropFrom(vector StartLocation)
{
	Destroy();
}

simulated function bool StartFire(int Mode)
{
	if (!bIdentified && Role == ROLE_Authority)
		Identify();

	return Super.StartFire(Mode);
}

function bool ConsumeAmmo(int Mode, float Load, bool bAmountNeededIsMax)
{
	if (!bIdentified)
		Identify();

	return true;
}

simulated function WeaponTick(float dt)
{
	MaxOutAmmo();

	Super.WeaponTick(dt);
}

function int getMaxHealthBonus()
{
	if(AMSH == None)
		AMSH = ArtifactMakeSuperHealer(Instigator.FindInventoryType(class'ArtifactMakeSuperHealer'));
	if(AMSH != None)
		return AMSH.MaxHealth;
	else
		return Super.getMaxHealthBonus();
}

function float getExpMultiplier()
{
	if(AMSH == None)
		AMSH = ArtifactMakeSuperHealer(Instigator.FindInventoryType(class'ArtifactMakeSuperHealer'));
	if(AMSH != None)
		return AMSH.EXPMultiplier;
	else
		return Super.getEXPMultiplier();
}


simulated function ConstructItemName()
{
	ItemName = PrefixPos$ModifiedWeapon.ItemName$PostfixPos;
}

defaultproperties
{
     MinModifier=6
     MaxModifier=6
     AIRatingBonus=0.100000
     PrefixPos="Medic "
     PostfixPos=" of Infinity"
     bCanThrow=False
}
