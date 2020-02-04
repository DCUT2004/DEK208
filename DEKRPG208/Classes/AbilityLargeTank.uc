class AbilityLargeTank extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float DamageMultiplier;
var config float SizeMultiplier;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local xPawn X;
	local LargeInv Inv;
	
	Inv = LargeInv(Other.FindInventoryType(class'LargeInv'));
	if (Inv == None)
	{
		Inv= Other.spawn(class'LargeInv', Other,,, rot(0,0,0));
		if(Inv == None)
			return; //get em next pass I guess?
		Inv.giveTo(Other);
		Inv.AbilityLevel = AbilityLevel;
	}
	
	X = xPawn(Other);
	if (X != None)
	{
		X.SetDrawscale(1 + (AbilityLevel * default.SizeMultiplier) * X.Default.DrawScale);
		X.SetCollisionSize((1+(AbilityLevel*default.SizeMultiplier))*X.CollisionRadius, (1+(AbilityLevel*default.SizeMultiplier))*X.CollisionHeight);
		X.BaseEyeheight = (1 +(AbilityLevel*0.3) * X.CollisionHeight);
	}
	//if (X.Role == ROLE_Authority)
	//{
	//	X.SetDrawscale(1 + (AbilityLevel * default.SizeMultiplier) * X.Default.DrawScale);
	//	X.SetCollisionSize((1+(AbilityLevel*default.SizeMultiplier))*X.CollisionRadius, (1+(AbilityLevel*default.SizeMultiplier))*X.CollisionHeight);
	//	X.BaseEyeheight = (1 +(AbilityLevel*0.3) * X.CollisionHeight);
	//}
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
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityHeavyTank'
     ExcludingAbilities(1)=Class'DEKRPG208.AbilityRecklessTank'
	 SizeMultiplier=.070000
     DamageMultiplier=0.050000
     AbilityName="Niche: Giant"
     Description="Increases your cumulative total damage bonus by 5% per level. However, your collision size increases by 7% per level, making you a larger target.|You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
