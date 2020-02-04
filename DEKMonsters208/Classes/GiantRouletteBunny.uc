class GiantRouletteBunny extends SMPMonster
	config(satoreMonsterPack);
	
var bool SummonedMonster;	
var RPGRules Rules;
const  TargetRadius= 1200;
var config int XPForKill;
var config int LowDamageAmount,MediumDamageAmount,HighDamageAmount;
var config bool bOnlyHumansCanDamage;
var config float ChangeInterval;
var config int XPDropChance;
var bool bXPForm, bNormalForm;
var config float LowDamageMultiplier, MedDamageMultiplier, HighDamageMultiplier;
var config int XPForLowHit,XPForMedHit,XPForHighHit;

//replication
//{
//   reliable if (Role == ROLE_Authority)
//        bXPForm, bNormalForm;
//}

function PostBeginPlay()
{
	Instigator = self;
	CheckRPGRules();
	CheckController();
	SetTimer(ChangeInterval, True);
	super.PostBeginPlay();
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

function CheckController()
{
	if (Instigator.ControllerClass == class'DEKFriendlyMonsterController')
		SummonedMonster = true;
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.class == class'GiantWarbunny' );
}

simulated function Timer()
{
	local Monster other;
	
	foreach VisibleCollidingActors(class'Monster',Other,TargetRadius,Location)
	{
		if(!Other.bAmbientCreature && Other.Controller!=none)
			Other.Controller.Trigger(none,self);
	}
	
	if (default.XPDropChance >= rand(99))
	{
		SetInvisibility(30.0);
		bXPForm = True;
		bNormalForm = False;
	}
	else
	{
		SetInvisibility(0.0);
		bXPForm = False;
		bNormalForm = True;
	}
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, vector momentum, class<DamageType> damageType)
{	
	if (DamageType == class'DamTypeLightningRod' || DamageType == class'DamTypeEnhLightningRod' || DamageType == class'DamTypeLightningBolt' || DamageType == class'DamTypeLightningSent' || DamageType == class'DamTypeLightningTurretMinibolt' || DamageType == class'DamTypeLightningTurretProj' || DamageType == class'DamTypeGiantCosmicBunny' || DamageType == class'DamTypeGiantCosmicBunnyLightning' || DamageType == class'DamTypeGiantShockBunny' || DamageType == class'DamTypeGiantRageBunny')
		return;
	
	instigatedBy.Controller.Adrenaline = 0; //reset adrenaline back to 0 to avoid globing on wave 17.
	
	if (bOnlyHumansCanDamage)
	{
		if (instigatedBy.PlayerReplicationInfo.bBot)
			return;
	}
	
	if (bXPForm)
	{
		if (Damage <= default.LowDamageAmount)
		{
			DropPickups(Instigator.Controller, InstigatedBy.Controller, class'DEKRPG208.GemExperiencePickupBlue', None, 1);
			Damage *= 0;
			if (Rules != None && (XPForLowHit > 0))
				Rules.ShareExperience(RPGStatsInv(instigatedBy.FindInventoryType(class'RPGStatsInv')), XPForLowHit);			
		}
		else if (Damage <= default.MediumDamageAmount)
		{
			DropPickups(Instigator.Controller, InstigatedBy.Controller, class'DEKRPG208.GemExperiencePickupGreen', None, 2);
			Damage *= 0;
			if (Rules != None && (XPForMedHit > 0))
				Rules.ShareExperience(RPGStatsInv(instigatedBy.FindInventoryType(class'RPGStatsInv')), XPForMedHit);	
		}
		else
		{
			DropPickups(Instigator.Controller, InstigatedBy.Controller, class'DEKRPG208.GemExperiencePickupPurple', None, 3);
			Damage *= 0;
			if (Rules != None && (XPForHighHit > 0))
				Rules.ShareExperience(RPGStatsInv(instigatedBy.FindInventoryType(class'RPGStatsInv')), XPForHighHit);	
		}
	}
	else if (bNormalForm)
	{
		if (Damage <= default.LowDamageAmount)
		{
			Damage *= default.LowDamageMultiplier;
		}
		else if (Damage <= default.MediumDamageAmount)
		{
			Damage *= default.MedDamageMultiplier;
		}
		else
		{
			Damage *= default.HighDamageMultiplier;
		}
	}
	Super.TakeDamage(Damage, instigatedBy, HitLocation, momentum, damageType);
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

simulated function AnimEnd(int Channel)
{
	local name Anim;
	local float frame,rate;


	if ( Channel == 0 )
	{
		GetAnimParams(0, Anim,frame,rate);
		if ( Anim == 'Call')
			IdleWeaponAnim = 'Looking';
		else if ( (Anim == 'Looking') && (FRand() < 0.5) )
			IdleWeaponAnim = 'Eat';
		else
			IdleWeaponAnim = 'Call';

	}
	super(SMPMonster).AnimEnd(Channel);
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	AmbientSound = None;
    bCanTeleport = false;
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;

	HitDamageType = DamageType; // these are replicated to other clients
    TakeHitLocation = HitLoc;
	LifeSpan = RagdollLifeSpan;

    GotoState('Dying');

	Velocity += TearOffMomentum;
    BaseEyeHeight = Default.BaseEyeHeight;
    SetPhysics(PHYS_Falling);

	CreateGib('head',DamageType,Rotation);
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     LowDamageAmount=30
     MediumDamageAmount=70
     bOnlyHumansCanDamage=True
     ChangeInterval=0.700000
     XPDropChance=50
     LowDamageMultiplier=1.000000
     MedDamageMultiplier=1.250000
     HighDamageMultiplier=1.500000
     XPForLowHit=2
     XPForMedHit=5
     XPForHighHit=10
     InvisMaterial=TexEnvMap'PickupSkins.Shaders.TexEnvMap2'
     IdleHeavyAnim="Call"
     IdleRifleAnim="Eat"
     GroundSpeed=400.000000
     AccelRate=1500.000000
     JumpZ=200.000000
     AirControl=0.100000
     Health=2500
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
     MovementAnims(0)="Jump"
     MovementAnims(1)="Jump"
     MovementAnims(2)="Jump"
     MovementAnims(3)="Jump"
     TurnLeftAnim="Looking"
     TurnRightAnim="Looking"
     WalkAnims(0)="Jump"
     WalkAnims(1)="Jump"
     WalkAnims(2)="Jump"
     WalkAnims(3)="Jump"
     IdleWeaponAnim="Eat"
     IdleRestAnim="Looking"
     TauntAnims(0)="Call"
     TauntAnims(1)="Eat"
     TauntAnims(2)="Call"
     TauntAnims(3)="Eat"
     TauntAnims(4)="Call"
     TauntAnims(5)="Eat"
     TauntAnims(6)="Call"
     TauntAnims(7)="Eat"
     Mesh=VertMesh'satoreMonsterPackMeshes.Rabbit'
     DrawScale=6.000000
     Skins(0)=Texture'satoreMonsterPackTexture.Skins.JRabbit1'
     Skins(1)=Texture'satoreMonsterPackTexture.Skins.JRabbit1'
     CollisionRadius=50.000000
     CollisionHeight=93.500000
}
