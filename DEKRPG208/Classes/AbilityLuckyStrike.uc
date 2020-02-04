//From Pinata2k4 Mutator.
class AbilityLuckyStrike extends CostRPGAbility
	config(UT2004RPG)
	abstract;
	
var config int MaxHealthForLetter, MaxAdrenForLetter;
var config int LetterSChance, ScoringValueForS;
	
static function ScoreKill(Controller Killer, Controller Killed, bool bOwnedByKiller, int AbilityLevel)
{
	local Monster M;
	
	if (!bOwnedByKiller)
		return;

	if ( Killed == Killer || Killed == None || Killer == None || Killed.Level == None || Killed.Level.Game == None)
		return;

	M = Monster(Killed.Pawn);
	if (Killed.Pawn != None && Killed.Pawn.IsA('Monster') && !Killed.SameTeamAs(Killer) && AbilityLevel >= rand(99))
	{

		if (M != None && M.ControllerClass == class'DEKFriendlyMonsterController')
			return;
			
		if (Killed.Pawn.IsA('HealerNali'))
			return;
		
		SpawnMonster(class'HealerNali', Killer, Killed, AbilityLevel);
		
		if (Killer.Pawn.Health <= default.MaxHealthForLetter && Killer.Adrenaline <= default.MaxAdrenForLetter)
		{
			DropPickups(Killed, Killer, class'DEKRPG208.ArtifactLetterOPickup', None, 1);
			return;
		}
		if (ClassIsChildOf(M.Class, class'SMPTitan') || ClassIsChildOf(M.Class, class'SMPStoneTitan'))
		{
			DropPickups(Killed, Killer, class'DEKRPG208.ArtifactLetterNPickup', None, 1);
			return;
		}
		if (ClassIsChildOf(M.Class, class'SMPQueen'))
		{
			DropPickups(Killed, Killer, class'DEKRPG208.ArtifactLetterUPickup', None, 1);
			return;
		}
		if (ClassIsChildOf(M.Class, class'Warlord'))
		{
			DropPickups(Killed, Killer, class'DEKRPG208.ArtifactLetterBPickup', None, 1);
			return;
		}
		if (M.ScoringValue >= default.ScoringValueForS)
		{
			if (default.LetterSChance >= rand(99))
			{
				DropPickups(Killed, Killer, class'DEKRPG208.ArtifactLetterSPickup', None, 1);
				return;
			}
			else
			{	
				DropPickups(Killed, Killer, class'DEKRPG208.GemExperiencePickupPurple', None, 1);
				return;
			}
		}
		else if(M.ScoringValue > 6)
		{
			DropPickups(Killed, Killer, class'DEKRPG208.GemExperiencePickupGreen', None, 1);
			return;
		}
		else
		{
			DropPickups(Killed, Killer, class'DEKRPG208.GemExperiencePickupBlue', None, 1);			
			return;	
		}
	}
}


static function DropPickups(Controller Killed, Controller Killer, class<Pickup> PickupType, Inventory Inv, int Num)
{
    local Pickup pickupObj;
	local vector tossdir, X, Y, Z;
    local int i;

    for(i=0; i < Num; i++)
    {
        // This chain of events based on the way that weapon pickups are dropped when a pawn dies
	    // See Pawn.Died()

    	// Find out which direction the new pickup should be thrown

    	// Get a vector indicating direction the dying pawn was looking

        tossdir = Vector(Killed.Pawn.GetViewRotation());

    	// Adding coordinates to the directional vector

        tossdir = tossdir *	((Killed.Pawn.Velocity Dot tossdir) + 100) + Vect(0,0,200);

        // Change the velocity a bit for multiple drops

        tossdir.X += i*Rand(200);
        tossdir.Y += i*Rand(200);
        tossdir.Z += i*Rand(200);


    	Killed.Pawn.GetAxes(Killed.Pawn.Rotation, X,Y,Z);

	    // Set the pickup's location to a realistic position outside of the dying pawn's collision cylinder

        pickupObj = Killer.spawn(PickupType,,,(Killed.Pawn.Location + 0.8 * Killed.Pawn.CollisionRadius * X + -0.5 * Killed.Pawn.CollisionRadius * Y),);

        if(pickupObj == None)
        {
            Log("Pinata2k4 spawn failure");
            return;
        }

		// Now apply the throwing velocity to the position of the pickup
	    pickupObj.velocity = tossdir;

        pickupObj.InitDroppedPickupFor(Inv);
    }
}

static function SpawnMonster(class<Monster> ChosenMonster, Controller Killer, Controller Killed, int AbilityLevel)
{
	local Monster M;
	
	M = Killer.spawn(ChosenMonster,Killer.Pawn,,Killer.Location + ChosenMonster.default.CollisionHeight * vect(0,0,1.5));
	if (M != None)
	{
		M.Lifespan = 15 + (AbilityLevel * 3);
	}
}

defaultproperties
{
     MaxHealthForLetter=100
     MaxAdrenForLetter=50
     LetterSChance=50
     ScoringValueForS=11
     PlayerLevelReqd(1)=61
     AbilityName="Lucky Strike"
     Description="This ability provides a chance of dropping experience gems, BONUS letters, or even summoning friendly Nali, all upon killing a monster.||Monsters can drop experience gems. Blue gems are worth 5 XP, green 10 XP, purple 15 XP, and gold 25 XP.||Monsters can also drop letters. Spell BONUS to unlock wave 17. There are different conditions for each letter.||Killing a monster can also spawn a Nali, which will grant you health, adrenaline, shield, and even experience gems and letters. Be careful, Nali will be frightened if hurt by a monster.||Each level of this ability increases the drop or Nali summon chance by 1%. This ability is granted to players levels 60 and under as a freebie. You must be level 61 before you can buy this ability.||Cost (per level): 5,10,15,20,25,30,35,40,45,50"
     StartingCost=5
     CostAddPerLevel=5
     MaxLevel=10
}
