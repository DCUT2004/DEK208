class AbilityMissions extends CostRPGAbility
	config(UT2004RPG)
	abstract;
	
var config float NullifyIceDamageChance;
var config float NullifyFireDamageChance;
var config int GenomeMaxDamage;

static function ScoreKill(Controller Killer, Controller Killed, bool bOwnedByKiller, int AbilityLevel)
{
	local MissionInv Inv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local Mission3Inv M3Inv;
	local MissionMultiplayerInv MMPI;
	local Weapon W;
	local Monster M;
	local NecroSorcererResurrectedInv ZombieInv;
	local NecroGhostPossessorMonsterInv PossessorInv;
	local Pawn P;
	
	if (!bOwnedByKiller)
		return;
		
	if ( Killed == P || Killed == None || Killed.Pawn == None || Killer.Pawn == None || Killed.Level == None || Killed.Level.Game == None)
		return;
		
	P = Killer.Pawn;
	
	if (P != None && P.IsA('Vehicle'))
		P = Vehicle(P).Driver;
	
	if (P != None)
	{
		Inv = MissionInv(P.FindInventoryType(class'MissionInv'));
		M1Inv = Mission1Inv(P.FindInventoryType(class'Mission1Inv'));
		M2Inv = Mission2Inv(P.FindInventoryType(class'Mission2Inv'));
		M3Inv = Mission3Inv(P.FindInventoryType(class'Mission3Inv'));
		MMPI = MissionMultiplayerInv(P.FindInventoryType(class'MissionMultiplayerInv'));
		ZombieInv = NecroSorcererResurrectedInv(Killed.Pawn.FindInventoryType(class'NecroSorcererResurrectedInv'));
		PossessorInv = NecroGhostPossessorMonsterInv(Killed.Pawn.FindInventoryType(class'NecroGhostPossessorMonsterInv'));
	}
		
	M = Monster(Killed.Pawn);
	
	if (RPGWeapon(P.Weapon) != None)
		W = RPGWeapon(P.Weapon).ModifiedWeapon;
	else
		W = P.Weapon;
	
	if (Killer != None && P != None && Killed != None && Killed.Pawn != None && !Killed.SameTeamAs(Killer))
	{
		//Kills Not Allowed.
		if (M != None && M.ControllerClass == class'DEKFriendlyMonsterController')
			return;
		if (Killed.Pawn.IsA('HealerNali') || Killed.Pawn.IsA('MissionCow'))
			return;
			
		//Team Missions
		if (MMPI != None && !MMPI.Stopped)
		{
			if (MMPI.MusicalWeaponsActive)
			{
				if (MMPI.AVRiLActive && INAVRiL(W) != None)
					class'MissionMultiplayerInv'.static.UpdateCounts(1);
				else if (MMPI.BioActive && BioRifle(W) != None)
					class'MissionMultiplayerInv'.static.UpdateCounts(1);
				else if (MMPI.ShockActive && ShockRifle(W) != None)
					class'MissionMultiplayerInv'.static.UpdateCounts(1);
				else if (MMPI.LinkActive && (RPGLinkGun(W) != None || EngineerLinkGun(W) != None))
					class'MissionMultiplayerInv'.static.UpdateCounts(1);
				else if (MMPI.MinigunActive && Minigun(W) != None)
					class'MissionMultiplayerInv'.static.UpdateCounts(1);
				else if (MMPI.FlakActive && FlakCannon(W) != None)
					class'MissionMultiplayerInv'.static.UpdateCounts(1);
				else if (MMPI.RocketActive && RocketLauncher(W) != None)
					class'MissionMultiplayerInv'.static.UpdateCounts(1);
				else if (MMPI.LightningActive && SniperRifle(W) != None)
					class'MissionMultiplayerInv'.static.UpdateCounts(1);
			}
		}
			
		//M1
		if (M1Inv != None && !M1Inv.Stopped)
		{
			if (M1Inv.AquamanActive && !Inv.AquamanComplete)
			{
				if (P.PhysicsVolume.bWaterVolume && P.Physics == PHYS_Swimming)
				{
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.BoneCrusherActive && !Inv.BoneCrusherComplete)
			{
				if (ClassIsChildOf(M.Class, class'NecroMortalSkeleton') || ClassIsChildOf(M.Class, class'NecroSkull'))
				{
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.BugHuntActive && !Inv.BugHuntComplete)
			{
				if (!M.IsA('NecroSkull') && (ClassIsChildOf(M.Class, class'SkaarjPupae') || ClassIsChildOf(M.Class, class'Razorfly') || ClassIsChildOf(M.Class, class'Manta')))
				{
						M1Inv.MissionCount++;					
				}
			}
			else if (M1Inv.KrallHuntActive && !Inv.KrallHuntComplete)
			{
				if (ClassIsChildOf(M.Class, class'Krall') || ClassIsChildOf(M.Class, class'DCKrall'))
				{
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.GhostBusterActive && !Inv.GhostBusterComplete)
			{
				if (M.IsA('NecroGhostExp') || M.IsA('NecroGhostIllusion') || M.IsA('NecroGhostMisfortune') || M.IsA('NecroGhostPoltergeist') || M.IsA('NecroGhostPossessor') || M.IsA('NecroGhostPriest') || M.IsA('NecroGhostShaman') || M.IsA('NecroAdrenWraith') || M.IsA('NecroPhantom') || M.IsA('NecroSorcerer') || M.IsA('NecroSoulWraith'))
				{
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.GlacialHuntActive && !Inv.GlacialHuntComplete)
			{
				if (ClassIsChildOf(M.Class, class'IceBrute') || ClassIsChildOf(M.Class,class'IceGasbag') || ClassIsChildOf(M.Class,class'IceGiantGasbag') || ClassIsChildOf(M.Class,class'IceKrall') || ClassIsChildOf(M.Class,class'IceMercenary') || ClassIsChildOf(M.Class,Class'IceQueen') || ClassIsChildOf(M.Class,Class'IceSkaarjFreezing') || ClassIsChildOf(M.Class,Class'IceSkaarjTrooper') || ClassIsChildOf(M.Class,Class'ArcticBioSkaarj') || ClassIsChildOf(M.Class,Class'IceSkaarjSniper') || ClassIsChildOf(M.Class,Class'IceSlith') || ClassIsChildOf(M.Class,Class'IceTitan') || ClassIsChildOf(M.Class,Class'IceSlug') || ClassIsChildOf(M.Class,Class'IceManta') || ClassIsChildOf(M.Class,Class'IceRazorFly') || ClassIsChildOf(M.Class,Class'IceSkaarjPupae') || ClassIsChildOf(M.Class,Class'IceNali') || ClassIsChildOf(M.Class,Class'IceNaliFighter') || ClassIsChildOf(M.Class,Class'IceWarlord') || ClassIsChildOf(M.Class,class'IceTentacle'))
				{
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.NaniteCrashActive && !Inv.NaniteCrashComplete)
			{
				if (M.IsA('TechBehemoth') || M.IsA('TechKrall') || M.IsA('TechPupae') || M.IsA('TechQueen') || M.IsA('TechRazorfly') || M.IsA('TechSkaarj') || M.IsA('TechSlith') || M.IsA('TechSlug') || M.IsA('TechSniper') || M.IsA('TechTitan' ) || M.IsA('TechWarlord') || M.IsA('GiantManta'))
				{
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.RootedStanceActive && !Inv.RootedStanceComplete)
			{
				if (VSize(P.Velocity) ~= 0)
				{
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.SharpShotFlyActive && !Inv.SharpShotFlyComplete)
			{
				if (M.IsA('VampireGnat') && (SniperRifle(W) != None || ClassicSniperRifle(W) != None || DEKRailGun(W) != None || DEKLG(W) != None ))
				{
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.SkaarjHuntActive && !Inv.SkaarjHuntComplete)
			{
				if (ClassIsChildOf(M.Class, class'Skaarj') || ClassIsChildOf(M.Class, class'FireSkaarj') || ClassIsChildOf(M.Class, class'IceSkaarj') || ClassIsChildOf(M.Class, class'SMPSkaarjSniper') || ClassIsChildOf(M.Class, class'SMPSkaarjTrooper'))
				{
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.SpidermanActive && !Inv.SpidermanComplete)
			{
				if (P.Physics == PHYS_Spider)
				{
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.StarHuntActive && !Inv.StarHuntComplete)
			{
				if (M.IsA('CosmicBrute') || M.IsA('CosmicKrall') || M.IsA('CosmicMercenary') || M.IsA('CosmicNali') || M.IsA('CosmicQueen') || M.IsA('CosmicSkaarj') || M.IsA('CosmicTitan') || M.IsA('CosmicWarlord'))
				{
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.SupermanActive && !Inv.SupermanComplete)
			{
				if (P.Physics == PHYS_Flying || P.Physics == PHYS_Falling)
				{
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.VolcanicHuntActive && !Inv.VolcanicHuntComplete)
			{
				if (ClassIsChildOf(M.Class, class'FireBrute') || ClassIsChildOf(M.Class,class'FireGasbag') || ClassIsChildOf(M.Class,class'FireGiantGasbag') || ClassIsChildOf(M.Class,class'FireKrall') || ClassIsChildOf(M.Class,class'FireMercenary') || ClassIsChildOf(M.Class,Class'FireQueen') || ClassIsChildOf(M.Class,Class'FireSkaarjSuperHeat') || ClassIsChildOf(M.Class,Class'FireSkaarjTrooper') || ClassIsChildOf(M.Class,Class'LavaBioSkaarj') || ClassIsChildOf(M.Class,Class'FireSkaarjSniper') || ClassIsChildOf(M.Class,Class'FireSlith') || ClassIsChildOf(M.Class,Class'FireTitan') || ClassIsChildOf(M.Class,Class'FireSlug') || ClassIsChildOf(M.Class,Class'FireManta') || ClassIsChildOf(M.Class,Class'FireRazorFly') || ClassIsChildOf(M.Class,Class'FireSkaarjPupae') || ClassIsChildOf(M.Class,Class'FireNali') || ClassIsChildOf(M.Class,Class'FireNaliFighter') || ClassIsChildOf(M.Class,Class'FireLord') || ClassIsChildOf(M.Class,Class'FireTentacle'))
				{
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.WarlordHuntActive && !Inv.WarlordHuntComplete)
			{
				if (ClassIsChildOf(M.Class, class'Warlord') || ClassIsChildOf(M.Class, class'DCWarlord'))
				{
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.ZombieSlayerActive && !Inv.ZombieSlayerComplete)
			{
				if (ZombieInv != None)
				{
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.EmeraldShatterActive && !Inv.EmeraldShatterComplete)
			{
				if (PossessorInv != None)
				{
					M1Inv.MissionCount++;
				}
				if (Killed.Pawn.IsA('NecroGhostPossessor'))
				{
					M1Inv.MissionCount++;
					M1Inv.MissionCount++;
				}
			}
		}
		//M2
		if (M2Inv != None && !M2Inv.Stopped)
		{
			if (M2Inv.AquamanActive && !Inv.AquamanComplete)
			{
				if (P.PhysicsVolume.bWaterVolume && P.Physics == PHYS_Swimming)
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.BoneCrusherActive && !Inv.BoneCrusherComplete)
			{
				if (ClassIsChildOf(M.Class, class'NecroMortalSkeleton') || ClassIsChildOf(M.Class, class'NecroSkull'))
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.KrallHuntActive && !Inv.KrallHuntComplete)
			{
				if (ClassIsChildOf(M.Class, class'Krall') || ClassIsChildOf(M.Class, class'DCKrall'))
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.BugHuntActive && !Inv.BugHuntComplete)
			{
				if (!M.IsA('NecroSkull') && (ClassIsChildOf(M.Class, class'SkaarjPupae') || ClassIsChildOf(M.Class, class'Razorfly') || ClassIsChildOf(M.Class, class'Manta')))
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.GhostBusterActive && !Inv.GhostBusterComplete)
			{
				if (M.IsA('NecroGhostExp') || M.IsA('NecroGhostIllusion') || M.IsA('NecroGhostMisfortune') || M.IsA('NecroGhostPoltergeist') || M.IsA('NecroGhostPossessor') || M.IsA('NecroGhostPriest') || M.IsA('NecroGhostShaman') || M.IsA('NecroAdrenWraith') || M.IsA('NecroPhantom') || M.IsA('NecroSorcerer') || M.IsA('NecroSoulWraith'))
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.GlacialHuntActive && !Inv.GlacialHuntComplete)
			{
				if (ClassIsChildOf(M.Class, class'IceBrute') || ClassIsChildOf(M.Class,class'IceGasbag') || ClassIsChildOf(M.Class,class'IceGiantGasbag') || ClassIsChildOf(M.Class,class'IceKrall') || ClassIsChildOf(M.Class,class'IceMercenary') || ClassIsChildOf(M.Class,Class'IceQueen') || ClassIsChildOf(M.Class,Class'IceSkaarjFreezing') || ClassIsChildOf(M.Class,Class'IceSkaarjTrooper') || ClassIsChildOf(M.Class,Class'ArcticBioSkaarj') || ClassIsChildOf(M.Class,Class'IceSkaarjSniper') || ClassIsChildOf(M.Class,Class'IceSlith') || ClassIsChildOf(M.Class,Class'IceTitan') || ClassIsChildOf(M.Class,Class'IceSlug') || ClassIsChildOf(M.Class,Class'IceManta') || ClassIsChildOf(M.Class,Class'IceRazorFly') || ClassIsChildOf(M.Class,Class'IceSkaarjPupae') || ClassIsChildOf(M.Class,Class'IceNali') || ClassIsChildOf(M.Class,Class'IceNaliFighter') || ClassIsChildOf(M.Class,Class'IceWarlord') || ClassIsChildOf(M.Class,class'IceTentacle'))
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.NaniteCrashActive && !Inv.NaniteCrashComplete)
			{
				if (M.IsA('TechBehemoth') || M.IsA('TechKrall') || M.IsA('TechPupae') || M.IsA('TechQueen') || M.IsA('TechRazorfly') || M.IsA('TechSkaarj') || M.IsA('TechSlith') || M.IsA('TechSlug') || M.IsA('TechSniper') || M.IsA('TechTitan' ) || M.IsA('TechWarlord') || M.IsA('GiantManta'))
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.RootedStanceActive && !Inv.RootedStanceComplete)
			{
				if (VSize(P.Velocity) ~= 0)
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.SharpShotFlyActive && !Inv.SharpShotFlyComplete)
			{
				if (M.IsA('VampireGnat') && (SniperRifle(W) != None || ClassicSniperRifle(W) != None || DEKRailGun(W) != None || DEKLG(W) != None ))
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.SkaarjHuntActive && !Inv.SkaarjHuntComplete)
			{
				if (ClassIsChildOf(M.Class, class'Skaarj') || ClassIsChildOf(M.Class, class'FireSkaarj') || ClassIsChildOf(M.Class, class'IceSkaarj') || ClassIsChildOf(M.Class, class'SMPSkaarjSniper') || ClassIsChildOf(M.Class, class'SMPSkaarjTrooper'))
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.SpidermanActive && !Inv.SpidermanComplete)
			{
				if (P.Physics == PHYS_Spider)
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.StarHuntActive && !Inv.StarHuntComplete)
			{
				if (M.IsA('CosmicBrute') || M.IsA('CosmicKrall') || M.IsA('CosmicMercenary') || M.IsA('CosmicNali') || M.IsA('CosmicQueen') || M.IsA('CosmicSkaarj') || M.IsA('CosmicTitan') || M.IsA('CosmicWarlord'))
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.SupermanActive && !Inv.SupermanComplete)
			{
				if (P.Physics == PHYS_Flying || P.Physics == PHYS_Falling)
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.VolcanicHuntActive && !Inv.VolcanicHuntComplete)
			{
				if (ClassIsChildOf(M.Class, class'FireBrute') || ClassIsChildOf(M.Class,class'FireGasbag') || ClassIsChildOf(M.Class,class'FireGiantGasbag') || ClassIsChildOf(M.Class,class'FireKrall') || ClassIsChildOf(M.Class,class'FireMercenary') || ClassIsChildOf(M.Class,Class'FireQueen') || ClassIsChildOf(M.Class,Class'FireSkaarjSuperHeat') || ClassIsChildOf(M.Class,Class'FireSkaarjTrooper') || ClassIsChildOf(M.Class,Class'LavaBioSkaarj') || ClassIsChildOf(M.Class,Class'FireSkaarjSniper') || ClassIsChildOf(M.Class,Class'FireSlith') || ClassIsChildOf(M.Class,Class'FireTitan') || ClassIsChildOf(M.Class,Class'FireSlug') || ClassIsChildOf(M.Class,Class'FireManta') || ClassIsChildOf(M.Class,Class'FireRazorFly') || ClassIsChildOf(M.Class,Class'FireSkaarjPupae') || ClassIsChildOf(M.Class,Class'FireNali') || ClassIsChildOf(M.Class,Class'FireNaliFighter') || ClassIsChildOf(M.Class,Class'FireLord') || ClassIsChildOf(M.Class,Class'FireTentacle'))
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.WarlordHuntActive && !Inv.WarlordHuntComplete)
			{
				if (ClassIsChildOf(M.Class, class'Warlord') || ClassIsChildOf(M.Class, class'DCWarlord'))
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.ZombieSlayerActive && !Inv.ZombieSlayerComplete)
			{
				if (ZombieInv != None)
				{
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.EmeraldShatterActive && !Inv.EmeraldShatterComplete)
			{
				if (PossessorInv != None)
				{
					M2Inv.MissionCount++;
				}
				if (Killed.Pawn.IsA('NecroGhostPossessor'))
				{
					M2Inv.MissionCount++;
					M2Inv.MissionCount++;
				}
			}
		}
		//M3
		if (M3Inv != None && !M3Inv.Stopped)
		{
			if (M3Inv.AquamanActive && !Inv.AquamanComplete)
			{
				if (P.PhysicsVolume.bWaterVolume && P.Physics == PHYS_Swimming)
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.BoneCrusherActive && !Inv.BoneCrusherComplete)
			{
				if (ClassIsChildOf(M.Class, class'NecroMortalSkeleton') || ClassIsChildOf(M.Class, class'NecroSkull'))
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.KrallHuntActive && !Inv.KrallHuntComplete)
			{
				if (ClassIsChildOf(M.Class, class'Krall') || ClassIsChildOf(M.Class, class'DCKrall'))
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.BugHuntActive && !Inv.BugHuntComplete)
			{
				if (!M.IsA('NecroSkull') && (ClassIsChildOf(M.Class, class'SkaarjPupae') || ClassIsChildOf(M.Class, class'Razorfly') || ClassIsChildOf(M.Class, class'Manta')))
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.GhostBusterActive && !Inv.GhostBusterComplete)
			{
				if (M.IsA('NecroGhostExp') || M.IsA('NecroGhostIllusion') || M.IsA('NecroGhostMisfortune') || M.IsA('NecroGhostPoltergeist') || M.IsA('NecroGhostPossessor') || M.IsA('NecroGhostPriest') || M.IsA('NecroGhostShaman') || M.IsA('NecroAdrenWraith') || M.IsA('NecroPhantom') || M.IsA('NecroSorcerer') || M.IsA('NecroSoulWraith'))
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.GlacialHuntActive && !Inv.GlacialHuntComplete)
			{
				if (ClassIsChildOf(M.Class, class'IceBrute') || ClassIsChildOf(M.Class,class'IceGasbag') || ClassIsChildOf(M.Class,class'IceGiantGasbag') || ClassIsChildOf(M.Class,class'IceKrall') || ClassIsChildOf(M.Class,class'IceMercenary') || ClassIsChildOf(M.Class,Class'IceQueen') || ClassIsChildOf(M.Class,Class'IceSkaarjFreezing') || ClassIsChildOf(M.Class,Class'IceSkaarjTrooper') || ClassIsChildOf(M.Class,Class'ArcticBioSkaarj') || ClassIsChildOf(M.Class,Class'IceSkaarjSniper') || ClassIsChildOf(M.Class,Class'IceSlith') || ClassIsChildOf(M.Class,Class'IceTitan') || ClassIsChildOf(M.Class,Class'IceSlug') || ClassIsChildOf(M.Class,Class'IceManta') || ClassIsChildOf(M.Class,Class'IceRazorFly') || ClassIsChildOf(M.Class,Class'IceSkaarjPupae') || ClassIsChildOf(M.Class,Class'IceNali') || ClassIsChildOf(M.Class,Class'IceNaliFighter') || ClassIsChildOf(M.Class,Class'IceWarlord') || ClassIsChildOf(M.Class,class'IceTentacle'))
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.NaniteCrashActive && !Inv.NaniteCrashComplete)
			{
				if (M.IsA('TechBehemoth') || M.IsA('TechKrall') || M.IsA('TechPupae') || M.IsA('TechQueen') || M.IsA('TechRazorfly') || M.IsA('TechSkaarj') || M.IsA('TechSlith') || M.IsA('TechSlug') || M.IsA('TechSniper') || M.IsA('TechTitan' ) || M.IsA('TechWarlord') || M.IsA('GiantManta'))
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.RootedStanceActive && !Inv.RootedStanceComplete)
			{
				if (VSize(P.Velocity) ~= 0)
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.SharpShotFlyActive && !Inv.SharpShotFlyComplete)
			{
				if (M.IsA('VampireGnat') && (SniperRifle(W) != None || ClassicSniperRifle(W) != None || DEKRailGun(W) != None || DEKLG(W) != None ))
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.SkaarjHuntActive && !Inv.SkaarjHuntComplete)
			{
				if (ClassIsChildOf(M.Class, class'Skaarj') || ClassIsChildOf(M.Class, class'FireSkaarj') || ClassIsChildOf(M.Class, class'IceSkaarj') || ClassIsChildOf(M.Class, class'SMPSkaarjSniper') || ClassIsChildOf(M.Class, class'SMPSkaarjTrooper'))
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.SpidermanActive && !Inv.SpidermanComplete)
			{
				if (P.Physics == PHYS_Spider)
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.StarHuntActive && !Inv.StarHuntComplete)
			{
				if (M.IsA('CosmicBrute') || M.IsA('CosmicKrall') || M.IsA('CosmicMercenary') || M.IsA('CosmicNali') || M.IsA('CosmicQueen') || M.IsA('CosmicSkaarj') || M.IsA('CosmicTitan') || M.IsA('CosmicWarlord'))
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.SupermanActive && !Inv.SupermanComplete)
			{
				if (P.Physics == PHYS_Flying || P.Physics == PHYS_Falling)
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.VolcanicHuntActive && !Inv.VolcanicHuntComplete)
			{
				if (ClassIsChildOf(M.Class, class'FireBrute') || ClassIsChildOf(M.Class,class'FireGasbag') || ClassIsChildOf(M.Class,class'FireGiantGasbag') || ClassIsChildOf(M.Class,class'FireKrall') || ClassIsChildOf(M.Class,class'FireMercenary') || ClassIsChildOf(M.Class,Class'FireQueen') || ClassIsChildOf(M.Class,Class'FireSkaarjSuperHeat') || ClassIsChildOf(M.Class,Class'FireSkaarjTrooper') || ClassIsChildOf(M.Class,Class'LavaBioSkaarj') || ClassIsChildOf(M.Class,Class'FireSkaarjSniper') || ClassIsChildOf(M.Class,Class'FireSlith') || ClassIsChildOf(M.Class,Class'FireTitan') || ClassIsChildOf(M.Class,Class'FireSlug') || ClassIsChildOf(M.Class,Class'FireManta') || ClassIsChildOf(M.Class,Class'FireRazorFly') || ClassIsChildOf(M.Class,Class'FireSkaarjPupae') || ClassIsChildOf(M.Class,Class'FireNali') || ClassIsChildOf(M.Class,Class'FireNaliFighter') || ClassIsChildOf(M.Class,Class'FireLord') || ClassIsChildOf(M.Class,Class'FireTentacle'))
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.WarlordHuntActive && !Inv.WarlordHuntComplete)
			{
				if (ClassIsChildOf(M.Class, class'Warlord') || ClassIsChildOf(M.Class, class'DCWarlord'))
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.ZombieSlayerActive && !Inv.ZombieSlayerComplete)
			{
				if (ZombieInv != None)
				{
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.EmeraldShatterActive && !Inv.EmeraldShatterComplete)
			{
				if (PossessorInv != None)
				{
					M3Inv.MissionCount++;
				}
				if (Killed.Pawn.IsA('NecroGhostPossessor'))
				{
					M3Inv.MissionCount++;
					M3Inv.MissionCount++;
				}
			}
		}
	}
	else
		return;
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local MissionInv Inv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local Mission3Inv M3Inv;
	local MissionMultiplayerInv MMPI;
	local Pawn P;
	
	P = Instigator;
	if (P != None && P.IsA('Vehicle'))
		P = Vehicle(P).Driver;
	if (P != None)
	{
		Inv = MissionInv(P.FindInventoryType(class'MissionInv'));
		M1Inv = Mission1Inv(P.FindInventoryType(class'Mission1Inv'));
		M2Inv = Mission2Inv(P.FindInventoryType(class'Mission2Inv'));
		M3Inv = Mission3Inv(P.FindInventoryType(class'Mission3Inv'));
		MMPI = MissionMultiplayerInv(P.FindInventoryType(class'MissionMultiplayerInv'));
	}
	
	if (Inv != None && Damage > 0 && bOwnedByInstigator && P != None && Injured != None && Injured != P && Injured.GetTeam() != P.GetTeam() && P.GetTeam() != None)
	{
		if (MMPI != None && !MMPI.Stopped)
		{
			if (MMPI.PowerPartyActive)
				class'MissionMultiplayerInv'.static.UpdateCounts(Damage);
		}
		if (M1Inv != None && !M1Inv.Stopped)
		{
			if (M1Inv.AVRiLAmityActive && !Inv.AVRiLAmityComplete)
			{
				if (DamageType == class'DEKWeapons208.DamTypeDEKAVRiLRocket')
					M1Inv.MissionCount++;
			}
			else if (M1Inv.BioBerserkActive && !Inv.BioBerserkComplete)
			{
				if (DamageType == class'XWeapons.DamTypeBioGlob')
					M1Inv.MissionCount++;
			}
			else if (M1Inv.FlakFrenzyActive && !Inv.FlakFrenzyComplete)
			{
				if (DamageType == class'XWeapons.DamTypeFlakChunk' || DamageType == class'XWeapons.DamTypeFlakShell')
					M1Inv.MissionCount++;
			}
			else if (M1Inv.LinkLunaticActive && !Inv.LinkLunaticComplete)
			{
				if (DamageType == class'XWeapons.DamTypeLinkPlasma' || DamageType == class'XWeapons.DamTypeLinkShaft')
					M1Inv.MissionCount++;
			}
			else if (M1Inv.MightyLightningActive && !Inv.MightyLightningComplete)
			{
				if (DamageType == class'XWeapons.DamTypeSniperShot')
					M1Inv.MissionCount++;
				else if (DamageType == class'XWeapons.DamTypeSniperHeadShot')
				{
					M1Inv.MissionCount++;
					M1Inv.MissionCount++;
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.MinigunMayhemActive && !Inv.MinigunMayhemComplete)
			{
				if (DamageType == class'XWeapons.DamTypeMinigunAlt' || DamageType == class'XWeapons.DamTypeMinigunBullet')
					M1Inv.MissionCount++;
			}
			else if (M1Inv.RocketRageActive && !Inv.RocketRageComplete)
			{
				if (DamageType == class'XWeapons.DamTypeRocket' || DamageType == class'XWeapons.DamTypeRocketHoming')
					M1Inv.MissionCount++;
			}
			else if (M1Inv.ShockSlaughterActive && !Inv.ShockSlaughterComplete)
			{
				if (DamageType == class'XWeapons.DamTypeShockBeam' || DamageType == class'XWeapons.DamTypeShockBall')
					M1Inv.MissionCount++;
				else if (DamageType == class'XWeapons.DamTypeShockCombo')
				{
					M1Inv.MissionCount++;
					M1Inv.MissionCount++;
					M1Inv.MissionCount++;
				}
			}
			else if (M1Inv.UtilityMutilityActive && !Inv.UtilityMutilityComplete)
			{
				if (DamageType == class'DEKWeapons208.DamTypeProAssBullet' || DamageType == class'DEKWeapons208.DamTypeProAssGrenadeChunk')
					M1Inv.MissionCount++;
				else if (DamageType == class'DEKWeapons208.DamTypeProAssGrenade')
				{
					M1Inv.MissionCount++;
					M1Inv.MissionCount++;
					M1Inv.MissionCount++;
				}
			}
		}
		if (M2Inv != None && !M2Inv.Stopped)
		{
			if (M2Inv.AVRiLAmityActive && !Inv.AVRiLAmityComplete)
			{
				if (DamageType == class'DEKWeapons208.DamTypeDEKAVRiLRocket')
					M2Inv.MissionCount++;
			}
			else if (M2Inv.BioBerserkActive && !Inv.BioBerserkComplete)
			{
				if (DamageType == class'XWeapons.DamTypeBioGlob')
					M2Inv.MissionCount++;
			}
			else if (M2Inv.FlakFrenzyActive && !Inv.FlakFrenzyComplete)
			{
				if (DamageType == class'XWeapons.DamTypeFlakChunk' || DamageType == class'XWeapons.DamTypeFlakShell')
					M2Inv.MissionCount++;
			}
			else if (M2Inv.LinkLunaticActive && !Inv.LinkLunaticComplete)
			{
				if (DamageType == class'XWeapons.DamTypeLinkPlasma' || DamageType == class'XWeapons.DamTypeLinkShaft')
					M2Inv.MissionCount++;
			}
			else if (M2Inv.MightyLightningActive && !Inv.MightyLightningComplete)
			{
				if (DamageType == class'XWeapons.DamTypeSniperShot')
					M2Inv.MissionCount++;
				else if (DamageType == class'XWeapons.DamTypeSniperHeadShot')
				{
					M2Inv.MissionCount++;
					M2Inv.MissionCount++;
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.MinigunMayhemActive && !Inv.MinigunMayhemComplete)
			{
				if (DamageType == class'XWeapons.DamTypeMinigunAlt' || DamageType == class'XWeapons.DamTypeMinigunBullet')
					M2Inv.MissionCount++;
			}
			else if (M2Inv.RocketRageActive && !Inv.RocketRageComplete)
			{
				if (DamageType == class'XWeapons.DamTypeRocket' || DamageType == class'XWeapons.DamTypeRocketHoming')
					M2Inv.MissionCount++;
			}
			else if (M2Inv.ShockSlaughterActive && !Inv.ShockSlaughterComplete)
			{
				if (DamageType == class'XWeapons.DamTypeShockBeam' || DamageType == class'XWeapons.DamTypeShockBall')
					M2Inv.MissionCount++;
				else if (DamageType == class'XWeapons.DamTypeShockCombo')
				{
					M2Inv.MissionCount++;
					M2Inv.MissionCount++;
					M2Inv.MissionCount++;
				}
			}
			else if (M2Inv.UtilityMutilityActive && !Inv.UtilityMutilityComplete)
			{
				if (DamageType == class'DEKWeapons208.DamTypeProAssBullet' || DamageType == class'DEKWeapons208.DamTypeProAssGrenadeChunk')
					M2Inv.MissionCount++;
				else if (DamageType == class'DEKWeapons208.DamTypeProAssGrenade')
				{
					M2Inv.MissionCount++;
					M2Inv.MissionCount++;
					M2Inv.MissionCount++;
				}
			}
		}
		if (M3Inv != None && !M3Inv.Stopped)
		{
			if (M3Inv.AVRiLAmityActive && !Inv.AVRiLAmityComplete)
			{
				if (DamageType == class'DEKWeapons208.DamTypeDEKAVRiLRocket')
					M3Inv.MissionCount++;
			}
			else if (M3Inv.BioBerserkActive && !Inv.BioBerserkComplete)
			{
				if (DamageType == class'XWeapons.DamTypeBioGlob')
					M3Inv.MissionCount++;
			}
			else if (M3Inv.FlakFrenzyActive && !Inv.FlakFrenzyComplete)
			{
				if (DamageType == class'XWeapons.DamTypeFlakChunk' || DamageType == class'XWeapons.DamTypeFlakShell')
					M3Inv.MissionCount++;
			}
			else if (M3Inv.LinkLunaticActive && !Inv.LinkLunaticComplete)
			{
				if (DamageType == class'XWeapons.DamTypeLinkPlasma' || DamageType == class'XWeapons.DamTypeLinkShaft')
					M3Inv.MissionCount++;
			}
			else if (M3Inv.MightyLightningActive && !Inv.MightyLightningComplete)
			{
				if (DamageType == class'XWeapons.DamTypeSniperShot')
					M3Inv.MissionCount++;
				else if (DamageType == class'XWeapons.DamTypeSniperHeadShot')
				{
					M3Inv.MissionCount++;
					M3Inv.MissionCount++;
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.MinigunMayhemActive && !Inv.MinigunMayhemComplete)
			{
				if (DamageType == class'XWeapons.DamTypeMinigunAlt' || DamageType == class'XWeapons.DamTypeMinigunBullet')
					M3Inv.MissionCount++;
			}
			else if (M3Inv.RocketRageActive && !Inv.RocketRageComplete)
			{
				if (DamageType == class'XWeapons.DamTypeRocket' || DamageType == class'XWeapons.DamTypeRocketHoming')
					M3Inv.MissionCount++;
			}
			else if (M3Inv.ShockSlaughterActive && !Inv.ShockSlaughterComplete)
			{
				if (DamageType == class'XWeapons.DamTypeShockBeam' || DamageType == class'XWeapons.DamTypeShockBall')
					M3Inv.MissionCount++;
				else if (DamageType == class'XWeapons.DamTypeShockCombo')
				{
					M3Inv.MissionCount++;
					M3Inv.MissionCount++;
					M3Inv.MissionCount++;
				}
			}
			else if (M3Inv.UtilityMutilityActive && !Inv.UtilityMutilityComplete)
			{
				if (DamageType == class'DEKWeapons208.DamTypeProAssBullet' || DamageType == class'DEKWeapons208.DamTypeProAssGrenadeChunk')
					M3Inv.MissionCount++;
				else if (DamageType == class'DEKWeapons208.DamTypeProAssGrenade')
				{
					M3Inv.MissionCount++;
					M3Inv.MissionCount++;
					M3Inv.MissionCount++;
				}
			}
		}
	}
	if (Inv != None && Damage > 0 && !bOwnedByInstigator && P != None && Injured != None)
	{
		if (Inv.GlacialHuntComplete && Rand(99) <= default.NullifyIceDamageChance)
		{
			if (DamageType == class'DamTypeIceKrall' ||
			DamageType == class'DamTypeArcticBioSkaarjGlob' ||
			DamageType == class'DamTypeIceBrute' ||
			DamageType == class'DamTypeIceGasbag' ||
			DamageType == class'DamTypeIceGiantGasbag' ||
			DamageType == class'DamTypeIceMercenary' ||
			DamageType == class'DamTypeIceQueen' ||
			DamageType == class'DamTypeIceSkaarjFreezing' ||
			DamageType == class'DamTypeIceSlith' ||
			DamageType == class'DamTypeIceSlug' ||
			DamageType == class'DamTypeIceTitan' ||
			DamageType == Class'DamTypeIceTentacle' ||
			DamageType == class'DamTypeIceWarlord')
				Damage = 1;
		}
		if (Inv.VolcanicHuntComplete && Rand(99) <= default.NullifyFireDamageChance)
		{
			if (DamageType == class'DamTypeFireTitan' ||
			DamageType == class'DamTypeSuperHeat'||
			DamageType == class'DamTypeLavaBioSkaarjGlob' ||
			DamageType == class'DamTypeFireBrute' ||
			DamageType == class'DamTypeFireGasbag' ||
			DamageType == class'DamTypeFireGiantGasbag' ||
			DamageType == class'DamTypeFireKrall' ||
			DamageType == class'DamTypeFireLord' ||
			DamageType == class'DamTypeFireMercenary' ||
			DamageType == class'DamTypeFireQueen' ||
			DamageType == class'DamTypeFireSkaarjSuperHeat' ||
			DamageType == class'DamTypeFireSlith' ||
			DamageType == class'DamTypeFireSlug' ||
			DamageType == class'DamTypeFireTentacle' ||
			DamageType == class'DamTypeFireTitanSuperHeat')
				Damage = 1;
		}
	}
}

defaultproperties
{
     AbilityName="Missions"
     StartingCost=1
     Description="This ability tracks the kills and damage you make for mission purposes. Activating certain missions without this ability will not track data.||You can forfeit a mission any time by keybinding these commands:|'exitmissionone' to forfeit mission one;|'exitmissiontwo' to forfeit mission two;|'exitmissionthree' to forfeit mission three.|See the F12 menu for more info on keybinding instructions as well as a list of available missions and their descriptions.||Cost: 1."
     MaxLevel=1
	 NullifyIceDamageChance=5.00
	 NullifyFireDamageChance=5.00
	 GenomeMaxDamage=30
}
