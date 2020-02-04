class ClassAdrenalineMaster extends RPGClass
	config(UT2004RPG)
	abstract;
	
var config float DamageReductionMultiplier;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local RPGStatsInv StatsInv;
	local int y;
	local int RegenLevel;
	local int RegenIndex;
	RegenIndex = -1;
	
	class'ClassWeaponsMaster'.static.ModifyPawn(other, AbilityLevel); //give them the health regen.
	class'ClassWeaponsMaster'.static.AdrenMessage(Other, 1);
	
	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));
 	if (StatsInv != None && StatsInv.DataObject != None && StatsInv.DataObject.Level <= default.MediumLevel)
 	{
 		for (y = 0; y < StatsInv.Data.Abilities.length; y++)
 		{
 			if (ClassIsChildOf(StatsInv.Data.Abilities[y], class'DruidAdrenalineRegen'))
 			{
 				RegenLevel = StatsInv.Data.AbilityLevels[y];
 				RegenIndex = y;
 			}
 		}

		if(StatsInv.DataObject.Level <= default.LowLevel)
		{
			if(RegenIndex >= 0)
				StatsInv.Data.Abilities[RegenIndex].static.ModifyPawn(Other, RegenLevel + 3);
			else
				class'DruidAdrenalineRegen'.static.ModifyPawn(Other, RegenLevel + 3);
		}
		else if(StatsInv.DataObject.Level <= default.MediumLevel)
		{
			if(RegenIndex >= 0)
				StatsInv.Data.Abilities[RegenIndex].static.ModifyPawn(Other, RegenLevel + 2);
			else
				class'DruidAdrenalineRegen'.static.ModifyPawn(Other, RegenLevel + 2);
		}
 	}
	Super(RPGClass).ModifyPawn(Other, AbilityLevel);
}

static function HandleDamage(int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local RPGStatsInv StatsInv;
	
	if (bOwnedByInstigator)
		return;
	if (Instigator != None)
	{
		StatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None && StatsInv.DataObject.Level <= default.MediumLevel)
		{
			if(StatsInv.DataObject.Level <= default.LowLevel)
			{
				if (Damage > 0 && !bOwnedByInstigator)
					Damage *= (1 - default.DamageReductionMultiplier);
			}
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
     AbilityName="Class: Adrenaline Master"
     Description="Adrenaline Masters convert adrenaline into attacks and defensive boosts via artifacts, such as Ice Beam, Meteor Shower, Invulnerability Sphere, and Damage Sphere. This class excels at magic weapon enhancements and relies on a form of adrenaline shield to survive. This class is ideal for players who like challenging, tactical play.||At level 90, Adrenaline Masters can branch off into various subclasses such as Extreme and Craftsman.||You can not be more than one class at any time. You must purchase a class first before purchasing any ability or stats."
     BotChance=7
}
