class RPGClass extends RPGDeathAbility
	config(UT2004RPG) 
	abstract;

var config int LowLevel;
var config int MediumLevel;
var config float MaxXPperHit;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	local int x;
	if(CurrentLevel > 1)
		return 0;

	for (x = 0; x < Data.Abilities.length; x++)
	{
		if(ClassIsChildOf(Data.Abilities[x], Class'RPGClass') && Data.Abilities[x] != default.Class)
			return 0;
	}
	return default.StartingCost;
}

static simulated function RPGStatsInv getPlayerStats(Controller c)
{
	Local GameRules G;
	Local RPGRules RPG;
	for(G = C.Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			RPG = RPGRules(G);
			break;
		}
	}

	if(RPG == None)
	{
		Log("WARNING: Unable to find RPGRules in GameRules.");
		return None;
	}
	return RPG.GetStatsInvFor(C);
}

static function bool PrePreventDeath(Pawn Killed, Controller Killer, class<DamageType> DamageType, vector HitLocation, int AbilityLevel)
{
	Local InvulnerabilityInv IInv;
	local PaladinInv PInv;
	Local float XPGained;

	IInv = InvulnerabilityInv(Killed.FindInventoryType(class'InvulnerabilityInv'));
	PInv = PaladinInv(Killed.FindInventoryType(class'PaladinInv'));
	if (IInv != None)
	{
	    if (Killed == IInv.PlayerPawn)
			Killed.Health = max(IInv.PlayerHealth,10);  // keep alive
	    else
			Killed.Health = max(10,Killed.Health);  // keep alive
	    // killed player is in a invulnerability sphere. Give them 10 health and give xp to sphere spawner
		if ( Killed != None && Killed.Controller != None && IInv.InvPlayerController != None && IInv.InvPlayerController.Pawn != None && Killed != Killer.Pawn
			&& Killed.Controller.SameTeamAs(IInv.InvPlayerController) )
		{
		    // saved some damage from an enemy. Let's give xp.
		    if (IInv.InvPlayerController != None && IInv.InvPlayerController.Pawn != None && IInv.Rules != None && IInv.InvPlayerController != Killer && IInv.InvPlayerController != Killed.Controller)
		    {
		        XPGained = fmin(fmax(3.0, Killed.Health*IInv.ExpPerDamage),default.MaxXPperHit); // between 3 and 10 xp for preventing death
		        IInv.Rules.ShareExperience(RPGStatsInv(IInv.InvPlayerController.Pawn.FindInventoryType(class'RPGStatsInv')), XPGained);
		        Log("******* Player:" $ IInv.InvPlayerController.Pawn @ "is getting" @ XPGained @ "xp for preventing death to" @ Killed @ "Damagetype:" $ DamageType);
			}
		}
		return true;
	}
	if (PInv != None && PInv.GuardianController.Pawn != None && PInv.GuardianController.Pawn.Health > 0 && PInv.GuardianController.Adrenaline >= PInv.AdrenalineRequired && PInv.bInvulReady)
	{
	    if (Killed == PInv.PawnOwner)
			Killed.Health = max(PInv.PlayerHealth,10);  // keep alive
	    else
			Killed.Health = max(10,Killed.Health);  // keep alive
	    // killed player is in a invulnerability sphere. Give them 10 health and give xp to sphere spawner
		if ( Killed != None && Killed.Controller != None && PInv.GuardianController != None && PInv.GuardianController.Pawn != None && Killed != Killer.Pawn
			&& Killed.Controller.SameTeamAs(PInv.GuardianController) )
		{
		    // saved some damage from an enemy. Let's give xp.
		    if (PInv.GuardianController != None && PInv.GuardianController.Pawn != None && PInv.Rules != None && PInv.GuardianController != Killer && PInv.GuardianController != Killed.Controller)
		    {
		        XPGained = fmin(fmax(3.0, Killed.Health*PInv.ExpPerDamage),default.MaxXPperHit); // between 3 and 10 xp for preventing death
		        PInv.Rules.ShareExperience(RPGStatsInv(PInv.GuardianController.Pawn.FindInventoryType(class'RPGStatsInv')), XPGained);
		        Log("******* Player:" $ PInv.GuardianController.Pawn @ "is getting" @ XPGained @ "xp for preventing death to" @ Killed @ "Damagetype:" $ DamageType);
			}
		}
		PInv.Counter = 0;
		PInv.GuardianController.Adrenaline -= PInv.AdrenalineRequired;
		if (PInv.GuardianController.Adrenaline < 0)
			PInv.GuardianController.Adrenaline = 0;
		PInv.GuardianController.Pawn.ReceiveLocalizedMessage(class'PaladinActivatedMessage', 0, PInv.PawnOwner.PlayerReplicationInfo);
		if (IInv == None)
		{
			IInv = Killed.spawn(class'InvulnerabilityInv', Killed,,, rot(0,0,0));
			IInv.EstimatedRunTime = PInv.InvulTime;
			IInv.InvPlayerController = PInv.GuardianController;
			IInv.ExpPerDamage = PInv.ExpPerDamage;
			IInv.CoreLocation = Killed.Location;
			IInv.Rules = PInv.Rules;
			IInv.GiveTo(Killed);
		}
		return true;
	}
	
	if(Killed == None)
		return false;

	return false;
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
 			if (ClassIsChildOf(StatsInv.Data.Abilities[y], class'AbilityGhost'))
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
				return class'DruidGhost'.static.GenuinePreventDeath(Killed, Killer, DamageType, HitLocation, 2);
			
		}
		else if(StatsInv.DataObject.Level <= default.MediumLevel)
		{
			if(GhostIndex >= 0)
				return StatsInv.Data.Abilities[GhostIndex].static.PreventDeath(Killed, Killer, DamageType, HitLocation, 1, false);
			else
				return class'DruidGhost'.static.GenuinePreventDeath(Killed, Killer, DamageType, HitLocation, 1);
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
 			if (ClassIsChildOf(StatsInv.Data.Abilities[y], class'AbilityGhost'))
 			{
 				GhostLevel = StatsInv.Data.AbilityLevels[y];
 				GhostIndex = y;
 			}
 		}

		if(StatsInv.DataObject.Level <= default.LowLevel)
		{
			if(GhostIndex >=0)
				return StatsInv.Data.Abilities[GhostIndex].static.PreventSever(Killed, boneName, Damage, DamageType, 3);
			else
				return class'DruidGhost'.static.PreventSever(Killed, boneName, Damage, DamageType, 3);
		}
		else if(StatsInv.DataObject.Level <= default.MediumLevel)
		{
			if(GhostIndex >=0)
				return StatsInv.Data.Abilities[GhostIndex].static.PreventSever(Killed, boneName, Damage, DamageType, Min(3, GhostLevel + 2));
			else
				return class'DruidGhost'.static.PreventSever(Killed, boneName, Damage, DamageType, 2);
		}
 	}
}

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local MissionInv MInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local Mission3Inv M3Inv;
	local MissionMultiplayerInv MMPI;
	local RPGClassInv RPGInv;
	
	//Add main MissionInv.
	MInv = MissionInv(Other.FindInventoryType(class'MissionInv'));
	M1Inv = Mission1Inv(Other.FindInventoryType(class'Mission1Inv'));
	M2Inv = Mission2Inv(Other.FindInventoryType(class'Mission2Inv'));
	M3Inv = Mission3Inv(Other.FindInventoryType(class'Mission3Inv'));
	MMPI = MissionMultiplayerInv(Other.FindInventoryType(class'MissionMultiplayerInv'));
	RPGInv = RPGClassInv(Other.FindInventoryType(class'RPGClassInv'));
	
	if (MInv == None)
	{
		MInv = Other.Spawn(class'MissionInv');
		MInv.GiveTo(Other);
	}
	if (M1Inv == None)
	{
		M1Inv = Other.Spawn(class'Mission1Inv');
		M1Inv.GiveTo(Other);
	}
	if (M2Inv == None)
	{
		M2Inv = Other.Spawn(class'Mission2Inv');
		M2Inv.GiveTo(Other);
	}
	if (M3Inv == None)
	{
		M3Inv = Other.Spawn(class'Mission3Inv');
		M3Inv.GiveTo(Other);
	}
	if (MMPI == None)
	{
		MMPI = Other.Spawn(class'MissionMultiplayerInv');
		MMPI.GiveTo(Other);
	}
	if (RPGInv == None)
	{
		RPGInv = Other.Spawn(class'RPGClassInv');
		RPGInv.GiveTo(Other);
	}
}

static simulated function ModifyVehicle(Vehicle V, int AbilityLevel)
{
	// called when player enters a vehicle
	// UT2004RPG resets the vehicle health back to defaults when you get in. We need to reapply bonus
	local float Healthperc;

	if (V.SuperHealthMax == 199)
		return;					// not spawned by Engineer

	// need to undo the change done by the MutUT2004RPG.DriverEnteredVehicle function
	Healthperc = float(V.Health) / V.HealthMax;	// current health percent
	V.HealthMax = V.SuperHealthMax;
	V.Health =Healthperc * V.HealthMax;		// now applied to new max

}

static function ScoreKill(Controller Killer, Controller Killed, bool bOwnedByKiller, int AbilityLevel)
{
	Local DamageInv DInv;
	local InvulnerabilityInv IInv;
	Local float DamageXPGained, NecroXPGained;
	local DEKFriendlyMonsterController MC;
	local PriestInv PInv;
	local NecroInv NInv;

	if (!bOwnedByKiller)
		return;
		
    if (Killer == None || Killer.Pawn == None || Killed == None || Killed.Pawn == None)
        return; // nothing we can do
		
	MC = DEKFriendlyMonsterController(Killed);
		
	if (Killer != None && !Killer.Pawn.IsA('Monster') && Killer.Pawn.HasUDamage())
	{
		DInv = DamageInv(Killer.Pawn.FindInventoryType(class'DamageInv'));
		if (DInv != None)
		{
		    // player has DamageInv, which means they have their Damage Boosted by another player. So lets give them a bit of xp
		    if (DInv.DamagePlayerController != None && DInv.DamagePlayerController.Pawn != None && DInv.Rules != None && DInv.DamagePlayerController != Killer)
		    {
		        DamageXPGained = DInv.KillXPPerc * float(Killed.Pawn.GetPropertyText("ScoringValue"));
		        DInv.Rules.ShareExperience(RPGStatsInv(DInv.DamagePlayerController.Pawn.FindInventoryType(class'RPGStatsInv')), DamageXPGained);
				
				//Now for Priest niche on Craftsman
				PInv = PriestInv(DInv.DamagePlayerController.Pawn.FindInventoryType(class'PriestInv'));
				if (PInv != None)
				{
					if (Killed.Pawn != None && Killed.Pawn.IsA('Monster'))
					{
						DInv.DamagePlayerController.AwardAdrenaline(float(Killed.Pawn.GetPropertyText("ScoringValue")) * 0.10 * PInv.AbilityLevel);
					}
					if (Killer.bIsPlayer && Killed.bIsPlayer)
					{
						DInv.DamagePlayerController.AwardAdrenaline(Deathmatch(Killer.Level.Game).ADR_Kill * 0.10 * PInv.AbilityLevel);
					}
				}
			}
		}
	}
	if (Killer != None && !Killer.Pawn.IsA('Monster') && Killed.Pawn != None)
	{
		IInv = InvulnerabilityInv(Killer.Pawn.FindInventoryType(class'InvulnerabilityInv'));
		if (IInv != None)
		{
		    if (IInv.InvPlayerController != None && IInv.InvPlayerController.Pawn != None && IInv.InvPlayerController != Killer)
		    {
				PInv = PriestInv(IInv.InvPlayerController.Pawn.FindInventoryType(class'PriestInv'));
				if (PInv != None)
				{
					if (Killed.Pawn.IsA('Monster'))
					{
						IInv.InvPlayerController.AwardAdrenaline(float(Killed.Pawn.GetPropertyText("ScoringValue")) * 0.10 * PInv.AbilityLevel);
					}
					if (Killer.bIsPlayer && Killed.bIsPlayer)
					{
						IInv.InvPlayerController.AwardAdrenaline(Deathmatch(Killer.Level.Game).ADR_Kill * 0.10 * PInv.AbilityLevel);
					}
				}
			}
		}
		NInv = NecroInv(Killer.Pawn.FindInventoryType(class'NecroInv'));
		if (NInv != None && NInv.NecromancerController != None)
		{
			NecroXPGained = NInv.XPMultiplier * float(Killed.Pawn.GetPropertyText("ScoringValue"));
			NInv.Rules.ShareExperience(RPGStatsInv(NInv.NecromancerController.Pawn.FindInventoryType(class'RPGStatsInv')), NecroXPGained);
		}
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	Local float OriginalDamage;
	Local InvulnerabilityInv IInv;
	Local float XPGained;
	Local MissionPortalBall Ball;

	if(Damage > 0 && bOwnedByInstigator)
	{
		if (ClassIsChildOf(Injured.Class, class'MissionPortalBall'))
		{
			Ball = MissionPortalBall(Injured);
			if (Ball != None)
			{
				//Momentum = vect(0,0,0);
				Ball.Velocity.Z = 100;
				Damage = 0;
			}
		}
	}
		
	if(Damage > 0 && !bOwnedByInstigator)
	{
		IInv = InvulnerabilityInv(Injured.FindInventoryType(class'InvulnerabilityInv'));
		if (IInv != None)
		{
		    // injured player is in a invulnerability sphere. Reduce damage and give xp to sphere spawner
		    OriginalDamage = Damage;
			Damage = 0;
			Momentum = vect(0,0,0);
		    // check for not same team before awarding xp
			if ( Injured != None && Injured.Controller != None && IInv.InvPlayerController != None && IInv.InvPlayerController.Pawn != None && Injured.Controller.SameTeamAs(IInv.InvPlayerController) )
			{
			    // saved some damage from an enemy. Let's give xp.
			    if (IInv.InvPlayerController != None && IInv.InvPlayerController.Pawn != None && IInv.Rules != None && IInv.InvPlayerController != Instigator.Controller && IInv.InvPlayerController != Injured.Controller)
			    {
			        XPGained = fmin(IInv.ExpPerDamage * OriginalDamage, default.MaxXPperHit); // max 10 xp per hit
			        IInv.Rules.ShareExperience(RPGStatsInv(IInv.InvPlayerController.Pawn.FindInventoryType(class'RPGStatsInv')), XPGained);
			        Log("******* Player:" $ IInv.InvPlayerController.Pawn @ "is getting" @ XPGained @ "xp for preventing" @ OriginalDamage @ "to" @ Injured @ "Damagetype:" $ DamageType);
				}
			}
			// now let's do a status check on the pawn
			if (Injured == IInv.PlayerPawn)
			{
			    IInv.PlayerHealth = Injured.Health;
			}
			else
			{
			    IInv.PlayerPawn = Injured;
			    IInv.PlayerHealth = Injured.Health;
			}
		}
	}
}

defaultproperties
{
     LowLevel=20
     MediumLevel=40
     MaxXPperHit=10.000000
     StartingCost=1
     MaxLevel=1
}
