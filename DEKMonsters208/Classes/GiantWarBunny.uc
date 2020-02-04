class GiantWarbunny extends DCNaliRabbit
	config(satoreMonsterPack);
	
var RPGRules Rules;
var config int XPForKill;
var config bool bOnlyHumansCanDamage;

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
    local BunnyGhostUltimaCharger BunnyUltima;
	
	if (DamageType == class'DamTypeLightningRod' || DamageType == class'DamTypeEnhLightningRod' || DamageType == class'DamTypeLightningBolt' || DamageType == class'DamTypeLightningSent' || DamageType == class'DamTypeLightningTurretMinibolt' || DamageType == class'DamTypeLightningTurretProj' || DamageType == class'DamTypeGiantCosmicBunny' || DamageType == class'DamTypeGiantCosmicBunnyLightning' || DamageType == class'DamTypeGiantShockBunny' || DamageType == class'DamTypeGiantRageBunny' || DamageType == class'DamTypeDronePlasma')
		return;
		
	if (bOnlyHumansCanDamage)
	{
		if (instigatedBy.PlayerReplicationInfo.bBot)
			return;
	}

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
    
    BunnyUltima = spawn(class'BunnyGhostUltimaCharger',MC);
    gibbedBy(instigatedBy);
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if ((XPForKill > 0) && (Rules != None))
	{
		Rules.ShareExperience(RPGStatsInv(Killer.Pawn.FindInventoryType(class'RPGStatsInv')), XPForKill);
	}
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     XPForKill=30
     bOnlyHumansCanDamage=True
     GroundSpeed=150.000000
     AccelRate=562.500000
     JumpZ=75.000000
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
     DrawScale=6.000000
     CollisionRadius=50.000000
     CollisionHeight=93.500000
}
