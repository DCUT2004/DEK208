class DefenseDroneProtector extends Actor;

var MutUT2004RPG RPGMut;
var RPGStatsInv StatsInv;
var config float TimeBetweenShots;
var DefenseDrone Drone;
var float TargetRadius;
var class<xEmitter> HitEmitterClass;        // for standard defense sentinel
var class<xEmitter> ArmorEmitterClass, ResupplyEmitterClass;
var config float XPPerHealing;
var bool bHealing;
var bool CanDefend;
var int DoHealCount;
var config int HealFreq;        // how often to go through the healing loop. 2 means every other time.

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		Drone;
}

simulated function PostBeginPlay()
{
	local Mutator m;
	
	Super.PostBeginPlay();
	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
    SetTimer(TimeBetweenShots, true);
}

function Timer()
{
	// lets target some enemies
	local Projectile P;
	local xEmitter HitEmitter;
	local Projectile ClosestP;
	local Projectile BestGuidedP;
	local Projectile BestP;
	local int ClosestPdist;
	local int BestGuidedPdist;

	if (Drone == None || Drone.protPawn == None || Drone.protPawn.Health <= 0)
		return;		// going to die soon.

	// look for projectiles in range
	if (CanDefend)
	{
		ClosestP = None;
		BestGuidedP = None;
		ClosestPdist = TargetRadius+1;
		BestGuidedPdist = TargetRadius+1;
		ForEach DynamicActors(class'Projectile',P)
		{
			if (P != None && FastTrace(P.Location, Drone.Location) && TranslocatorBeacon(P) == None && UntargetedProjectile(P) == None && UntargetedSeekerProjectile(P) == None && DEKLightningTurretProj(P) == None && VSize(Drone.Location - P.Location) <= TargetRadius)
			{
				if ((P.InstigatorController == None ||
					(P.InstigatorController != None &&
						((TeamGame(Level.Game) != None && !P.InstigatorController.SameTeamAs(Drone.protPawn.Controller))	// not same team
						 || (TeamGame(Level.Game) == None && P.InstigatorController != Drone.protPawn.Controller)))))	// or just not me
				{
					// its an enemy projectile
					// we prefer to target a server guided projectile, so it can be destroyed client side as well
					// otherwise just go for the closest
					if ( BestGuidedPdist > VSize(Drone.Location - P.Location) && P.bNetTemporary == false && !P.bDeleteMe)
					{
						BestGuidedP = P;
						BestGuidedPdist = VSize(Drone.Location - P.Location);
					}
					if ( ClosestPdist > VSize(Drone.Location - P.Location) && !P.bDeleteMe)
					{
						ClosestP = P;
						ClosestPdist = VSize(Drone.Location - P.Location);
					}

				}
			}
		}
		if (BestGuidedP != None)
			BestP = BestGuidedP;
		else
			BestP = ClosestP;

		if (BestP != None && !BestP.bDeleteMe)
		{
			HitEmitter = spawn(HitEmitterClass,,, Drone.Location, rotator(BestP.Location - Drone.Location));
			if (HitEmitter != None)
				HitEmitter.mSpawnVecA = BestP.Location;

			BestP.NetUpdateTime = Level.TimeSeconds - 1;
			BestP.bHidden = true;
			if (BestP.Physics != PHYS_None)	// to stop attacking an exploding redeemer
			{
				// destroy it
				BestP.Explode(BestP.Location,vect(0,0,0));
				
			}
		}
	}

	DoHealCount++;
	if (DoHealCount >= HealFreq)
	{
		DoHealCount = 0;    // reset
		DoHealing();
	}
}

function DoHealing()
{
	local Controller C;
	local xEmitter HitEmitter;
	Local Pawn LoopP;

	if (Drone == None || Drone.protPawn == None || Drone.protPawn.Health <= 0)
		Destroy();
	
	if (bHealing)
	{
	    Log("=================!!!!! bHealing still set ");      // just in case the cpu gets too busy
	    return;
	}
    bHealing = true;
		
   // loop through all the pawns in range. Can't use controllers as blocks and unmanned turrets/vehicles do not have controllers.
	foreach DynamicActors(class'Pawn', LoopP)
	{
	// first check if the pawn is anywhere near
	    if (LoopP != None)
	    {
			if (VSize(LoopP.Location - Drone.protPawn.Location) < TargetRadius && FastTrace(LoopP.Location, Drone.protPawn.Location))
			{
				// ok, let's go for it
				C = LoopP.Controller;
				if (Drone.protPawn != None && Drone.ArmorHealingLevel > 0)
				{
					// check for what the pawn is
					if (LoopP != None && LoopP != Drone.protPawn && LoopP.Health > 0)
					{
						if (Vehicle(LoopP) != None || DruidEnergyWall(LoopP) != None)
						{
							// looking good so far. Now let's check if on same team
							if (LoopP.GetTeamNum() == Drone.protPawn.GetTeamNum() && LoopP.Health < LoopP.HealthMax)
							{
								// can add some health
								LoopP.GiveHealth(max(1,(Drone.ArmorHealingAmount * Drone.ArmorHealingLevel)), LoopP.HealthMax);
								HitEmitter = spawn(ArmorEmitterClass,,, Drone.Location, rotator(LoopP.Location - Drone.Location));
								if (HitEmitter != None)
									HitEmitter.mSpawnVecA = LoopP.Location;
							}
						}
					}
				}
			}
		}
	}
	if (Drone.protPawn != None && Drone.ResupplyLevel > 0 && Drone.protPawn.Weapon != None && Drone.protPawn.Weapon.AmmoClass[0] != None && !class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Drone.protPawn.Weapon.AmmoClass[0])
		&& !Drone.protPawn.Weapon.AmmoMaxed(0))
	{
		// can add some ammo
		Drone.protPawn.Weapon.AddAmmo(max(1,(Drone.ResupplyAmount * Drone.ResupplyLevel * Drone.protPawn.Weapon.AmmoClass[0].default.MaxAmmo)/100.0), 0);

		HitEmitter = spawn(ResupplyEmitterClass,,, Drone.Location, rotator(Drone.protPawn.Location - Drone.Location));
		if (HitEmitter != None)
			HitEmitter.mSpawnVecA = Drone.protPawn.Location;
	}
    bHealing = false;
}

defaultproperties
{
	 CanDefend=False
     HealFreq=2
     TimeBetweenShots=0.40000
     TargetRadius=750.000000
     HitEmitterClass=Class'DEKRPG208.DefenseBoltEmitter'
     ArmorEmitterClass=Class'DEKRPG208.BronzeBoltEmitter'
     ResupplyEmitterClass=Class'DEKRPG208.RedBoltEmitter'
     XPPerHealing=0.020000
     bHidden=True
     Physics=PHYS_Trailer
     bHardAttach=True
}
