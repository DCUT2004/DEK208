class TechTitanMine extends ONSMineProjectile;

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;
	local int TakePercent, DamageVictimAdjust;
	local int OldHealth, HealthTaken;

	if ( bHurtEntry )
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo') )
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			if ( Instigator == None || Instigator.Controller == None )
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
			if ( Victims == LastTouched )
				LastTouched = None;
				
            OldHealth = 0;
            DamageVictimAdjust = 1;
			if (Pawn(Victims) != None)
			{
			    OldHealth = Pawn(Victims).Health;
		        TakePercent = 0;
			    if (DruidBlock(Victims) != None && !Victims.IsA('TarydiumCrystal'))
			    {
		            DamageVictimAdjust = 10;
		            TakePercent = 25;
				}
				else if (vehicle(Victims) != None)
				{
		            DamageVictimAdjust = 5;
		            TakePercent = 10;
				}
			}

			Victims.TakeDamage
			(
				damageScale * DamageAmount * DamageVictimAdjust,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * Momentum * dir),
				DamageType
			);
			if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
			if (OldHealth > 0)
			{
			    // means this one was a pawn
			    if (Victims == None || Pawn(Victims).Health <= 0)
			        HealthTaken = OldHealth;
				else
				    HealthTaken = OldHealth - Pawn(Victims).Health;
				if (HealthTaken < 0)
				    HealthTaken = 0;
				// now take some health back
				if (HealthTaken > 0 && Instigator != None)
				{
					HealthTaken = max((HealthTaken * TakePercent)/100.0, 1);
					Instigator.GiveHealth(HealthTaken, Instigator.HealthMax);
				}
			}

		}
	}

	bHurtEntry = false;
}

function AcquireTarget()
{
	local Pawn A;
	local float Dist, BestDist;

    TargetPawn = None;

    foreach VisibleCollidingActors(class'Pawn', A, 750.0)
    {
        if ( A != None && A != Instigator && A.Health > 0 && A.GetTeamNum() != TeamNum
         && (Vehicle(A) == None || Vehicle(A).Driver != None || Vehicle(A).bTeamLocked)
    	 && (ONSStationaryWeaponPawn(A) == None || ONSStationaryWeaponPawn(A).bPowered) )
	    {
			if ( Level.Game.IsA('Invasion'))
			{
				if (!A.IsA('Monster') || ( A.IsA('Monster') && A.GetTeamNum() == 0 )) //determine if the target is a player or a pet and not another enemy monster
				{
					Dist = VSize(A.Location - Location);
					if (TargetPawn == None || Dist < BestDist)
					{
						TargetPawn = A;
						BestDist = Dist;
					}
				}
			}
			else if ( A.GetTeamNum() != TeamNum ) //determine if the target is an enemy on the opposing team
			{
				Dist = VSize(A.Location - Location);
				if (TargetPawn == None || Dist < BestDist)
				{
					TargetPawn = A;
					BestDist = Dist;
				}
			}
	    }
	}
}

function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	
	if (InstigatedBy != None && InstigatedBy.Health > 0)
	{
		MiInv = MissionInv(InstigatedBy.FindInventoryType(class'MissionInv'));
		M1Inv = Mission1Inv(InstigatedBy.FindInventoryType(class'Mission1Inv'));
		M2Inv = Mission2Inv(InstigatedBy.FindInventoryType(class'Mission2Inv'));
		M3Inv = Mission3Inv(InstigatedBy.FindInventoryType(class'Mission3Inv'));
	
		if (Damage > 0 && MiInv != None && !MiInv.DisarmerComplete)
		{
			if (M1Inv != None && !M1Inv.Stopped && M1Inv.DisarmerActive)
				M1Inv.MissionCount++;
			else if (M2Inv != None && !M2Inv.Stopped && M2Inv.DisarmerActive)
				M2Inv.MissionCount++;
			else if (M3Inv != None && !M3Inv.Stopped && M3Inv.DisarmerActive)
				M3Inv.MissionCount++;
		}
	}
	Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
}

simulated function Destroyed()
{
    if ( !bNoFX && EffectIsRelevant(Location,false) )
        Spawn(class'FlakExplosion');

    Super.Destroyed();
}

defaultproperties
{
     ScurrySpeed=425.000000
     TeamNum=1
     Damage=30.000000
     DamageRadius=300.000000
     MyDamageType=Class'DEKMonsters208.DamTypeTechTitanMine'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.TechMonsters.TechProjFB'
	 Lifespan=6.0000
	 DrawScale=0.100000
}
