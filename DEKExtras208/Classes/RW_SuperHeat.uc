//Does more damage to Ice monsters. Based off of WailOfSuicide's RW_SkaarjBane in DWRPG from the Death Warrant Invasion Servers

class RW_SuperHeat extends OneDropRPGWeapon
   HideDropDown
   CacheExempt
   config(UT2004RPG);

var RPGRules RPGRules;
var config float DamageBonus;
var config int HeatLifespan;

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
   if ( ClassIsChildOf(Weapon, class'TransLauncher') )
      return false;

   return true;
}

simulated function SetWeaponInfo()
{
   //DamageBonus = SetWeaponDamageBonus(default.DamageBonus);
   
   Super.SetWeaponInfo();
}

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
   local Pawn P;
   local int TempModifier;
   local float TempDamageBonus;
   local bool bSkaarjHit;
   Local Actor A;

   if (!bIdentified)
      Identify();

   if (Victim == None)
      return; //nothing to do

   //Prevents "weaponswitch" exploit allowing a player to use a weapon (e.g. Mines) and then switch to another weapon (e.g. Vorpal) and get the effect applied to the first weapon
   if (!CheckCorrectDamage(ModifiedWeapon, DamageType))
      return;
	  
	if (DamageType == class'DamTypeSuperHeat' || Damage <= 0)
		return;

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

   TempModifier = Modifier+1;      //Add +1 here because we want to handle 0 modifier
   TempDamageBonus = DamageBonus;
   bSkaarjHit = false;
   
  P = Pawn(Victim);

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
			}
			if (P.Health > 0)
				Burn(P);
		}
	}
	//Super(RPGWeapon).AdjustTargetDamage(Damage, Victim, HitLocation, Momentum, DamageType);
}

function Burn(Pawn P)
{
	local SuperHeatInv Inv;
	local MagicShieldInv MInv;
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	
	MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
	MiInv = MissionInv(Instigator.FindInventoryType(class'MissionInv'));
	M1Inv = Mission1Inv(Instigator.FindInventoryType(class'Mission1Inv'));
	M2Inv = Mission2Inv(Instigator.FindInventoryType(class'Mission2Inv'));
	M3Inv = Mission3Inv(Instigator.FindInventoryType(class'Mission3Inv'));
   
	if (P != None && P.Health > 0 && (!P.Controller.SameTeamAs(Instigator.Controller) || P == Instigator))
	{
		if (ClassIsChildOf(P.Class, class'FireBrute') || ClassIsChildOf(P.Class,class'FireGasbag') || ClassIsChildOf(P.Class,class'FireGiantGasbag') || ClassIsChildOf(P.Class,class'FireKrall') || ClassIsChildOf(P.Class,class'FireMercenary') || ClassIsChildOf(P.Class,Class'FireQueen') || ClassIsChildOf(P.Class,Class'FireSkaarjSuperHeat') || ClassIsChildOf(P.Class,Class'FireSkaarjTrooper') || ClassIsChildOf(P.Class,Class'LavaBioSkaarj') || ClassIsChildOf(P.Class,Class'FireSkaarjSniper') || ClassIsChildOf(P.Class,Class'FireSlith') || ClassIsChildOf(P.Class,Class'FireTitan') || ClassIsChildOf(P.Class,Class'FireSlug') || ClassIsChildOf(P.Class,Class'FireManta') || ClassIsChildOf(P.Class,Class'FireRazorFly') || ClassIsChildOf(P.Class,Class'FireSkaarjPupae') || ClassIsChildOf(P.Class,Class'FireNali') || ClassIsChildOf(P.Class,Class'FireNaliFighter') || ClassIsChildOf(P.Class,Class'FireLord') || P.IsA('FireBrute') || P.IsA('FireGasbag') || P.IsA('FireGiantGasbag') || P.IsA('FireKrall') || P.IsA('FireMercenary') || P.IsA('FireQueen') || P.IsA('FireSkaarjSuperHeat') || P.IsA('FireSkaarjSniper') || P.IsA('FireSlith') || P.IsA('FireTitan') || P.IsA('FireLord') || P.IsA('FireGiantRazorfly') || P.IsA('FireTentacle'))
			return;
		if (MInv != None)
			return;
		else
		{
			Inv = SuperHeatInv(P.FindInventoryType(class'SuperHeatInv'));
			if (Inv == None)
			{
				Inv = spawn(class'SuperHeatInv', P,,, rot(0,0,0));
				Inv.Modifier = Modifier;
				Inv.LifeSpan = HeatLifespan;
				Inv.RPGRules = RPGRules;
				Inv.GiveTo(P);
				if (Instigator != None && Instigator != P && MiInv != None && !MiInv.PyromancerComplete)
				{
					if (M1Inv != None && !M1Inv.Stopped && M1Inv.PyromancerActive)
					{
						if (Modifier <= 2)
						{
							M1Inv.MissionCount++;
						}
						else
						{
							M1Inv.MissionCount++;
							M1Inv.MissionCount++;
						}
					}
					if (M2Inv != None && !M2Inv.Stopped && M2Inv.PyromancerActive)
					{
						if (Modifier <= 2)
						{
							M2Inv.MissionCount++;
						}
						else
						{
							M2Inv.MissionCount++;
							M2Inv.MissionCount++;
						}
					}
					if (M3Inv != None && !M3Inv.Stopped && M3Inv.PyromancerActive)
					{
						if (Modifier <= 2)
						{
							M3Inv.MissionCount++;
						}
						else
						{
							M3Inv.MissionCount++;
							M3Inv.MissionCount++;
						}
					}
				}
			}
			else
			{
				Inv.Modifier = Modifier;
				Inv.LifeSpan = HeatLifespan;
			}
		}
		if (!bIdentified)
			Identify();
	}
}

defaultproperties
{
     DamageBonus=0.030000
     HeatLifespan=4
     ModifierOverlay=FinalBlend'DEKWeaponsMaster206.fX.SuperHeatFB'
     MinModifier=1
     MaxModifier=4
     AIRatingBonus=0.102000
     PostfixPos=" of Heat"
     bCanHaveZeroModifier=True
}
