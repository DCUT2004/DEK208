class ClassNecromancer extends RPGClass
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
static function bool GenuinePreventDeath(Pawn Killed, Controller Killer, class<DamageType> DamageType, vector HitLocation, int AbilityLevel)
{
	local RPGStatsInv StatsInv;
	local int y;
	local int GhostLevel;
	local int GhostIndex;
	GhostIndex = -1;
	
	StatsInv = RPGStatsInv(Killed.FindInventoryType(class'RPGStatsInv'));
 	if (StatsInv != None && StatsInv.DataObject.Level <= default.MediumLevel)
 	{
 		for (y = 0; y < StatsInv.Data.Abilities.length; y++)
 		{
 			if (ClassIsChildOf(StatsInv.Data.Abilities[y], class'AbilityNecroGhost'))
 			{
 				GhostLevel = StatsInv.Data.AbilityLevels[y];
 				GhostIndex = y;
 			}
 		}

		if(StatsInv.DataObject.Level <= default.LowLevel)
		{
			if(GhostIndex >= 0)
				return StatsInv.Data.Abilities[GhostIndex].static.PreventDeath(Killed, Killer, DamageType, HitLocation, 2, false);
			else
				return class'AbilityNecroGhost'.static.GenuinePreventDeath(Killed, Killer, DamageType, HitLocation, 2);
			
		}
		else if(StatsInv.DataObject.Level <= default.MediumLevel)
		{
			if(GhostIndex >= 0)
				return StatsInv.Data.Abilities[GhostIndex].static.PreventDeath(Killed, Killer, DamageType, HitLocation, 1, false);
			else
				return class'AbilityNecroGhost'.static.GenuinePreventDeath(Killed, Killer, DamageType, HitLocation, 1);
		}
 	}
}

static function bool PreventSever(Pawn Killed, name boneName, int Damage, class<DamageType> DamageType, int AbilityLevel)
{
	local RPGStatsInv StatsInv;
	Local InvulnerabilityInv IInv;
	local PaladinInv PInv;
	local int y;
	local int GhostLevel;
	local int GhostIndex;
	GhostIndex = -1;
	
	IInv = InvulnerabilityInv(Killed.FindInventoryType(class'InvulnerabilityInv'));
	if (IInv != None)
	{
	    return true;
	}
	PInv = PaladinInv(Killed.FindInventoryType(class'PaladinInv'));
	if (PInv != None && PInv.GuardianController.Pawn != None && PInv.GuardianController.Pawn.Health > 0 && PInv.GuardianController.Adrenaline >= PInv.AdrenalineRequired && PInv.bInvulReady)
	{
	    return true;
	}
	
	StatsInv = RPGStatsInv(Killed.FindInventoryType(class'RPGStatsInv'));
 	if (StatsInv != None && StatsInv.DataObject.Level <= default.MediumLevel)
 	{
 		for (y = 0; y < StatsInv.Data.Abilities.length; y++)
 		{
 			if (ClassIsChildOf(StatsInv.Data.Abilities[y], class'AbilityNecroGhost'))
 			{
 				GhostLevel = StatsInv.Data.AbilityLevels[y];
 				GhostIndex = y;
 			}
 		}

		if(StatsInv.DataObject.Level <= default.LowLevel)
		{
			if(GhostIndex >=0)
				return StatsInv.Data.Abilities[GhostIndex].static.PreventSever(Killed, boneName, Damage, DamageType, 2);
			else
				return class'AbilityNecroGhost'.static.PreventSever(Killed, boneName, Damage, DamageType, 2);
		}
		else if(StatsInv.DataObject.Level <= default.MediumLevel)
		{
			if(GhostIndex >=0)
				return StatsInv.Data.Abilities[GhostIndex].static.PreventSever(Killed, boneName, Damage, DamageType, Max(1, GhostLevel + 1));
			else
				return class'AbilityNecroGhost'.static.PreventSever(Killed, boneName, Damage, DamageType, 1);
		}
 	}
}

defaultproperties
{
     DamageReductionMultiplier=0.300000
     AbilityName="Class: Necromancer"
     Description="Necromancers can resurrect fallen allies, possess hostile monsters, and spread deadly plagues. Necromancers sustain their health by stealing from enemies. Although initially weak, they grow stronger and obtain more benefits as more allies fall. Aditionally, Necromancers never truly die, but instead become phantoms and can roam in their afterlife. This class is ideal for players who like both a supportive and offensive role.||You can not be more than one class at any time. You must purchase a class first before purchasing any ability or stats."
     BotChance=7
}
