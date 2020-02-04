class MutDruidRPG extends Mutator
	config(UT2004RPG);

var RPGRules rules;
var config class<RPGDamageGameRules> DamageRules;

struct ArtifactKeyConfig
{
	Var String Alias;
	var Class<RPGArtifact> ArtifactClass;
};
var config Array<ArtifactKeyConfig> ArtifactKeyConfigs;

function PostBeginPlay()
{
	Enable('Tick');
}

function ModifyPlayer(Pawn Other)
{	// for the keys and subclasses
	Local GiveItemsInv GIInv;

	super.ModifyPlayer(Other);

	if (Other == None || Other.Controller == None || !Other.Controller.IsA('PlayerController'))
		return;

	//add the default items to their inventory..
	GIInv = class'GiveItemsInv'.static.GetGiveItemsInv(Other.Controller);
	if(GIInv != None)
		return;
	
	// ok, no GiveItemsInv. Let's create one
	GIInv = Spawn(class'GiveItemsInv', Other);
	
	GIInv.KeysMut = self;
	
	// first put on controller inventory. Put at start of Inv to make sure RPGStatsInv doesn't delete it
	GIInv.Inventory = Other.Controller.Inventory;
	Other.Controller.Inventory = GIInv;

	GIInv.SetOwner(Other.Controller);
	
	// then initialise keys and subclass info
	GIInv.InitializeKeyArray();
	GIInv.InitializeSubClasses(Other);
}

function Tick(float deltaTime)
{
	local GameRules G;
	local RPGDamageGameRules DG;

	if(rules != None)
	{
		Disable('Tick');
		return; //already initialized
	}

	// Need to add DruidRPGGameRules after RPGRules, and DruidRPGDamageGameRules before RPGRules.
	if ( Level.Game.GameRulesModifiers == None )
		warn("Warning: There is no UT2004RPG Loaded. DruidsRPG cannot function.");
	else
	{
		for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
		{
			if(G.isA('RPGRules'))
				rules = RPGRules(G);
			if(G.NextGameRules == None)
			{
				if(rules == None)
				{
					warn("Warning: There is no UT2004RPG Loaded. DruidsRPG cannot function.");
					return;
				}
			}
		}
		// ok, so we have a RPGRules in the list. lets add RPGDamageGameRules before it, if required
		Log("DamageRules:" $ DamageRules);
		if (DamageRules != None)
		{
			DG = spawn(DamageRules);
			if (Level.Game.GameRulesModifiers != None && Level.Game.GameRulesModifiers.IsA('RPGRules'))
			{
				// RPGRules is at the start. So add before it
				DG.NextGameRules = Level.Game.GameRulesModifiers;
				Level.Game.GameRulesModifiers = DG;
			}
			else
			{
				for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
				{
					if (G.NextGameRules != None && G.NextGameRules.IsA('RPGRules'))
					{
						DG.NextGameRules = G.NextGameRules;
						G.NextGameRules = DG;
					}
				}
			}
			DG.UT2004RPGRules = RPGRules(DG.NextGameRules);
		}
		
		// now add DruidRPGGameRules to the end of the chain
		Level.Game.GameRulesModifiers.AddGameRules(spawn(class'DruidRPGGameRules'));
		Disable('Tick');
		return;
	}
}

defaultproperties
{
     DamageRules=Class'DEKRPG208.RPGDamageGameRules'
     ArtifactKeyConfigs(0)=(Alias="SelectTriple",ArtifactClass=Class'DEKRPG208.DruidArtifactTripleDamage')
     ArtifactKeyConfigs(1)=(Alias="SelectGlobe",ArtifactClass=Class'DEKRPG208.DruidArtifactInvulnerability')
     ArtifactKeyConfigs(2)=(Alias="SelectMWM",ArtifactClass=Class'DEKRPG208.DruidArtifactMakeMagicWeapon')
     ArtifactKeyConfigs(3)=(Alias="SelectDouble",ArtifactClass=Class'DEKRPG208.DruidDoubleModifier')
     ArtifactKeyConfigs(4)=(Alias="SelectMax",ArtifactClass=Class'DEKRPG208.DruidMaxModifier')
     ArtifactKeyConfigs(5)=(Alias="SelectPlusOne",ArtifactClass=Class'DEKRPG208.DruidPlusOneModifier')
     ArtifactKeyConfigs(6)=(Alias="SelectBolt",ArtifactClass=Class'DEKRPG208.ArtifactLightningBolt')
     ArtifactKeyConfigs(7)=(Alias="SelectRepulsion",ArtifactClass=Class'DEKRPG208.ArtifactRepulsion')
     ArtifactKeyConfigs(8)=(Alias="SelectFreezeBomb",ArtifactClass=Class'DEKRPG208.ArtifactFreezeBomb')
     ArtifactKeyConfigs(9)=(Alias="SelectPoisonBlast",ArtifactClass=Class'DEKRPG208.ArtifactPoisonBlast')
     ArtifactKeyConfigs(10)=(Alias="SelectMegaBlast",ArtifactClass=Class'DEKRPG208.ArtifactMegaBlast')
     ArtifactKeyConfigs(11)=(Alias="SelectHealingBlast",ArtifactClass=Class'DEKRPG208.ArtifactHealingBlast')
     ArtifactKeyConfigs(12)=(Alias="SelectMedic",ArtifactClass=Class'DEKRPG208.ArtifactMakeSuperHealer')
     ArtifactKeyConfigs(13)=(Alias="SelectFlight",ArtifactClass=Class'DEKRPG208.DruidArtifactFlight')
     ArtifactKeyConfigs(14)=(Alias="SelectElectroMagnet",ArtifactClass=Class'DEKRPG208.DruidArtifactSpider')
     ArtifactKeyConfigs(15)=(Alias="SelectTeleport",ArtifactClass=Class'UT2004RPG.ArtifactTeleport')
     ArtifactKeyConfigs(16)=(Alias="SelectBeam",ArtifactClass=Class'DEKRPG208.ArtifactLightningBeam')
     ArtifactKeyConfigs(17)=(Alias="SelectRod",ArtifactClass=Class'DEKRPG208.DruidArtifactLightningRod')
     ArtifactKeyConfigs(18)=(Alias="SelectSphereInv",ArtifactClass=Class'DEKRPG208.ArtifactSphereInvulnerability')
     ArtifactKeyConfigs(19)=(Alias="SelectSphereHeal",ArtifactClass=Class'DEKRPG208.ArtifactSphereHealing')
     ArtifactKeyConfigs(20)=(Alias="SelectSphereDamage",ArtifactClass=Class'DEKRPG208.ArtifactSphereDamage')
     ArtifactKeyConfigs(21)=(Alias="SelectRemoteDamage",ArtifactClass=Class'DEKRPG208.ArtifactRemoteDamage')
     ArtifactKeyConfigs(22)=(Alias="SelectRemoteInv",ArtifactClass=Class'DEKRPG208.ArtifactRemoteInvulnerability')
     ArtifactKeyConfigs(23)=(Alias="SelectRemoteMax",ArtifactClass=Class'DEKRPG208.ArtifactRemoteMax')
     ArtifactKeyConfigs(24)=(Alias="SelectShieldBlast",ArtifactClass=Class'DEKRPG208.ArtifactShieldBlast')
     ArtifactKeyConfigs(25)=(Alias="SelectChain",ArtifactClass=Class'DEKRPG208.ArtifactChainLightning')
     ArtifactKeyConfigs(26)=(Alias="SelectFireBall",ArtifactClass=Class'DEKRPG208.ArtifactFireBall')
     ArtifactKeyConfigs(27)=(Alias="SelectRemoteBooster",ArtifactClass=Class'DEKRPG208.ArtifactRemoteBooster')
     ArtifactKeyConfigs(28)=(Alias="SelectResurrect",ArtifactClass=Class'DEKRPG208.ArtifactResurrect')
     ArtifactKeyConfigs(29)=(Alias="SelectHeavyGuard",ArtifactClass=Class'DEKRPG208.ArtifactMakeHeavyGuard')
     ArtifactKeyConfigs(30)=(Alias="SelectGorgon",ArtifactClass=Class'DEKRPG208.ArtifactMakeGorgon')
     ArtifactKeyConfigs(31)=(Alias="SelectInfinity",ArtifactClass=Class'DEKRPG208.ArtifactMakeInfinity')
     ArtifactKeyConfigs(32)=(Alias="SelectLucky",ArtifactClass=Class'DEKRPG208.ArtifactMakeLucky')
     ArtifactKeyConfigs(33)=(Alias="SelectMagnet",ArtifactClass=Class'DEKRPG208.ArtifactPriestMagnet')
     ArtifactKeyConfigs(34)=(Alias="SelectMatrix",ArtifactClass=Class'DEKRPG208.ArtifactMakeMatrix')
	 ArtifactKeyConfigs(35)=(Alias="SelectDecoy",ArtifactClass=Class'DEKRPG208.ArtifactDecoy')
	 ArtifactKeyConfigs(36)=(Alias="SelectImmobilize",ArtifactClass=Class'DEKRPG208.ArtifactImmobilize')
	 ArtifactKeyConfigs(37)=(Alias="SelectGlowStreak",ArtifactClass=Class'DEKRPG208.ArtifactGlowStreak')
	 ArtifactKeyConfigs(38)=(Alias="SelectMeteor",ArtifactClass=Class'DEKRPG208.ArtifactMeteorShower')
	 ArtifactKeyConfigs(39)=(Alias="SelectRemoteAmplifier",ArtifactClass=Class'DEKRPG208.ArtifactRemoteAmplifier')
     GroupName="DruidsRPG"
     FriendlyName="DEKRPG208 Druid's RPG Game Rules"
     Description="DEKRPG is an extension of DruidsRPG by Druid, Shantara and Szlat, and Mysterial's UT2004RPG. DEKRPG expands on abilities, artifacts, magic weapons, and adds an interactive mission system."
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
