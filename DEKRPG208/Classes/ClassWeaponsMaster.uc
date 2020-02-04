class ClassWeaponsMaster extends RPGClass
	config(UT2004RPG)
	abstract;
	
var config float DamageReductionMultiplier;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	class'ClassWeaponsMaster'.static.AddLowLevelRegen(Other, 0);
	class'ClassWeaponsMaster'.static.AdrenMessage(Other, 1);
	
	Super(RPGClass).ModifyPawn(Other, AbilityLevel);
}

static simulated function AddLowLevelRegen(Pawn Other, int AdditionalLevelAdd)
{
	local RPGStatsInv StatsInv;
	local int y;
	local int RegenLevel;
	local int RegenIndex;
	RegenIndex = -1;
	
	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));
 	if (StatsInv != None && StatsInv.DataObject != None && StatsInv.DataObject.Level <= default.MediumLevel)
 	{
 		for (y = 0; y < StatsInv.Data.Abilities.length; y++)
 		{
 			if (ClassIsChildOf(StatsInv.Data.Abilities[y], class'AbilityRegen'))
 			{
 				RegenLevel = StatsInv.Data.AbilityLevels[y];
 				RegenIndex = y;
 			}
 		}
	
		if(StatsInv.DataObject.Level <= default.LowLevel)
		{
			if(RegenIndex >= 0)
				StatsInv.Data.Abilities[RegenIndex].static.ModifyPawn(Other, RegenLevel + 3 + AdditionalLevelAdd);
			else
				class'DruidRegen'.static.ModifyPawn(Other, RegenLevel + 3 + AdditionalLevelAdd);
		}
		else if(StatsInv.DataObject.Level <= default.MediumLevel)
		{
			if(RegenIndex >= 0)
				StatsInv.Data.Abilities[RegenIndex].static.ModifyPawn(Other, RegenLevel + 2 + AdditionalLevelAdd);
			else
				class'DruidRegen'.static.ModifyPawn(Other, RegenLevel + 2 + AdditionalLevelAdd);
		}
 	}
}

static simulated function AdrenMessage(Pawn Other, int AbilityLevel)
{
	local RPGStatsInv StatsInv;
	
	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));
 	if (StatsInv != None && StatsInv.DataObject != None)
 	{
		class'AbilityAdrenalineAwareness'.static.ModifyPawn(Other, 1);	
	}
}

static function HandleDamage(int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local RPGStatsInv StatsInv;
	
	if (Instigator != None)
	{
		StatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None && StatsInv.DataObject.Level <= default.MediumLevel)
		{
			if (Damage > 0 && !bOwnedByInstigator)
				Damage *= (1 - default.DamageReductionMultiplier);
			if(StatsInv.DataObject.Level <= default.LowLevel)
				class'DruidVampire'.static.HandleDamage(Damage, Injured, Instigator, Momentum, DamageType, bOwnedByInstigator, 3);
		}
	}
}

static function ScoreKill(Controller Killer, Controller Killed, bool bOwnedByKiller, int AbilityLevel)
{
	local RPGStatsInv StatsInv;
	
	if (Killer != None && Killer.Pawn != None && Killer.Pawn.Health > 0)
	{
		StatsInv = RPGStatsInv(Killer.Pawn.FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None && StatsInv.DataObject.Level <= default.MediumLevel)
		{
			class'AbilityLuckyStrike'.static.ScoreKill(Killer, Killed, True, 5);
		}
	}
	Super(RPGClass).ScoreKill(Killer,Killed,bOwnedByKiller,AbilityLevel);
}

defaultproperties
{
     DamageReductionMultiplier=0.300000
     AbilityName="Class: Weapons Master"
     Description="Weapon Masters deal high damage. They start with extra weapons and ammo, are self-sustaining, and receive positive magic weapon enhancements. This class is ideal for players who like to run and gun.||At level 90, Weapons Masters can branch off into various subclasses such as Tank, Sniper, Berserker, Weapons Proficiency, and Extreme.||You can not be more than one class at any time. You must purchase a class first before purchasing any ability or stats."
     BotChance=10
}
