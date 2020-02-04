class AbilityNecroLingeringSpirit extends RPGDeathAbility
	abstract;

var config float LevMultiplier;

static function PotentialDeathPending(Pawn Killed, Controller Killer, class<DamageType> DamageType, vector HitLocation, int AbilityLevel)
{
	local LingeringSpirit Spirit;
	local PhantomGhostInv PInv;
	
	if(Killed == None || Killed.IsA('Monster'))
	{
		return;
	}
	else
	{
		PInv = PhantomGhostInv(Killed.FindInventoryType(class'PhantomGhostInv'));
		if (PInv != None && !PInv.stopped)
			return;
		Spirit = Killed.Controller.Spawn(class'LingeringSpirit', Killed.Controller,,Killed.Location, Killed.Rotation);
		if (Spirit != None)
		{
			Spirit.Necromancer = Killed.Controller;
			Spirit.StatsInv = RPGStatsInv(Killed.FindInventoryType(class'RPGStatsInv'));
			Spirit.DrainMin *= (1 + (AbilityLevel*default.LevMultiplier));
			Spirit.DrainMax *= (1 + (AbilityLevel*default.LevMultiplier));
			Spirit.SpiritRadius *= (1 + (AbilityLevel*default.LevMultiplier));
		}
	}
	return;
}

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local LingeringSpirit Spirit;
	
	if (Other.IsA('Monster'))
		return;
	
	if (Invasion(Other.Level.Game) != None)
	{
		foreach Other.DynamicActors(class'LingeringSpirit', Spirit)
		{
			if (Spirit.Necromancer == Other.Controller);
				Spirit.Destroy();
		}
	}
}

defaultproperties
{
	 LevMultiplier=0.10000
     AbilityName="Lingering Spirit"
     Description="Leave behind a malevolent spirit when you die. Your spirit drains the health of nearby targets until you respawn, or for 30 seconds in non-invasion gametypes. Each level of this ability increases the range and damage of your spirit by 10%.||This ability is activated when you take damage that would kill you. If you have the Phantom ability, this ability is activated after you have used your first phantom.||Cost(per level): 5,7,9..."
     StartingCost=5
     CostAddPerLevel=2
     MaxLevel=10
}
