class DruidSentinelSummon extends Summonifact
	config(UT2004RPG);

function bool SpawnIt(TranslocatorBeacon Beacon, Pawn P, EngineerPointsInv epi)
{
	Local ASTurret NewSentinel;
	local DruidSentinelController DSC;
	local DEKMercuryController DMC;	
	local DruidBaseSentinelController DBSC;
	local DruidLightningSentinelController DLC;
	local DruidDefenseSentinelController DDC;
	local DruidDefenseSentinelControllerCrimbo DDCC;
	local DEKDamageSentinelController DASC;
	local DEKExplosivesSentinelController DESC;
	local DruidLinkSentinelController DLSC;
	local DEKBeamSentinelController DEKBSC;
	local DEKAutoMachinegunController DEKAMGC;
	local DEKSniperSentinelController DSSC;
	local DEKHellfireSentinelController DHSC;
	local DEKRocketSentinelController DRSC;
	local DEKMachineGunSentinelController DMGSC;
	local AutoGunController AGC;
	local DEKAutoSniperController ASC;
	local DEKAutoMercuryController AMC;
	local Vector SpawnLoc,SpawnLocCeiling;
	local bool bGotSpace;
	local class<Pawn> RealSummonItem;
	local rotator SpawnRotation;
	local bool bOnCeiling;

	if (ClassIsChildOf(SummonItem,class'DruidEnergyWall'))
		return SpawnEnergyWall(Beacon, P, epi);

	RealSummonItem = SummonItem;
	SpawnLoc = epi.GetSpawnHeight(Beacon.Location);	// look at the floor
	bOnCeiling = false;
    if (RealSummonItem == class'AutoGun')
    {
		SpawnLocCeiling = epi.FindCeiling(Beacon.Location);		// see if can go on ceiling instead.
		if (SpawnLocCeiling != vect(0,0,0) && (SpawnLoc == vect(0,0,0) || VSize(SpawnLocCeiling - Beacon.Location) < VSize(SpawnLoc - Beacon.Location)))
		{
		    // closer to ceiling so spawn there
			bOnCeiling = true;
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
			NewSentinel = epi.SummonRotatedSentinel(SummonItem, Points, P, SpawnLoc,SpawnRotation);
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

			NewSentinel = epi.SummonBaseSentinel(SummonItem, Points, P, SpawnLoc);
		}

		if (NewSentinel == None)
			return false;

		AGC = spawn(class'AutoGunController');
		if ( AGC != None )
		{
			AGC.SetPlayerSpawner(Instigator.Controller);
			AGC.Possess(NewSentinel);
		}

		SetStartHealth(NewSentinel);

		// now allow player to get xp bonus
		ApplyStatsToConstruction(NewSentinel,Instigator);

		return true;
	}
	
    if (RealSummonItem == class'DEKMachineGunSentinel')
    {
		SpawnLocCeiling = epi.FindCeiling(Beacon.Location);		// see if can go on ceiling instead.
		if (SpawnLocCeiling != vect(0,0,0) && (SpawnLoc == vect(0,0,0) || VSize(SpawnLocCeiling - Beacon.Location) < VSize(SpawnLoc - Beacon.Location)))
		{
		    // closer to ceiling so spawn there
			bOnCeiling = true;
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
			NewSentinel = epi.SummonRotatedSentinel(SummonItem, Points, P, SpawnLoc,SpawnRotation);
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

			NewSentinel = epi.SummonBaseSentinel(SummonItem, Points, P, SpawnLoc);
		}

		if (NewSentinel == None)
			return false;

		DMGSC = spawn(class'DEKMachineGunSentinelController');
		if ( DMGSC != None )
		{
			DMGSC.SetPlayerSpawner(Instigator.Controller);
			DMGSC.Possess(NewSentinel);
		}

		SetStartHealth(NewSentinel);

		// now allow player to get xp bonus
		ApplyStatsToConstruction(NewSentinel,Instigator);

		return true;
	}
	
    if (RealSummonItem == class'DEKSniperSentinel')
    {
		SpawnLocCeiling = epi.FindCeiling(Beacon.Location);		// see if can go on ceiling instead.
		if (SpawnLocCeiling != vect(0,0,0) && (SpawnLoc == vect(0,0,0) || VSize(SpawnLocCeiling - Beacon.Location) < VSize(SpawnLoc - Beacon.Location)))
		{
		    // closer to ceiling so spawn there
			bOnCeiling = true;
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
			NewSentinel = epi.SummonRotatedSentinel(SummonItem, Points, P, SpawnLoc,SpawnRotation);
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

			NewSentinel = epi.SummonBaseSentinel(SummonItem, Points, P, SpawnLoc);
		}

		if (NewSentinel == None)
			return false;

		DSSC = spawn(class'DEKSniperSentinelController');
		if ( DSSC != None )
		{
			DSSC.SetPlayerSpawner(Instigator.Controller);
			DSSC.Possess(NewSentinel);
		}

		SetStartHealth(NewSentinel);

		// now allow player to get xp bonus
		ApplyStatsToConstruction(NewSentinel,Instigator);

		return true;
	}

    if (RealSummonItem == class'DEKAutoMachinegun')
    {
		SpawnLocCeiling = epi.FindCeiling(Beacon.Location);		// see if can go on ceiling instead.
		if (SpawnLocCeiling != vect(0,0,0) && (SpawnLoc == vect(0,0,0) || VSize(SpawnLocCeiling - Beacon.Location) < VSize(SpawnLoc - Beacon.Location)))
		{
		    // closer to ceiling so spawn there
			bOnCeiling = true;
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
			NewSentinel = epi.SummonRotatedSentinel(SummonItem, Points, P, SpawnLoc,SpawnRotation);
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

			NewSentinel = epi.SummonBaseSentinel(SummonItem, Points, P, SpawnLoc);
		}

		if (NewSentinel == None)
			return false;

		DEKAMGC = spawn(class'DEKAutoMachinegunController');
		if ( DEKAMGC != None )
		{
			DEKAMGC.SetPlayerSpawner(Instigator.Controller);
			DEKAMGC.Possess(NewSentinel);
		}

		SetStartHealth(NewSentinel);

		// now allow player to get xp bonus
		ApplyStatsToConstruction(NewSentinel,Instigator);

		return true;
	}
	
    if (RealSummonItem == class'DEKAutoSniper')
    {
		SpawnLocCeiling = epi.FindCeiling(Beacon.Location);		// see if can go on ceiling instead.
		if (SpawnLocCeiling != vect(0,0,0) && (SpawnLoc == vect(0,0,0) || VSize(SpawnLocCeiling - Beacon.Location) < VSize(SpawnLoc - Beacon.Location)))
		{
		    // closer to ceiling so spawn there
			bOnCeiling = true;
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
			NewSentinel = epi.SummonRotatedSentinel(SummonItem, Points, P, SpawnLoc,SpawnRotation);
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

			NewSentinel = epi.SummonBaseSentinel(SummonItem, Points, P, SpawnLoc);
		}

		if (NewSentinel == None)
			return false;

		ASC = spawn(class'DEKAutoSniperController');
		if ( ASC != None )
		{
			ASC.SetPlayerSpawner(Instigator.Controller);
			ASC.Possess(NewSentinel);
		}

		SetStartHealth(NewSentinel);

		// now allow player to get xp bonus
		ApplyStatsToConstruction(NewSentinel,Instigator);

		return true;
	}
	
    if (RealSummonItem == class'DEKAutoMercury')
    {
		SpawnLocCeiling = epi.FindCeiling(Beacon.Location);		// see if can go on ceiling instead.
		if (SpawnLocCeiling != vect(0,0,0) && (SpawnLoc == vect(0,0,0) || VSize(SpawnLocCeiling - Beacon.Location) < VSize(SpawnLoc - Beacon.Location)))
		{
		    // closer to ceiling so spawn there
			bOnCeiling = true;
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
			NewSentinel = epi.SummonRotatedSentinel(SummonItem, Points, P, SpawnLoc,SpawnRotation);
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

			NewSentinel = epi.SummonBaseSentinel(SummonItem, Points, P, SpawnLoc);
		}

		if (NewSentinel == None)
			return false;

		AMC = spawn(class'DEKAutoMercuryController');
		if ( AMC != None )
		{
			AMC.SetPlayerSpawner(Instigator.Controller);
			AMC.Possess(NewSentinel);
		}

		SetStartHealth(NewSentinel);

		// now allow player to get xp bonus
		ApplyStatsToConstruction(NewSentinel,Instigator);

		return true;
	}

	bGotSpace = CheckSpace(SpawnLoc,150,180);
	if (ClassIsChildOf(SummonItem,class'DruidSentinel') || ClassIsChildOf(SummonItem,class'DEKMercurySentinel') || ClassIsChildOf(SummonItem,class'DruidDefenseSentinel') || ClassIsChildOf(SummonItem,class'DruidLightningSentinel') || ClassIsChildOf(SummonItem,class'DruidLinkSentinel') || ClassIsChildOf(SummonItem,class'DEKBeamSentinel') || ClassIsChildOf(SummonItem,class'DEKAutoMachinegun') || ClassIsChildOf(SummonItem,class'DruidAddLinkSentinel') || ClassIsChildOf(SummonItem,class'DEKDamageSentinel') || ClassIsChildOf(SummonItem,class'DEKExplosivesSentinel') || ClassIsChildOf(SummonItem,class'DruidDefenseSentinelCrimbo') || ClassIsChildOf(SummonItem,class'DEKRocketSentinel') || ClassIsChildOf(SummonItem,class'DEKMachineGunSentinel') || ClassIsChildOf(SummonItem,class'DEKSniperSentinel') || ClassIsChildOf(SummonItem,class'DEKHellfireSentinel'))
	{
		// need to check if ceiling variant is required
		SpawnLocCeiling = epi.FindCeiling(Beacon.Location);	// its a ceiling sentinel - special case.
		if (SpawnLocCeiling != vect(0,0,0) 
			&& (SpawnLoc == vect(0,0,0) || VSize(SpawnLocCeiling - Beacon.Location) < VSize(SpawnLoc - Beacon.Location)))
		{
			// its the ceiling one we want
			bOnCeiling = true;
			if (ClassIsChildOf(SummonItem,class'DruidSentinel'))
				RealSummonItem = class'DruidCeilingSentinel';
			else if (ClassIsChildOf(SummonItem,class'DEKMercurySentinel')) 
				RealSummonItem = class'DEKCeilingMercurySentinel';	
			else if (ClassIsChildOf(SummonItem,class'DruidDefenseSentinel'))
				RealSummonItem = class'DruidCeilingDefenseSentinel';
			else if (ClassIsChildOf(SummonItem,class'DEKDamageSentinel'))
				RealSummonItem = class'DEKCeilingDamageSentinel';
			else if (ClassIsChildOf(SummonItem,class'DEKExplosivesSentinel'))
				RealSummonItem = class'DEKCeilingExplosivesSentinel';
			else if (ClassIsChildOf(SummonItem,class'DruidLightningSentinel'))
				RealSummonItem = class'DruidCeilingLightningSentinel';
			else if (ClassIsChildOf(SummonItem,class'DEKBeamSentinel'))
				RealSummonItem = class'DEKCeilingBeamSentinel';	
			else if (ClassIsChildOf(SummonItem,class'DruidDefenseSentinelCrimbo'))
				RealSummonItem = class'DruidCeilingDefenseSentinelCrimbo';
			else if (ClassIsChildOf(SummonItem,class'DEKRocketSentinel'))
				RealSummonItem = class'DEKCeilingRocketSentinel';
			else if (ClassIsChildOf(SummonItem,class'DEKMachineGunSentinel'))
				RealSummonItem = class'DEKCeilingMachineGunSentinel';
			else if (ClassIsChildOf(SummonItem,class'DEKSniperSentinel'))
				RealSummonItem = class'DEKCeilingSniperSentinel';
			else if (ClassIsChildOf(SummonItem,class'DEKHellfireSentinel'))
				RealSummonItem = class'DEKCeilingHellfireSentinel';
			SpawnLoc = SpawnLocCeiling;
			bGotSpace = CheckSpace(SpawnLoc,120,-160);
		}
	}
	if (SpawnLoc == vect(0,0,0))
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
		bActive = false;
		GotoState('');
		return false;
	}
	if (!bGotSpace)
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 6000, None, None, Class);
		bActive = false;
		GotoState('');
		return false;
	}

	if (RealSummonItem == class'DruidSentinel')
	{
		SpawnLoc.z += 78;		// lift just off ground
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DSC = spawn(class'DruidSentinelController');
			if ( DSC != None )
			{
				DSC.SetPlayerSpawner(Instigator.Controller);
				DSC.Possess(NewSentinel);
				DSC.DamageAdjust = epi.SentinelDamageAdjust;

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DruidCeilingSentinel')
	{
		SpawnLoc.z -= 80;		// leave on ceiling
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DSC = spawn(class'DruidSentinelController');
			if ( DSC != None )
			{
				DSC.SetPlayerSpawner(Instigator.Controller);
				DSC.Possess(NewSentinel);
				DSC.DamageAdjust = epi.SentinelDamageAdjust;

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DEKMercurySentinel')
	{
		SpawnLoc.z += 78;		// lift just off ground
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DMC = spawn(class'DEKMercuryController');
			if ( DMC != None )
			{
				DMC.SetPlayerSpawner(Instigator.Controller);
				DMC.Possess(NewSentinel);
				DMC.DamageAdjust = epi.SentinelDamageAdjust;

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
    else if (RealSummonItem == class'DEKCeilingMercurySentinel')
	{
		SpawnLoc.z -= 80;		// leave on ceiling
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DMC = spawn(class'DEKMercuryController');
			if ( DMC != None )
			{
				DMC.SetPlayerSpawner(Instigator.Controller);
				DMC.Possess(NewSentinel);
				DMC.DamageAdjust = epi.SentinelDamageAdjust;

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DEKHellfireSentinel')
	{
		SpawnLoc.z += 78;		// lift just off ground
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DHSC = spawn(class'DEKHellfireSentinelController');
			if ( DHSC != None )
			{
				DHSC.SetPlayerSpawner(Instigator.Controller);
				DHSC.Possess(NewSentinel);
				DHSC.DamageAdjust = epi.SentinelDamageAdjust;

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
    else if (RealSummonItem == class'DEKCeilingHellfireSentinel')
	{
		SpawnLoc.z -= 80;		// leave on ceiling
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DHSC = spawn(class'DEKHellfireSentinelController');
			if ( DHSC != None )
			{
				DHSC.SetPlayerSpawner(Instigator.Controller);
				DHSC.Possess(NewSentinel);
				DHSC.DamageAdjust = epi.SentinelDamageAdjust;

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DEKSniperSentinel')
	{
		SpawnLoc.z += 28;		// lift just off ground
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DSSC = spawn(class'DEKSniperSentinelController');
			if ( DSSC != None )
			{
				DSSC.SetPlayerSpawner(Instigator.Controller);
				DSSC.Possess(NewSentinel);
				DSSC.DamageAdjust = epi.SentinelDamageAdjust;

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
    else if (RealSummonItem == class'DEKCeilingSniperSentinel')
	{
		SpawnLoc.z -= 80;		// leave on ceiling
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DSSC = spawn(class'DEKSniperSentinelController');
			if ( DSSC != None )
			{
				DSSC.SetPlayerSpawner(Instigator.Controller);
				DSSC.Possess(NewSentinel);
				DSSC.DamageAdjust = epi.SentinelDamageAdjust;

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DEKRocketSentinel')
	{
		SpawnLoc.z += 78;		// lift just off ground
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DRSC = spawn(class'DEKRocketSentinelController');
			if ( DRSC != None )
			{
				DRSC.SetPlayerSpawner(Instigator.Controller);
				DRSC.Possess(NewSentinel);
				DRSC.DamageAdjust = epi.SentinelDamageAdjust;

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DEKCeilingRocketSentinel')
	{
		SpawnLoc.z -= 80;		// leave on ceiling
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DRSC = spawn(class'DEKRocketSentinelController');
			if ( DRSC != None )
			{
				DRSC.SetPlayerSpawner(Instigator.Controller);
				DRSC.Possess(NewSentinel);
				DRSC.DamageAdjust = epi.SentinelDamageAdjust;

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DEKBeamSentinel')
	{
		SpawnLoc.z += 78;		// lift just off ground
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DEKBSC = spawn(class'DEKBeamSentinelController');
			if ( DEKBSC != None )
			{
				DEKBSC.DamageAdjust = epi.SentinelDamageAdjust;
				DEKBSC.SetPlayerSpawner(Instigator.Controller);
				DEKBSC.Possess(NewSentinel);

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DEKCeilingBeamSentinel')
	{
		SpawnLoc.z -= 80;		// leave on ceiling
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DEKBSC = spawn(class'DEKBeamSentinelController');
			if ( DEKBSC != None )
			{
				DEKBSC.SetPlayerSpawner(Instigator.Controller);
				DEKBSC.Possess(NewSentinel);
				DEKBSC.DamageAdjust = epi.SentinelDamageAdjust;

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DruidLightningSentinel')
	{	// its a lightning sentinel
		SpawnLoc.z += 30;		// lift just off ground
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DLC = spawn(class'DruidLightningSentinelController');
			if ( DLC != None )
			{
				DLC.SetPlayerSpawner(Instigator.Controller);
				DLC.Possess(NewSentinel);
				DLC.DamageAdjust = epi.SentinelDamageAdjust;

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DruidCeilingLightningSentinel')
	{	// its a ceiling lightning sentinel
		SpawnLoc.z -= 80;		// leave on ceiling
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DLC = spawn(class'DruidLightningSentinelController');
			if ( DLC != None )
			{
				DLC.SetPlayerSpawner(Instigator.Controller);
				DLC.Possess(NewSentinel);
				DLC.DamageAdjust = epi.SentinelDamageAdjust;

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DruidCeilingDefenseSentinel')
	{	// its a ceiling defense sentinel
		SpawnLoc.z -= 80;		// leave on ceiling
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DDC = spawn(class'DruidDefenseSentinelController');
			if ( DDC != None )
			{
				DDC.DamageAdjust = epi.SentinelDamageAdjust;
				DDC.SetPlayerSpawner(Instigator.Controller);
				DDC.Possess(NewSentinel);

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DruidDefenseSentinel')
	{	// its a defense sentinel
		SpawnLoc.z += 30;		// lift just off ground
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DDC = spawn(class'DruidDefenseSentinelController');
			if ( DDC != None )
			{
				DDC.DamageAdjust = epi.SentinelDamageAdjust;
				DDC.SetPlayerSpawner(Instigator.Controller);
				DDC.Possess(NewSentinel);

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DEKCeilingDamageSentinel')
	{
		SpawnLoc.z -= 80;		// leave on ceiling
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DASC = spawn(class'DEKDamageSentinelController');
			if ( DASC != None )
			{
				DASC.DamageAdjust = epi.SentinelDamageAdjust;
				DASC.SetPlayerSpawner(Instigator.Controller);
				DASC.Possess(NewSentinel);

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class 'DEKDamageSentinel')
	{
		SpawnLoc.z += 30;		// lift just off ground
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DASC = spawn(class'DEKDamageSentinelController');
			if ( DASC != None )
			{
				DASC.DamageAdjust = epi.SentinelDamageAdjust;
				DASC.SetPlayerSpawner(Instigator.Controller);
				DASC.Possess(NewSentinel);

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DEKCeilingExplosivesSentinel')
	{
		SpawnLoc.z -= 80;		// leave on ceiling
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DESC = spawn(class'DEKExplosivesSentinelController');
			if ( DESC != None )
			{
				DESC.DamageAdjust = epi.SentinelDamageAdjust;
				DESC.SetPlayerSpawner(Instigator.Controller);
				DESC.Possess(NewSentinel);

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DEKExplosivesSentinel')
	{	// its a defense sentinel
		SpawnLoc.z += 30;		// lift just off ground
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DESC = spawn(class'DEKExplosivesSentinelController');
			if ( DESC != None )
			{
				DESC.DamageAdjust = epi.SentinelDamageAdjust;
				DESC.SetPlayerSpawner(Instigator.Controller);
				DESC.Possess(NewSentinel);

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DruidDefenseSentinelCrimbo')
	{	// its a defense sentinel
		SpawnLoc.z += 30;		// lift just off ground
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DDCC = spawn(class'DruidDefenseSentinelControllerCrimbo');
			if ( DDCC != None )
			{
				DDCC.DamageAdjust = epi.SentinelDamageAdjust;
				DDCC.SetPlayerSpawner(Instigator.Controller);
				DDCC.Possess(NewSentinel);

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DruidCeilingDefenseSentinelCrimbo')
	{	// its a ceiling defense sentinel
		SpawnLoc.z -= 80;	// leave on ceiling
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DDCC = spawn(class'DruidDefenseSentinelControllerCrimbo');
			if ( DDCC != None )
			{
				DDCC.DamageAdjust = epi.SentinelDamageAdjust;
				DDCC.SetPlayerSpawner(Instigator.Controller);
				DDCC.Possess(NewSentinel);

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DruidLinkSentinel')
	{	// its a link sentinel
		if (bOnCeiling)
		{
			SpawnLoc.z -= 70;		// leave on ceiling
			SpawnRotation.Yaw = 0;
			SpawnRotation.Roll = 32768;          // upside down
			NewSentinel = epi.SummonRotatedSentinel(SummonItem, Points, P, SpawnLoc,SpawnRotation);
		}
		else
		{
			SpawnLoc.z += 67;		// lift just off ground, and then base steps back a bit
			SpawnRotation.Yaw = 32768;
			NewSentinel =  epi.SummonRotatedSentinel(SummonItem, Points, P, SpawnLoc,SpawnRotation);
		}
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DLSC = spawn(class'DruidLinkSentinelController');
			if ( DLSC != None )
			{
				//DLSC.DamageAdjust = epi.SentinelDamageAdjust;
				DLSC.SetPlayerSpawner(Instigator.Controller);
				DLSC.Possess(NewSentinel);

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else if (RealSummonItem == class'DruidAddLinkSentinel')
	{	// its a link sentinel
		if (bOnCeiling)
		{
			SpawnLoc.z -= 70;		// leave on ceiling
			SpawnRotation.Yaw = 0;
			SpawnRotation.Roll = 32768;          // upside down
			NewSentinel = epi.SummonRotatedSentinel(SummonItem, Points, P, SpawnLoc,SpawnRotation);
		}
		else
		{
			SpawnLoc.z += 67;		// lift just off ground, and then base steps back a bit
			SpawnRotation.Yaw = 32768;
			NewSentinel =  epi.SummonRotatedSentinel(SummonItem, Points, P, SpawnLoc,SpawnRotation);
		}
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DLSC = spawn(class'DruidLinkSentinelController');
			if ( DLSC != None )
			{
				//DLSC.DamageAdjust = epi.SentinelDamageAdjust;
				DLSC.SetPlayerSpawner(Instigator.Controller);
				DLSC.Possess(NewSentinel);

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	}
	else
	{	// its some other kind of sentinel
		SpawnLoc.z += 60;		// lift just off ground
		NewSentinel = epi.SummonBaseSentinel(RealSummonItem, Points, P, SpawnLoc);
		if (NewSentinel == None)
			return false;
		SetStartHealth(NewSentinel);

		// let's add the sentinel controller
		if ( Role == Role_Authority )
		{
			DBSC = spawn(class'DruidBaseSentinelController');
			if ( DBSC != None )
			{
				DBSC.SetPlayerSpawner(Instigator.Controller);
				DBSC.Possess(NewSentinel);

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewSentinel,Instigator);
			}
		}
	} 

	return true;
}

function bool SpawnEnergyWall(TranslocatorBeacon Beacon, Pawn P, EngineerPointsInv epi)
{
	Local DruidEnergyWall NewEnergyWall;
	local DruidEnergyWallController EWC;
	local Actor A;
	local vector HitLocation, HitNormal;
	local vector Post1SpawnLoc, Post2SpawnLoc, SpawnLoc; 
	local vector Normalvect, XVect, YVect, ZVect;
	local class<DruidEnergyWall> WallSummonItem;
	
	WallSummonItem = class<DruidEnergyWall>(SummonItem);
	if (WallSummonItem == None)
	{
		bActive = false;
		GotoState('');
		return false;
	}
		
	SpawnLoc = epi.GetSpawnHeight(Beacon.Location);	// look at the floor
	SpawnLoc.z += 20 + (WallSummonItem.default.Height/2);								// step up a bit off the ground
	
	// now work out the position of the posts
	NormalVect = Normal(SpawnLoc-Instigator.Location);
	NormalVect.Z = 0;
	YVect = NormalVect;
	ZVect = vect(0,0,1);	// always vertical
	XVect = Normal(YVect cross ZVect);	// vector at 90 degrees to the other two

	// first check the height
	if (!FastTrace(SpawnLoc, SpawnLoc + (ZVect*WallSummonItem.default.Height)))
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 6000, None, None, Class);
		bActive = false;
		GotoState('');
		return false;
	}
	
	A = Trace(HitLocation, HitNormal, SpawnLoc + (XVect*WallSummonItem.default.MaxGap*0.5), SpawnLoc, true,, );
	if (A == None)
		Post1SpawnLoc = SpawnLoc + (XVect*WallSummonItem.default.MaxGap*0.5);
	else
		Post1SpawnLoc = HitLocation - 20*XVect;		// step back slightly from the object
	
	A = None;
	A = Trace(HitLocation, HitNormal, SpawnLoc - (XVect*WallSummonItem.default.MaxGap*0.5), SpawnLoc, true,, );
	if (A == None)
		Post2SpawnLoc = SpawnLoc - (XVect*WallSummonItem.default.MaxGap*0.5);
	else
		Post2SpawnLoc = HitLocation + 20*XVect;		// step back slightly from the object
		
	// ok now lets spawn it
	if ((Post1SpawnLoc == vect(0,0,0)) || (Post2SpawnLoc == vect(0,0,0)) || VSize(Post1SpawnLoc - Post2SpawnLoc) > WallSummonItem.default.MaxGap  || VSize(Post1SpawnLoc - Post2SpawnLoc) < WallSummonItem.default.MinGap)
	{
		// cant spawn one of the posts or one has gone awol
		Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
		bActive = false;
		GotoState('');
		return false;
	}

	// have 2 valid post positions and a gap inbetween
	NewEnergyWall = epi.SummonEnergyWall(WallSummonItem, Points, P, SpawnLoc, Post1SpawnLoc, Post2SpawnLoc);
	if (NewEnergyWall == None)
		return false;
	SetStartHealth(NewEnergyWall);
	NewEnergyWall.DamageAdjust = epi.SentinelDamageAdjust;
	
	// now lets add the controller
	if ( Role == Role_Authority )
	{
		// create the controller for this energy wall
		EWC = DruidEnergyWallController(spawn(NewEnergyWall.default.DefaultController));
		if ( EWC != None )
		{
			EWC.SetPlayerSpawner(Instigator.Controller);
			EWC.Possess(NewEnergyWall);

			// now allow player to get xp bonus
			ApplyStatsToConstruction(NewEnergyWall,Instigator);
		}
	}
	return true;
}

defaultproperties
{
     IconMaterial=Texture'DEKRPGTexturesMaster207P.Artifacts.SummonSentinelIcon'
     ItemName=""
}
