class AbilityEnhancedHealthMax extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config int Lev1HP, Lev2HP, Lev3HP, Lev4HP, Lev5HP, Lev6HP, Lev7HP, Lev8HP, Lev9HP, Lev10HP, Lev11HP, Lev12HP, Lev13HP, Lev14HP, Lev15HP, Lev16HP, Lev17HP, Lev18HP, Lev19HP, Lev20HP;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	if (AbilityLevel == 1)
		Other.HealthMax = default.Lev1HP;
	else if (AbilityLevel == 2)
		Other.HealthMax = default.Lev2HP;
	else if (AbilityLevel == 3)
		Other.HealthMax = default.Lev3HP;
	else if (AbilityLevel == 4)
		Other.HealthMax = default.Lev4HP;
	else if (AbilityLevel == 5)
		Other.HealthMax = default.Lev5HP;
	else if (AbilityLevel == 6)
		Other.HealthMax = default.Lev6HP;
	else if (AbilityLevel == 7)
		Other.HealthMax = default.Lev7HP;
	else if (AbilityLevel == 8)
		Other.HealthMax = default.Lev8HP;
	else if (AbilityLevel == 9)
		Other.HealthMax = default.Lev9HP;
	else if (AbilityLevel == 10)
		Other.HealthMax = default.Lev10HP;
	else if (AbilityLevel == 11)
		Other.HealthMax = default.Lev11HP;
	else if (AbilityLevel == 12)
		Other.HealthMax = default.Lev12HP;
	else if (AbilityLevel == 13)
		Other.HealthMax = default.Lev13HP;
	else if (AbilityLevel == 14)
		Other.HealthMax = default.Lev14HP;
	else if (AbilityLevel == 15)
		Other.HealthMax = default.Lev15HP;
	else if (AbilityLevel == 16)
		Other.HealthMax = default.Lev16HP;
	else if (AbilityLevel == 17)
		Other.HealthMax = default.Lev17HP;
	else if (AbilityLevel == 18)
		Other.HealthMax = default.Lev18HP;
	else if (AbilityLevel == 19)
		Other.HealthMax = default.Lev19HP;
	else if (AbilityLevel == 20)
		Other.HealthMax = default.Lev20HP;
}

defaultproperties
{
     Lev1HP=305
     Lev2HP=310
     Lev3HP=315
     Lev4HP=320
     Lev5HP=325
     Lev6HP=330
     Lev7HP=335
     Lev8HP=340
     Lev9HP=345
     Lev10HP=350
     Lev11HP=355
     Lev12HP=360
     Lev13HP=365
     Lev14HP=370
     Lev15HP=375
     Lev16HP=380
     Lev17HP=385
     Lev18HP=390
     Lev19HP=395
     Lev20HP=400
     MinHealthBonus=200
     AbilityName="Advanced Health Bonus"
     Description="Increases your cumulative health bonus by 5 per level.||You you need to have at least 200 Health Bonus to purchase this ability.||Cost(per level): 5."
     StartingCost=5
     MaxLevel=20
}
