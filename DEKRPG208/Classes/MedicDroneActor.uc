class MedicDroneActor extends Actor;

var MutUT2004RPG RPGMut;
var RPGStatsInv StatsInv;
var MedicDrone Drone;
var Pawn MyPawn, MyMaster;
var float TargetRadius;
var config float XPPerHealing;
var bool bHealing;
var config float TimeBetweenShots;
var class<xEmitter> HealEmitterClass;

var Material HealingOverlay;

replication
{
	reliable if (Role == ROLE_Authority)
		MyPawn,MyMaster;
}

simulated function PostBeginPlay()
{
	local Mutator m;
	
	//Let's see if the RPG mutator is on.
	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
	//Declare some variables here.
	Drone = MedicDrone(Owner);
	MyMaster = Drone.DroneMaster;
	if (Drone != None)
		SetBase(Drone);
		
	//Set healing on the Drone.
    SetTimer(TimeBetweenShots, true);
	Super.PostBeginPlay();
}

simulated function Timer()
{
	local Controller C;
	Local Pawn LoopP, RealP;
	Local float NumHelped;
	Local HealableDamageInv HDInv;
	local Mutator m;
	local xEmitter HitEmitter;

	if (Drone == None)
	{
		return;
		Destroy();
	}
		
    NumHelped = 0.0;
	
	if (bHealing)
	{
	    Log("=================!!!!! bHealing still set ");      // just in case the cpu gets too busy
	    return;
	}
    bHealing = true;
	
	//MyPawn variable is listed here because DroneTarget can constantly change, so Timer function will update with new info.
	MyPawn=Drone.DroneTarget;
		
   // loop through all the pawns in range. Can't use controllers as blocks and unmanned turrets/vehicles do not have controllers.
	foreach DynamicActors(class'Pawn', LoopP)
	{
	// first check if the pawn is anywhere near
	    if (LoopP != None && LoopP == MyPawn)
	    {
			// ok, let's go for it
			C = LoopP.Controller;

			if ( C != None && MyPawn != None && LoopP != Drone && LoopP.Health > 0 && C.SameTeamAs(MyMaster.Controller) )
			{
				//ok lets see if we can help.
				RealP = LoopP;
				if (LoopP != None && LoopP.isA('Vehicle'))
					RealP = Vehicle(LoopP).Driver;

				if (RealP != None && XPawn(RealP) != None && HardCoreInv(RealP.FindInventoryType(class'HardCoreInv')) == None)  // only interested in health/shields/ammo/adren for player pawns
		        {
					if (Drone.HealthHealingLevel > 0 && RealP.Health < (RealP.HealthMax + 100))
					{
					    // can add some health
						RealP.GiveHealth(max(1,Drone.HealthHealingAmount * Drone.HealthHealingLevel), RealP.HealthMax + 100);
						RealP.SetOverlayMaterial(HealingOverlay, 1.0, false);
						
						HitEmitter = spawn(HealEmitterClass,,, Drone.Location, rotator(LoopP.Location - Drone.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = LoopP.Location;

						HDInv = HealableDamageInv(RealP.FindInventoryType(class'HealableDamageInv'));
						if(HDInv != None)
						{
							//help keep things in check so a player never has surplus damage in storage. But don't use any for this healing
							if(HDInv.Damage > (RealP.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus) - RealP.Health)
								HDInv.Damage = Max(0, (RealP.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus) - RealP.Health); //never let it go negative.
						}
						if(MyMaster != C)
							NumHelped += (Drone.HealthHealingLevel * 3);  // score triple for health;
					}
				}
			}
		}
    }

	if ((XPPerHealing > 0) && (NumHelped > 0) && MyMaster != None && MyMaster.Controller != None && MyPawn != MyMaster)
	{
		// now give xp according to number healped.
		if (StatsInv == None)
	        StatsInv = RPGStatsInv(MyMaster.FindInventoryType(class'RPGStatsInv'));
		// quick check to make sure we got the RPGMut set
		if (RPGMut == None && Level.Game != None)
		{
			for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
				if (MutUT2004RPG(m) != None)
				{
					RPGMut = MutUT2004RPG(m);
					break;
				}
		}
		if ((StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None))
		{
			StatsInv.DataObject.AddExperienceFraction(XPPerHealing * NumHelped, RPGMut, MyMaster.PlayerReplicationInfo);
		}
	}
    bHealing = false;
}

defaultproperties
{
     TargetRadius=600.000000
     XPPerHealing=0.033333
     TimeBetweenShots=1.000000
     HealEmitterClass=Class'DEKRPG208.LightningBeamEmitter'
     HealingOverlay=Shader'UTRPGTextures2.Overlays.PulseBlueShader1'
     bHidden=True
     Physics=PHYS_Trailer
     bHardAttach=True
}
