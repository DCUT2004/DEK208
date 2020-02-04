class DruidTurretSummon extends Summonifact
	config(UT2004RPG);

function bool SpawnIt(TranslocatorBeacon Beacon, Pawn P, EngineerPointsInv epi)
{
	Local Vehicle NewTurret;
	local AutoGunController AGC;
	local Vector SpawnLoc,SpawnLocCeiling;
	local rotator SpawnRotation;

	SpawnLoc = epi.GetSpawnHeight(Beacon.Location);
    if (ClassIsChildOf(SummonItem,class'AutoGun'))
    {
		SpawnLocCeiling = epi.FindCeiling(Beacon.Location);		// see if can go on ceiling instead.
		if (SpawnLocCeiling != vect(0,0,0) && (SpawnLoc == vect(0,0,0) || VSize(SpawnLocCeiling - Beacon.Location) < VSize(SpawnLoc - Beacon.Location)))
		{
		    // closer to ceiling so spawn there
			SpawnLoc = SpawnLocCeiling;
			SpawnLoc.z -= 36;		// just below ceiling
			if (!CheckSpace(SpawnLoc,80,-100))
			{
				Instigator.ReceiveLocalizedMessage(MessageClass, 6000, None, None, Class);
				bActive = false;
				GotoState('');
				return false;
			}

			SpawnRotation.Yaw = rotator(SpawnLoc - Instigator.Location).Yaw;
			SpawnRotation.Roll = 32768;          // upside down
			NewTurret = epi.SummonRotatedTurret(SummonItem, Points, P, SpawnLoc,SpawnRotation);
		}
		else
		{
			if (SpawnLoc == vect(0,0,0))
			{
				Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
				bActive = false;
				GotoState('');
				return false;
			}
			SpawnLoc.z += 36;		// lift just off ground
			if (!CheckSpace(SpawnLoc,80,100))
			{
				Instigator.ReceiveLocalizedMessage(MessageClass, 6000, None, None, Class);
				bActive = false;
				GotoState('');
				return false;
			}

			NewTurret = epi.SummonTurret(SummonItem, Points, P, SpawnLoc);
		}

		if (NewTurret == None)
			return false;

		AGC = spawn(class'AutoGunController');
		if ( AGC != None )
		{
			AGC.SetPlayerSpawner(Instigator.Controller);
			AGC.Possess(NewTurret);
		}
	}
	else
	{
		if (SpawnLoc == vect(0,0,0))
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
			bActive = false;
			GotoState('');
			return false;
		}

		SpawnLoc.z += 30;       // add a bit of height before checking height restriction, but ground clearance is different to head clearance
		// all turrets need about 120 units above the ground clearance. Let's make sure by setting to 200. Will always leave room for a player above
		if (!CheckSpace(SpawnLoc,220,200))
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 6000, None, None, Class);
			bActive = false;
			GotoState('');
			return false;
		}

		if (ClassIsChildOf(SummonItem,class'ASTurret_Minigun'))
			SpawnLoc.z += 20;		// lift just off ground
		else if (SummonItem.IsA('DruidEnergyTurret'))
			SpawnLoc.z += 40;		// lift just off ground
		else if (SummonItem.IsA('DEKLynxTurret'))
			SpawnLoc.z += 40;		// lift just off ground
		else if (ClassIsChildOf(SummonItem,class'DruidIonCannon'))
			SpawnLoc.z += 60;		// lift just off ground
		else if (SummonItem.IsA('DEKOdinTurret'))
			SpawnLoc.z += 60;		// lift just off ground
		else if (SummonItem.IsA('DEKSolarTurret'))
			SpawnLoc.z += 10;		// lift just off ground
		else
			SpawnLoc.z += 50;		// lift just off ground
			

		// just a turret
		NewTurret = epi.SummonTurret(SummonItem, Points, P, SpawnLoc);
		if (NewTurret == None)
			return false;

		NewTurret.AutoTurretControllerClass = None;	// force it to be manual
		
		if (DruidMinigunTurret(NewTurret) != None)
		    DruidMinigunTurret(NewTurret).SetPlayerSpawner(Instigator.Controller);
		else if (DruidLinkTurret(NewTurret) != None)
		    DruidLinkTurret(NewTurret).SetPlayerSpawner(Instigator.Controller);
		else if (DruidBallTurret(NewTurret) != None)
		    DruidBallTurret(NewTurret).SetPlayerSpawner(Instigator.Controller);
		else if (DruidEnergyTurret(NewTurret) != None)
		    DruidEnergyTurret(NewTurret).SetPlayerSpawner(Instigator.Controller);
		else if (DruidIonCannon(NewTurret) != None)
		    DruidIonCannon(NewTurret).SetPlayerSpawner(Instigator.Controller);
		else if (DEKLynxTurret(NewTurret) != None)
		    DEKLynxTurret(NewTurret).SetPlayerSpawner(Instigator.Controller);
		else if (DEKOdinTurret(NewTurret) != None)
		    DEKOdinTurret(NewTurret).SetPlayerSpawner(Instigator.Controller);
		else if (DEKSolarTurret(NewTurret) != None)
		    DEKSolarTurret(NewTurret).SetPlayerSpawner(Instigator.Controller);
		else if (DEKLightningTurret(NewTurret) != None)
		    DEKLightningTurret(NewTurret).SetPlayerSpawner(Instigator.Controller);
		else if (DEKPlasmaTurret(NewTurret) != None)
		    DEKPlasmaTurret(NewTurret).SetPlayerSpawner(Instigator.Controller);
		else if (DEKStingerTurret(NewTurret) != None)
		    DEKStingerTurret(NewTurret).SetPlayerSpawner(Instigator.Controller);
		else if (DEKSkyMineTurret(NewTurret) != None)
		    DEKSkyMineTurret(NewTurret).SetPlayerSpawner(Instigator.Controller);
	}

	SetStartHealth(NewTurret);

	// now allow player to get xp bonus
	ApplyStatsToConstruction(NewTurret,Instigator);

	return true;
}

function BotConsider()
{
	return;		// bots do not summon turrets
}

defaultproperties
{
     IconMaterial=Texture'DEKRPGTexturesMaster207P.Artifacts.SummonTurretIcon'
     ItemName=""
}
