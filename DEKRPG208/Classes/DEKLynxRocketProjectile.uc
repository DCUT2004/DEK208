class DEKLynxRocketProjectile extends ONSMASRocketProjectile;

function BlowUp(vector HitLocation)
{
	local RPGStatsInv StatsInv, HealerStatsInv;
	local float old_xp,cur_xp,xp_each,xp_diff,xp_given_away;
	local int i;
    local int DriverLevel;
    local Controller C;
	
	if ( Role == ROLE_Authority )
	{
		if (DEKLynxTurret(Instigator) != None && DEKLynxTurret(Instigator).Driver != None)
		{
			StatsInv = RPGStatsInv(DEKLynxTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
			if (StatsInv != None && StatsInv.DataObject != None)
			{
				old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
				DriverLevel = StatsInv.DataObject.Level;

				if (Level.TimeSeconds > DEKLynxTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKLynxTurret(Instigator).NumHealers > 0)
					Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKLynxTurret(Instigator).NumHealers);
			}
		}
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

		if (StatsInv != None && StatsInv.DataObject != None && DriverLevel == StatsInv.DataObject.Level)		// if the driver has levelled, then do not share xp
		{
			cur_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
			xp_diff = cur_xp - old_xp;
			if (xp_diff > 0 && DEKLynxTurret(Instigator).NumHealers > 0)
//			if (xp_diff > 0 && Level.TimeSeconds > DEKLynxTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKLynxTurret(Instigator).NumHealers > 0)
			{
				// split the xp amongst the healers
				xp_each = class'RW_EngineerLink'.static.XPForLinker(xp_diff , DEKLynxTurret(Instigator).Healers.length);
				xp_given_away = 0;

				for(i = 0; i < DEKLynxTurret(Instigator).Healers.length; i++)
				{
					if (DEKLynxTurret(Instigator).Healers[i].Pawn != None && DEKLynxTurret(Instigator).Healers[i].Pawn.Health >0)
					{
					    C = DEKLynxTurret(Instigator).Healers[i];
					    if (DruidLinkSentinelController(C) != None)
							HealerStatsInv = DruidLinkSentinelController(C).StatsInv;
					    else
							HealerStatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
						if (HealerStatsInv != None && HealerStatsInv.DataObject != None)
							HealerStatsInv.DataObject.AddExperienceFraction(xp_each, DEKLynxTurret(Instigator).RPGMut, DEKLynxTurret(Instigator).Healers[i].Pawn.PlayerReplicationInfo);
						xp_given_away += xp_each;
					}
				}
				// now adjust the turret operator
				if (xp_given_away > 0)
				{
					StatsInv.DataObject.ExperienceFraction -= xp_given_away;
					while (StatsInv.DataObject.ExperienceFraction < 0)
					{
						StatsInv.DataObject.ExperienceFraction += 1.0;
						StatsInv.DataObject.Experience -= 1;
					}
				}
			}
			// DEKLynxTurret(Instigator).Healers.length = 0;	// we have just paid them, so scrub their names
		}
	}
}

defaultproperties
{
     Speed=2000.000000
     MaxSpeed=2000.000000
     Damage=58.500000
     DamageRadius=120.000000
     MyDamageType=Class'DEKRPG208.DamTypeLynxRocket'
}
