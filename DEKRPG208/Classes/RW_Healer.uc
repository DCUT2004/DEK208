class RW_Healer extends OneDropRPGWeapon
	Config(UT2004RPG)
	HideDropDown
	CacheExempt;

var RPGRules rules;

var config float EXPMultiplier;
var config float DamageBonus;
var config float HealthBonus;
var config int MaxHealth;

function PreBeginPlay()
{
	local GameRules G;
	Local HealableDamageGameRules SG;
	super.PreBeginPlay();

	if ( Level.Game.GameRulesModifiers == None )
	{
		SG = Level.Game.Spawn(class'HealableDamageGameRules');
		if(SG == None)
			log("Warning: Unable to spawn HealableDamageGameRules for Druids RW_Healer. Healing for EXP will not occur.");
		else
			Level.Game.GameRulesModifiers = SG;
	}
	else
	{
		for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
		{
			if(G.isA('HealableDamageGameRules'))
			{
				SG = HealableDamageGameRules(G);
				break;
			}
			if(G.NextGameRules == None)
			{
				SG = Level.Game.Spawn(class'HealableDamageGameRules');
				if(SG == None)
				{
					log("Warning: Unable to spawn HealableDamageGameRules for Druids RW_Healer. Healing for EXP will not occur.");
					return; //try again next time?
				}

				//this will also add it after UT2004RPG, which will be necessarry.
				Level.Game.GameRulesModifiers.AddGameRules(SG);
				break;
			}
		}
	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	setupRules();
}

function setupRules()
{
	Local GameRules G;
	if(rules != None)
		return;
	if ( Level.Game == None)
		return;	//pick up later
	
	if ( Level.Game.GameRulesModifiers == None )
	{
		log("Unable to find RPG Rules. Will retry");
		return;
	}
	else
	{
		for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
		{
			if(G.isA('RPGRules'))
				break;
			if(G.NextGameRules == None)
				log("Unable to find RPG Rules. Will retry"); //we'll try again later
		}
	}
	rules = RPGRules(G);
}

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	if
	(
		(
			Weapon.default.FireModeClass[0] != None && 
			Weapon.default.FireModeClass[0].default.AmmoClass != None && 
			Weapon.default.AmmoClass[0] != None &&
			Weapon.default.AmmoClass[0].default.MaxAmmo > 0 &&
			class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[0].default.AmmoClass)
		) ||
		(
			Weapon.default.FireModeClass[1] != None && 
			Weapon.default.FireModeClass[1].default.AmmoClass != None && 
			Weapon.default.AmmoClass[1] != None &&
			Weapon.default.AmmoClass[1].default.MaxAmmo > 0 &&
			class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[1].default.AmmoClass)
		)
	)
		return false;
		
	if(instr(caps(Weapon), "TRANSLAUNCHER") > -1)
		return false;	
	
	if(instr(caps(Weapon), "MERCURY") > -1)
		return false;		

	return true;
}


function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	Local Pawn P;
	local int BestDamage;
	local int HealthGiven;
	local int localMaxHealth;

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	//sup up the damage a bit
	if(damage > 0)
	{
		if (Damage < (OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent))
			Damage = OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent;

		Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
		Momentum *= 1.0 + DamageBonus * Modifier;
	}

	BestDamage = Max(Damage, OriginalDamage);
	
	P = Pawn(Victim);
	
	if(P != None && P.isA('Vehicle') && Vehicle(P).Driver != None)
		P = Vehicle(P).Driver;

	if (P != None && BestDamage > 0)
	{
		localMaxHealth = getMaxHealthBonus();

		if (P != None && ( P == Instigator || (P.GetTeam() == Instigator.GetTeam() && Instigator.GetTeam() != None) ) )
		{
			Momentum = vect(0,0,0);
			Damage = 0;
			
			if (!P.isA('Vehicle'))
			{
				HealthGiven = 
					Max
					(
						1,
						BestDamage * (HealthBonus * Modifier)
					);
				
				HealthGiven =
					Min
					(
						(P.HealthMax + localMaxHealth) - P.Health,
						HealthGiven
					);
				if(HardCoreInv(P.FindInventoryType(class'HardCoreInv')) != None && P != Instigator && NecroInv(Instigator.FindInventoryType(class'NecroInv')) == None) //if ally has hardcore and I am not a revenant, can't heal.
					HealthGiven = 0;
					
				if(HealthGiven > 0)
				{
					P.GiveHealth(HealthGiven, P.HealthMax + localMaxHealth);
					P.SetOverlayMaterial(ModifierOverlay, 1.0, false);
					doHealed(HealthGiven, P, localMaxHealth);
				}
			}
		}
	}

	if(HealthGiven > 0)
	{
		if (!bIdentified)
			Identify();
	}

	if(HealthGiven > 0 && P != None && PlayerController(P.Controller) != None)	
	{
		PlayerController(P.Controller).ReceiveLocalizedMessage(class'HealedConditionMessage', 0, Instigator.PlayerReplicationInfo);

		P.PlaySound(sound'PickupSounds.HealthPack',, 2 * P.TransientSoundVolume,, 1.5 * P.TransientSoundRadius);
		
		P.spawn(class'DEKEffectHealer', P,, P.Location, P.Rotation); 		
	}

	Super.NewAdjustTargetDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);
}

//this function does no healing. it serves to figure out the correct amount of exp to grant to the player, and grants it.
function doHealed(int HealthGiven, Pawn Victim, int localMaxHealth)
{
	Local HealableDamageInv Inv;
	local int ValidHealthGiven;
	local float GrantExp;
	local RPGStatsInv StatsInv;
	local float localEXPMultiplier;
	
	setupRules();
	if(rules == None)
		return;
		
	if(Victim.Controller != None && Victim.Controller.IsA('DEKFriendlyMonsterController'))
		return; //no exp for healing friendly pets. It's already self serving

	if(Instigator == Victim) 
		return; //no exp for self healing. It's already self benificial.

	Inv = HealableDamageInv(Victim.FindInventoryType(class'HealableDamageInv'));
	if(Inv != None)
	{
		ValidHealthGiven = Min(HealthGiven, Inv.Damage);
		if(ValidHealthGiven > 0)
		{
			StatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
			if (StatsInv == None)
			{
				log("Warning: No stats inv found. Healing exp not granted.");
				return;
			}

			localExpMultiplier = getExpMultiplier();

			GrantExp = localEXPMultiplier * float(ValidHealthGiven);

			Inv.Damage -= ValidHealthGiven;
			
			rules.ShareExperience(StatsInv, GrantExp);
		}

		//help keep things in check so a player never has surplus damage in storage.
		if(Inv.Damage > (Victim.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus) - Victim.Health)
			Inv.Damage = Max(0, (Victim.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus) - Victim.Health); //never let it go negative.
	}
	CheckMissionLifeMend(ValidHealthGiven, Victim);
}

simulated function CheckMissionLifeMend(int ValidHealthGiven, Pawn Victim)
{
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	
	MiInv = MissionInv(Instigator.FindInventoryType(class'MissionInv'));
	M1Inv = Mission1Inv(Instigator.FindInventoryType(class'Mission1Inv'));
	M2Inv = Mission2Inv(Instigator.FindInventoryType(class'Mission2Inv'));
	M3Inv = Mission3Inv(Instigator.FindInventoryType(class'Mission3Inv'));
	
	if (ValidHealthGiven > 0)
	{
		if (Instigator != None && Instigator != Victim && MiInv != None && !MiInv.LifeMendComplete)
		{
			if (M1Inv != None && !M1Inv.Stopped && M1Inv.LifemendActive)
			{
				M1Inv.MissionCount += ValidHealthGiven;
			}
			if (M2Inv != None && !M2Inv.Stopped && M2Inv.LifemendActive)
			{
				M2Inv.MissionCount += ValidHealthGiven;
			}
			if (M3Inv != None && !M3Inv.Stopped && M3Inv.LifemendActive)
			{
				M3Inv.MissionCount += ValidHealthGiven;
			}
			else
				return;
		}
	}
}

//function that can be overridden in subclass.
function int getMaxHealthBonus()
{
	return MaxHealth;
}

//funciton that can be overridden in subclass.
function float getExpMultiplier()
{
	return EXPMultiplier;
}

defaultproperties
{
     EXPMultiplier=0.010000
     DamageBonus=0.010000
     HealthBonus=0.050000
     MaxHealth=50
     ModifierOverlay=Shader'UTRPGTextures2.Overlays.PulseBlueShader1'
     MinModifier=1
     MaxModifier=3
     AIRatingBonus=0.090000
     PrefixPos="Healing "
}
