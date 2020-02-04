class DEKPlasmaTurretProj extends ONSHoverBikePlasmaProjectile;

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local RPGStatsInv StatsInv, HealerStatsInv;
	local float old_xp,cur_xp,xp_each,xp_diff,xp_given_away;
	local int i;
    local int DriverLevel;
    local Controller C;

	if ( Instigator != None && (Other == Instigator) )
		return;

    if (Other == Owner) return;

	if ( !Other.IsA('Projectile') || Other.bProjTarget )
	{
		if ( Role == ROLE_Authority )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Other.SetDelayedDamageInstigatorController( InstigatorController );

			// find the current dataobject
			if (DEKPlasmaTurret(Instigator) != None && DEKPlasmaTurret(Instigator).Driver != None)
			{
				StatsInv = RPGStatsInv(DEKPlasmaTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None && StatsInv.DataObject != None)
				{
					old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
					DriverLevel = StatsInv.DataObject.Level;

					if (Level.TimeSeconds > DEKPlasmaTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKPlasmaTurret(Instigator).NumHealers > 0)
						Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKPlasmaTurret(Instigator).NumHealers);
				}
			}

			Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);

			if (StatsInv != None && StatsInv.DataObject != None && DriverLevel == StatsInv.DataObject.Level)		// if the driver has levelled, then do not share xp
			{
				cur_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
				xp_diff = cur_xp - old_xp;
				if (xp_diff > 0 && DEKPlasmaTurret(Instigator).NumHealers > 0)
//				if (xp_diff > 0 && Level.TimeSeconds > DEKPlasmaTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKPlasmaTurret(Instigator).NumHealers > 0)
				{
					// split the xp amongst the healers
					xp_each = class'RW_EngineerLink'.static.XPForLinker(xp_diff , DEKPlasmaTurret(Instigator).Healers.length);
					xp_given_away = 0;

					for(i = 0; i < DEKPlasmaTurret(Instigator).Healers.length; i++)
					{
						if (DEKPlasmaTurret(Instigator).Healers[i].Pawn != None && DEKPlasmaTurret(Instigator).Healers[i].Pawn.Health >0)
						{
						    C = DEKPlasmaTurret(Instigator).Healers[i];
						    if (DruidLinkSentinelController(C) != None)
								HealerStatsInv = DruidLinkSentinelController(C).StatsInv;
						    else
								HealerStatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
							if (HealerStatsInv != None && HealerStatsInv.DataObject != None)
								HealerStatsInv.DataObject.AddExperienceFraction(xp_each, DEKPlasmaTurret(Instigator).RPGMut, DEKPlasmaTurret(Instigator).Healers[i].Pawn.PlayerReplicationInfo);
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
				// DEKPlasmaTurret(Instigator).Healers.length = 0;	// we have just paid them, so scrub their names
			}
		}
		Explode(HitLocation, -Normal(Velocity));
	}
}

defaultproperties
{
     Damage=39.000000
     DamageRadius=0.000000
     MyDamageType=Class'DEKRPG208.DamTypePlasmaTurret'
}
