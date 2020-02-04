class ClassGeneral extends RPGClass
	config(UT2004RPG)
	abstract;
	
var config float DamageReductionMultiplier;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	class'ClassAdrenalineMaster'.static.ModifyPawn(Other, AbilityLevel); //gives them a bit of regen and drip
	class'ClassWeaponsMaster'.static.AdrenMessage(Other, 1);
	
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
     AbilityName="Class: General"
     Description="Generals are a mixture of Weapon, Adrenaline, Monster/Medic, and Engineer Masters. This class is versatile and can quickly switch between offensive and defensive styles, but does not max out on any one class.||At level 90, Generals can branch off into various hybrids, such as Weapon-Medics or Adrenaline-Engineers.||You can not be more than one class at any time. You must purchase a class first before purchasing any ability or stats."
     BotChance=7
}
