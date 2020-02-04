//SolarPower combines SuperHeat, Infinity, and Energy.  Based off of WailOfSuicide's RW_SkaarjBane in DWRPG from the Death Warrant Invasion Servers

class RW_SolarPower extends RW_SuperHeat
   HideDropDown
   CacheExempt
   config(UT2004RPG);

function PostBeginPlay()
{
	Local GameRules G;
	super.PostBeginPlay();
	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			RPGRules = RPGRules(G);
			break;
		}
	}

	if(RPGRules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	local int x;
	local RPGStatsInv StatsInv;
	
	if ( Weapon.default.FireModeClass[0] != None && Weapon.default.FireModeClass[0].default.AmmoClass != None
	          && class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[0].default.AmmoClass) )
		return false;

	if(instr(caps(Weapon), "LINK") > -1)
		return false;	
	if(instr(caps(Weapon), "MINE LAYER") > -1)
		return false;		
	if(instr(caps(Weapon), "UTILITY RIFLE") > -1)
		return false;	
	if(instr(caps(Weapon), "PROASS") > -1)
		return false;		
	if(instr(caps(Weapon), "GRAVITY") > -1)
		return false;	
	if(instr(caps(Weapon), "SHIELD") > -1)
		return false;	
	if(instr(caps(Weapon), "SINGULARITY") > -1)
		return false;
	if(instr(caps(Weapon), "RAIL GUN") > -1)
		return false;
		
	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		if (StatsInv.Data.Abilities[x] == class'AbilityMagicVault' && StatsInv.Data.AbilityLevels[x] >= 3)
		return true;

	return false;
}

simulated function bool StartFire(int Mode)
{
	if (!bIdentified && Role == ROLE_Authority)
		Identify();

	return Super.StartFire(Mode);
}

function bool ConsumeAmmo(int Mode, float Load, bool bAmountNeededIsMax)
{
	if (!bIdentified)
		Identify();

	return true;
}

simulated function WeaponTick(float dt)
{
	MaxOutAmmo();

	Super.WeaponTick(dt);
}

simulated function int MaxAmmo(int mode)
{
	if (bNoAmmoInstances && HolderStatsInv != None)
		return (ModifiedWeapon.MaxAmmo(mode) * (1.0 + 0.01 * HolderStatsInv.Data.AmmoMax));

	return ModifiedWeapon.MaxAmmo(mode);
}

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
   local Pawn P;
   local int TempModifier;
   local float TempDamageBonus, AdrenalineBonus;
   local bool bSkaarjHit;
   Local Actor A;

   if (!bIdentified)
      Identify();

   if (Victim == None)
      return; //nothing to do
	  
	if (DamageType == class'DamTypeSuperHeat' || Damage <= 0)
		return;

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

   //Prevents "weaponswitch" exploit allowing a player to use a weapon (e.g. Mines) and then switch to another weapon (e.g. Vorpal) and get the effect applied to the first weapon
   if (!CheckCorrectDamage(ModifiedWeapon, DamageType))
      return;
	  
	P = Pawn(Victim);

   TempModifier = Modifier+1;      //Add +1 here because we want to handle 0 modifier
   TempDamageBonus = DamageBonus;
   bSkaarjHit = false;

   if (Damage > 0)
	{
		if (P != None)
		{
			//If we hit a Skaarj, then we need to adjust some things
			//Use IsA instead of ClassIsChildOf
			if (P.Health > 0 && !P.Controller.SameTeamAs(Instigator.Controller))
			{
				if ((ClassIsChildOf(P.Class, class'IceBrute') || ClassIsChildOf(P.Class,class'IceGasbag') || ClassIsChildOf(P.Class,class'IceGiantGasbag') || ClassIsChildOf(P.Class,class'IceKrall') || ClassIsChildOf(P.Class,class'IceMercenary') || ClassIsChildOf(P.Class,Class'IceQueen') || ClassIsChildOf(P.Class,Class'IceSkaarjFreezing') || ClassIsChildOf(P.Class,Class'IceSkaarjTrooper') || ClassIsChildOf(P.Class,Class'ArcticBioSkaarj') || ClassIsChildOf(P.Class,Class'IceSkaarjSniper') || ClassIsChildOf(P.Class,Class'IceSlith') || ClassIsChildOf(P.Class,Class'IceTitan') || ClassIsChildOf(P.Class,Class'IceSlug') || ClassIsChildOf(P.Class,Class'IceManta') || ClassIsChildOf(P.Class,Class'IceRazorFly') || ClassIsChildOf(P.Class,Class'IceSkaarjPupae') || ClassIsChildOf(P.Class,Class'IceNali') || ClassIsChildOf(P.Class,Class'IceNaliFighter') || ClassIsChildOf(P.Class,Class'IceWarlord') || P.IsA('IceBrute') || P.IsA('IceGasbag') || P.IsA('IceGiantGasbag') || P.IsA('IceKrall') || P.IsA('IceMercenary') || P.IsA('IceQueen') || P.IsA('IceSkaarjFreezing') || P.IsA('IceSkaarjSniper') || P.IsA('IceSlith') || P.IsA('IceTitan') || P.IsA('IceWarlord') || P.IsA('IceGiantRazorfly') || P.IsA('IceTentacle')))
				{
					TempDamageBonus *= 3.333;
					bSkaarjHit=true;
					A = P.spawn(class'FireMercenaryPlasmaHitEffect', P,, P.Location, P.Rotation);
					if (A != None)
					{
						A.RemoteRole = ROLE_SimulatedProxy;
					}
				
					//To reduce the effectiveness of Double Magic Modifier somewhat, we only give half the benefit for modifier levels beyond normal.
					if (Modifier > MaxModifier)
						TempModifier = MaxModifier + Min(1,(Modifier - MaxModifier)/2);

					Damage = Max(1, Damage * (1.0 + TempDamageBonus * TempModifier));
					Momentum *= 1.0 + TempDamageBonus * Modifier;

					if (bSkaarjHit && Pawn(Owner).HasUDamage())
						Damage /= 2;
				}
				else
				{
					Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
					Momentum *= 1.0 + DamageBonus * Modifier;
				}
				
				
				AdrenalineBonus = Damage;
//				if (Monster(Victim) != None && Instigator.HasUDamage())
//					AdrenalineBonus *= 2;					// double damage will not be taken into account until later

				if (AdrenalineBonus > Pawn(Victim).Health)
					AdrenalineBonus = Pawn(Victim).Health;

				AdrenalineBonus *= 0.007 * Modifier;

				if ( UnrealPlayer(Instigator.Controller) != None && Instigator.Controller.Adrenaline < Instigator.Controller.AdrenalineMax
					&& Instigator.Controller.Adrenaline + AdrenalineBonus >= Instigator.Controller.AdrenalineMax && !Instigator.InCurrentCombo() )
					UnrealPlayer(Instigator.Controller).ClientDelayedAnnouncementNamed('Adrenalin', 15);
					Instigator.Controller.Adrenaline = FMin(Instigator.Controller.Adrenaline + AdrenalineBonus, Instigator.Controller.AdrenalineMax);

				A = Spawn(Class'DEKEffectEnergy',,,Owner.Location,rotator(Normal(HitLocation - Location)));
				if ( A != None )
				{
					A.RemoteRole = ROLE_SimulatedProxy;
					A.PlaySound(Sound'PickupSounds.AdrenelinPickup',,1.0 * Owner.TransientSoundVolume,,Owner.TransientSoundRadius);
				}
			}
			if (P.Health > 0)
				Burn(P);
		}
	}
	Super(RPGWeapon).AdjustTargetDamage(Damage, Victim, HitLocation, Momentum, DamageType);
}

defaultproperties
{
     MaxModifier=5
     PostfixPos=" of Solar Power"
}
