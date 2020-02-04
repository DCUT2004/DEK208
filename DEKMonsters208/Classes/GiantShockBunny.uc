class GiantShockBunny extends GiantWarBunny
	config(satoreMonsterPack);

function PostBeginPlay()
{
	super.PostBeginPlay();

	CheckRPGRules();
}

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}
	}

	if(Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.class == class'GiantWarbunny' );
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, vector momentum, class<DamageType> damageType)
{
    local Controller C,MC;
    local GiantShockBunnyCharger BunnyUltima;
	
	if (DamageType == class'DamTypeLightningRod' || DamageType == class'DamTypeEnhLightningRod' || DamageType == class'DamTypeLightningBolt' || DamageType == class'DamTypeLightningSent' || DamageType == class'DamTypeLightningTurretMinibolt' || DamageType == class'DamTypeLightningTurretProj' || DamageType == class'DamTypeGiantCosmicBunny' || DamageType == class'DamTypeGiantCosmicBunnyLightning' || DamageType == class'DamTypeGiantShockBunny' || DamageType == class'DamTypeGiantRageBunny' || DamageType == class'DamTypeDronePlasma')
		return;

    C = Level.ControllerList;
    while (C != None)
    {
        if (C.Pawn != None && C.Pawn.IsA('Monster'))
        {
            MC = C;
        }
        C = C.NextController;
    }
	
	instigatedBy.Controller.Adrenaline = 0; //reset adrenaline back to 0 to avoid globing on wave 17.
	
	DropPickups(Instigator.Controller, InstigatedBy.Controller, class'DEKRPG208.GemExperiencePickupGold', None, 2);
    
    BunnyUltima = spawn(class'GiantShockBunnyCharger',MC);
    gibbedBy(instigatedBy);
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

defaultproperties
{
     Skins(0)=Shader'EpicParticles.Beams.hotbolt03SHAD'
     Skins(1)=Shader'EpicParticles.Beams.hotbolt03SHAD'
}
