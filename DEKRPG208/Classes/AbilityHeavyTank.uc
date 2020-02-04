class AbilityHeavyTank extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float DamageMultiplier;
var config float SpeedMultiplier;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local xPawn X;
	
	X = xPawn(Other);
	if (X != None)
	{
		X.MaxMultiJump -= AbilityLevel;
		X.MultiJumpRemaining -= AbilityLevel;
		if (AbilityLevel >= 4)
		{
			X.JumpZ = 0;
			X.bCanDodgeDoubleJump = False;
		}
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0 && ClassIsChildOf(DamageType, class'WeaponDamageType'))
		Damage *= (1 + (AbilityLevel * default.DamageMultiplier));
}

defaultproperties
{
     PlayerLevelReqd(1)=180
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityLargeTank'
     ExcludingAbilities(1)=Class'DEKRPG208.AbilityRecklessTank'
     DamageMultiplier=0.050000
     AbilityName="Niche: Heavy"
     Description="Increases your cumulative total damage bonus by 5% per level. However, your maximum jumping and dodging decreases by 1 per level.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
