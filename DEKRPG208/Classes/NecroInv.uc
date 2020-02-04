class NecroInv extends Inventory;

var RPGRules Rules;
var RPGStatsInv StatsInv;
var MutUT2004RPG RPGMut;

var Controller InstigatorController;
var Pawn PawnOwner;
var PhantomDeathGhostInv PInv;
var bool PhantomDeath;
var config Array< String > Weapons;

var Material ModifierOverlay;

var bool stopped;
var Controller NecromancerController;
var class<DamageType> NecroDamageType;
var config float XPMultiplier;
var int TimeCounter;
var ArtifactResurrect AR;
var sound RevenantSound;

#exec OBJ LOAD FILE=..\Textures\DEKMonstersTexturesMaster206E.utx
#exec OBJ LOAD FILE=..\Textures\H_E_L_Ltx.utx


replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner, NecromancerController;
	reliable if (Role == ROLE_Authority)
		stopped,TimeCounter,PhantomDeath;
}

simulated function PostBeginPlay()
{
	local Mutator m;

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
	if (Instigator != None)
		InstigatorController = Instigator.Controller;
		
	CheckRPGRules();
	Super.PostBeginPlay();
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

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local Pawn OldInstigator;

	if(Other == None)
	{
		destroy();
		return;
	}

	stopped = false;
	if (InstigatorController == None)
		InstigatorController = Other.Controller;

	//want Instigator to be the one that caused the freeze
	OldInstigator = Instigator;
	Super.GiveTo(Other);
	PawnOwner = Other;

	Instigator = OldInstigator;
	
	SetTimer(0.5, true);
	
	SwitchOnInvulnerability();
	
	Instigator.AmbientSound = RevenantSound;
	
	if (PawnOwner.PlayerReplicationInfo != None)
		PawnOwner.PlayerReplicationInfo.bOutOfLives = False;
	
	AR = ArtifactResurrect(NecromancerController.Pawn.FindInventoryType(class'ArtifactResurrect'));
	
	StatsInv = RPGStatsInv(PawnOwner.FindInventoryType(class'RPGStatsInv'));
}

simulated function SwitchOnInvulnerability()
{
	local int x;
	local bool bHasLoadedWeapons;
	local LoadedInv LoadedInv;
	
	bHasLoadedWeapons = False;
	
	if (PawnOwner != None && PawnOwner.Controller != None)
	{
		PawnOwner.Controller.bGodMode = true;
		PawnOwner.Spawn(class'ReviveEffectB', PawnOwner,, PawnOwner.Location, PawnOwner.Rotation);
		PawnOwner.PlaySound(Sound'DDAverted', SLOT_None, 400.0);

		LoadedInv = LoadedInv(PawnOwner.FindInventoryType(class'LoadedInv'));

		if (LoadedInv != None)
		{
			if(LoadedInv.bGotLoadedWeapons)
				bHasLoadedWeapons = True;
		}
		if (!bHasLoadedWeapons)
		{
			for(x = 0; x < default.Weapons.length; x++)
				giveWeapon(PawnOwner, default.Weapons[x], RPGMut);
		}
	}
}

static function giveWeapon(Pawn Other, String oldName, MutUT2004RPG RPGMut)
{
	Local string newName;
	local class<Weapon> WeaponClass;
	local class<RPGWeapon> RPGWeaponClass;
	local Weapon NewWeapon;
	local RPGWeapon RPGWeapon;

	if(Other == None || Other.IsA('Monster'))
		return;

	if(oldName == "")
		return;

	if (Other.Level != None && Other.Level.Game != None && Other.Level.Game.BaseMutator != None)
	{
		newName = Other.Level.Game.BaseMutator.GetInventoryClassOverride(oldName);
		WeaponClass = class<Weapon>(Other.DynamicLoadObject(newName, class'Class'));
	}
	else
		WeaponClass = class<Weapon>(Other.DynamicLoadObject(oldName, class'Class'));

	newWeapon = Other.spawn(WeaponClass, Other,,, rot(0,0,0));
	if(newWeapon == None)
		return;
	while(newWeapon.isA('RPGWeapon'))
		newWeapon = RPGWeapon(newWeapon).ModifiedWeapon;

	RPGWeaponClass = RPGMut.GetRandomWeaponModifier(WeaponClass, Other);

	RPGWeapon = Other.spawn(RPGWeaponClass, Other,,, rot(0,0,0));
	if(RPGWeapon == None)
		return;
	RPGWeapon.Generate(None);
	
	//I'm checking the state of RPG Weapon a bunch because sometimes it becomes none mid method.
	if(RPGWeapon == None)
		return;

	RPGWeapon.SetModifiedWeapon(newWeapon, true);

	if(RPGWeapon == None)
		return;

	RPGWeapon.GiveTo(Other);

	if(RPGWeapon == None)
		return;


	if (oldName == "XWeapons.AssaultRifle")
	{
		RPGWeapon.Loaded();
	}
	RPGWeapon.MaxOutAmmo();
}

function SwitchOffInvulnerability()
{
	if (PawnOwner != None)
	{
		if (PawnOwner.Controller != None)
			PawnOwner.Controller.bGodMode = false;
		PawnOwner.setOverlayMaterial(ModifierOverlay, 10, true);
	}
}

function SendBackToGrave()
{
	PawnOwner.Controller.bGodMode = false;
	PawnOwner.Died(NecromancerController, NecroDamageType, PawnOwner.Location);
	Destroy();
}

simulated function Timer()
{
	Local Vehicle Vehicle;
	
	Vehicle = PawnOwner.DrivenVehicle;
	
	if (AR != None)
	{
		TimeCounter = AR.RevenantLifespan;
	}
	
	if(!stopped)
	{
		TimeCounter--;
		if (PawnOwner != None)
		{
			PawnOwner.ReceiveLocalizedMessage(class'NecroConditionMessage', 0);
			PawnOwner.ReceiveLocalizedMessage(class'NecroTimerMessage', Lifespan);
		}
		if (Role == ROLE_Authority)
		{
			if(LifeSpan <= 0.5)
			{
				if (Invasion(Level.Game) != None)
				{
					if (!PhantomDeath)
					{
						if(Vehicle != None)
						{
							Vehicle.EjectDriver();
							SendBackToGrave();
							return;
							
						}
						else
						{
							SendBackToGrave();
							return;
						}
					}
					else
					{
						if(Vehicle != None)
						{
							Vehicle.EjectDriver();
							Destroy();
							return;
							
						}
						else
						{
							Destroy();
							return;
						}
					}
				}
				else
				{
					//GetEndingScore();
					Destroy();
					return;
				}
			}

			if (Owner == None)
			{
				Destroy();
				return;
			}
			
			if (NecromancerController == None || NecroMancerController.Pawn.Health <= 0)
			{
				if (Invasion(Level.Game) != None)
				{
					if (!PhantomDeath)
					{
						if(Vehicle != None)
						{
							Vehicle.EjectDriver();
							SendBackToGrave();
							return;
							
						}
						else
						{
							SendBackToGrave();
							return;
						}
					}
					else
					{
						if(Vehicle != None)
						{
							Vehicle.EjectDriver();
							Destroy();
							return;
							
						}
						else
						{
							Destroy();
							return;
						}
					}
				}
				else
				{
					Destroy();
					return;
				}
			}
			
			if (!Invasion(Level.Game).bWaveInProgress && Invasion(Level.Game).WaveCountDown > 1)
			{
					if(Vehicle != None)
					{
						Vehicle.EjectDriver();
						SendBackToGrave();
						return;
					}
					else
					{
						Destroy();
						return;
					}
			}

			if (Instigator == None && InstigatorController != None)
				Instigator = InstigatorController.Pawn;
			else if(PawnOwner != None)
			{
				class'RW_Speedy'.static.quickfoot(-7, PawnOwner);
				PawnOwner.setOverlayMaterial(ModifierOverlay, LifeSpan, true);
			}
		}
	}
}

function stopEffect()
{
	if(stopped)
		return;
	else
		stopped = true;
	if (NecromancerController != None)
	{
		if (Invasion(Level.Game) != None)
		{
			NecromancerController.PlayerReplicationInfo.Score += 10;	//even out the score for "team killing"
		}
		else //Probably Freon or Monster Assault
		{
			NecromancerController.PlayerReplicationInfo.Score += 1;
		}
	}
	if(PawnOwner != None)
	{
		class'RW_Speedy'.static.quickfoot(0, PawnOwner);
		SwitchOffInvulnerability();
		PawnOwner.AmbientSound = None;
		if (PhantomDeath)
		{
			PInv = PhantomDeathGhostInv(PawnOwner.FindInventoryType(class'PhantomDeathGhostInv'));
			if (PInv != None)
				PInv.Destroy();
			PInv = PawnOwner.Spawn(class'PhantomDeathGhostInv', PawnOwner);
			PInv.GiveTo(PawnOwner);
		}
	}
}

function destroyed()
{
	stopEffect();
	super.destroyed();
}

defaultproperties
{
     Weapons(0)="XWeapons.RocketLauncher"
     Weapons(1)="XWeapons.ShockRifle"
     Weapons(2)="UT2004RPG.RPGLinkGun"
     Weapons(3)="XWeapons.SniperRifle"
     Weapons(4)="XWeapons.FlakCannon"
     Weapons(5)="XWeapons.MiniGun"
     Weapons(6)="XWeapons.BioRifle"
	 ModifierOverlay=Shader'AWGlobal.Shaders.FlowingBlood02'
     NecroDamageType=Class'DEKRPG208.DamTypeNecroSuicide'
     XPMultiplier=1.000000
     RevenantSound=Sound'GeneralAmbience.tortureloop3'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
