class AbilityWeaponsProficiency extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float LevMultiplier;
var config float MaxIncrease;

static function GetNumKillsForWeapon(out float incPerc, class<Weapon> WeaponClass, TeamPlayerReplicationInfo TPPI, int AbilityLevel)
{
	local int i;
	local int numKills;
	
	incPerc = 0.0;
	if (TPPI == None)
		return;

	for ( i=0; i<TPPI.WeaponStatsArray.Length && i<200; i++ )
	{
		if (ClassIsChildOf(WeaponClass, TPPI.WeaponStatsArray[i].WeaponClass))
		//if ( TPPI.WeaponStatsArray[i].WeaponClass == WeaponClass )
		{
			numKills = TPPI.WeaponStatsArray[i].Kills;
			i = TPPI.WeaponStatsArray.Length;
		}
	}
	incPerc = numKills * (AbilityLevel * default.LevMultiplier);
	if (incPerc > default.MaxIncrease)
		incPerc = default.MaxIncrease;
	KillsMaxed(incPerc);
	GetIncPerc(incPerc);
}

static function DualityGetNumKillsForWeapon(out float DualityincPerc, Pawn P)
{
	local DualityInv DInv;
	
	DInv = DualityInv(P.FindInventoryType(class'DualityInv'));
	
	if (DInv != None)
		DualityincPerc = DInv.GetIncPerc();
	KillsMaxed(DualityincPerc);
	GetIncPerc(DualityincPerc);
}

static function float GetIncPerc(out float incPerc)
{
	return incPerc;
}
static function bool KillsMaxed(out float incPerc)
{
	if (incPerc >= default.MaxIncrease)
		return True;
	else
		return False;
}

static function float GetLevMultiplier()
{
	return default.LevMultiplier;
}

static function float GetMaxIncrease()
{
	return default.MaxIncrease;
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local float incPerc, DualityIncPerc;
	local DualityInv DInv;
	local Weapon W;
	
	if(!bOwnedByInstigator)
		return;
	if (RPGWeapon(Instigator.Weapon) != None)
		W = RPGWeapon(Instigator.Weapon).ModifiedWeapon;
	else
		W = Instigator.Weapon;
	if(Damage > 0 && Instigator != None && ClassIsChildOf(DamageType, class'WeaponDamageType'))
	{
		DInv = DualityInv(Instigator.FindInventoryType(class'DualityInv'));
		
		// find the number of kills. Can't store in a global, as abilities are abstract. Go to the scoreboard.
		if(DInv != None)
		{
			DualityGetNumKillsForWeapon(DualityIncPerc, Instigator);
		}
		else
		{
			GetNumKillsForWeapon(incPerc, class<WeapondamageType>(DamageType).default.WeaponClass, TeamPlayerReplicationInfo(Instigator.PlayerReplicationInfo), AbilityLevel);
		}
			
		// ok, now check for DD
		if (Instigator.HasUDamage())
		{
			// shouldn't increase the DD bonus with this ability. To ensure just original damage gets DD boosted, half the proficiency bonus given
			// still allows the triple under some circumstances to give a bit extra, but that is rare, and those games will not normally have high kills
			DualityIncPerc = DualityIncPerc / 2.f;
			incPerc = incPerc / 2.f;
		}
		
		if (DInv != None)
		{
			if (W == DInv.DualWeaponOne || W == DInv.DualWeaponTwo)
				Damage = damage * (DualityIncPerc + 1.0);
			else if (W != DInv.DualWeaponOne && W != DInv.DualWeaponTwo)
				//W is niether of these. Do not grant proficiency bonus
				return;
		}
		else
			Damage = damage * (incPerc + 1.0);
	}
}

// note what the proficiency of this weapon is 
static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local float incPerc, DualityIncPerc;
	local int intPerc, DualityIntPerc;
	local Weapon W;
	local DualityInv DInv;
	local SpecialistInv SInv;
	
	if (Weapon == None || Weapon.Owner == None || Pawn(Weapon.Owner) == None || Pawn(Weapon.Owner).PlayerReplicationInfo == None || PlayerController(Pawn(Weapon.Owner).Controller) == None)
		return;
	if (Weapon.Role != ROLE_Authority)
		return;
		
	if (RPGWeapon(Weapon) != None)
		W = RPGWeapon(Weapon).ModifiedWeapon;
	else
		W = Weapon;
		
	if (Pawn(Weapon.Owner) != None && Pawn(Weapon.Owner).Health > 0)
	{
		DInv = DualityInv(Pawn(Weapon.Owner).FindInventoryType(class'DualityInv'));
		SInv = SpecialistInv(Pawn(Weapon.Owner).FindInventoryType(class'SpecialistInv'));
	}
	if (SInv != None)
		return;	//AbilitySpecialistProficiency will handle this
	if (DInv != None)
	{
		if (W == DInv.DualWeaponOne || W == DInv.DualWeaponTwo)
		{
			if(instr(caps(string(W)), "AVRIL") > -1)//hack for vinv avril
				DualityGetNumKillsForWeapon(DualityIncPerc, Pawn(Weapon.Owner));
			else
				DualityGetNumKillsForWeapon(DualityIncPerc, Pawn(Weapon.Owner));
		}
		else if (W != DInv.DualWeaponOne && W != DInv.DualWeaponTwo)
		{
			//W is niether of these. Do not grant proficiency bonus
			return;
		}
	}
	else
	{
		if(instr(caps(string(W)), "AVRIL") > -1)//hack for vinv avril
			GetNumKillsForWeapon(incPerc, class'INAVRiL', TeamPlayerReplicationInfo(Pawn(Weapon.Owner).PlayerReplicationInfo), AbilityLevel);
		else
			GetNumKillsForWeapon(incPerc, W.Class, TeamPlayerReplicationInfo(Pawn(Weapon.Owner).PlayerReplicationInfo), AbilityLevel);
	}
		
	intPerc = 100 * incPerc;
	DualityIntPerc = 100 * DualityIncPerc;
	if (DInv != None)
	{
		if (W == DInv.DualWeaponOne)
		{
			PlayerController(Pawn(Weapon.Owner).Controller).ReceiveLocalizedMessage(Class'ProficiencyMessage', DualityintPerc,,,DInv.DualWeaponOne);
		}
		if (W == DInv.DualWeaponTwo)
		{
			PlayerController(Pawn(Weapon.Owner).Controller).ReceiveLocalizedMessage(Class'ProficiencyMessage', DualityintPerc,,,DInv.DualWeaponTwo);
		}
		if (W != DInv.DualWeaponOne && W != DInv.DualWeaponTwo)
			PlayerController(Pawn(Weapon.Owner).Controller).ReceiveLocalizedMessage(Class'ProficiencyMessage', intPerc,,,W);
	}
	else
		PlayerController(Pawn(Weapon.Owner).Controller).ReceiveLocalizedMessage(Class'ProficiencyMessage', intPerc,,,W);
}

defaultproperties
{
     LevMultiplier=0.000500
     MaxIncrease=1.250000
     AbilityName="Weapons Proficiency"
     Description="Tracks the kills per weapon, and adds extra damage the more you kill. |Cost (per level): 20. "
     StartingCost=20
     MaxLevel=10
}
