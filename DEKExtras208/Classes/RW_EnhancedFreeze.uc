//Does more damage to fire monsters. Based off of WailOfSuicide's RW_SkaarjBane in DWRPG from the Death Warrant Invasion Servers

class RW_EnhancedFreeze extends OneDropRPGWeapon
	HideDropDown
	CacheExempt
	config(UT2004RPG);

var Sound FreezeSound;
var config float DamageBonus;

function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	if(damage > 0)
	{
		if (Damage < (OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent))
			Damage = OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent;
	}

	Super.NewAdjustTargetDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);
}

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	Local Actor A;
	local int TempModifier;
	local float TempDamageBonus;
	local bool bSkaarjHit;

	if (!bIdentified)
		Identify();

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;
		
	TempModifier = Modifier+1;      //Add +1 here because we want to handle 0 modifier
	TempDamageBonus = DamageBonus;
	bSkaarjHit = false;
	
	P = Pawn(Victim);

	if(damage > 0)
	{			
		//If we hit a Fire Monster, then we need to adjust some things
		//Use IsA instead of ClassIsChildOf
		if (P != None && P.Health > 0 && !P.Controller.SameTeamAs(Instigator.Controller))
		{
			if (ClassIsChildOf(P.Class, class'FireBrute') || ClassIsChildOf(P.Class,class'FireGasbag') || ClassIsChildOf(P.Class,class'FireGiantGasbag') || ClassIsChildOf(P.Class,class'FireKrall') || ClassIsChildOf(P.Class,class'FireMercenary') || ClassIsChildOf(P.Class,Class'FireQueen') || ClassIsChildOf(P.Class,Class'FireSkaarjSuperHeat') || ClassIsChildOf(P.Class,Class'FireSkaarjTrooper') || ClassIsChildOf(P.Class,Class'LavaBioSkaarj') || ClassIsChildOf(P.Class,Class'FireSkaarjSniper') || ClassIsChildOf(P.Class,Class'FireSlith') || ClassIsChildOf(P.Class,Class'FireTitan') || ClassIsChildOf(P.Class,Class'FireSlug') || ClassIsChildOf(P.Class,Class'FireManta') || ClassIsChildOf(P.Class,Class'FireRazorFly') || ClassIsChildOf(P.Class,Class'FireSkaarjPupae') || ClassIsChildOf(P.Class,Class'FireNali') || ClassIsChildOf(P.Class,Class'FireNaliFighter') || ClassIsChildOf(P.Class,Class'FireLord') || P.IsA('FireBrute') || P.IsA('FireGasbag') || P.IsA('FireGiantGasbag') || P.IsA('FireKrall') || P.IsA('FireMercenary') || P.IsA('FireQueen') || P.IsA('FireSkaarjSuperHeat') || P.IsA('FireSkaarjSniper') || P.IsA('FireSlith') || P.IsA('FireTitan') || P.IsA('FireLord') || P.IsA('FireGiantRazorfly') || P.IsA('FireTentacle'))
			{
				//Freeze weapons do more damage to Fire Monsters
				TempDamageBonus *= 3.333;
				//Because we don't want Freeze to be able to be tripled, we note here whether we hit a Fire Monster
				bSkaarjHit=true;
				A = P.spawn(class'IceMercenaryPlasmaHitEffect', P,, P.Location, P.Rotation);
				if (A != None)
				{
					A.RemoteRole = ROLE_SimulatedProxy;
				}
				//To reduce the effectiveness of Double Magic Modifier somewhat, we only give half the benefit for modifier levels beyond normal.
				if (Modifier > MaxModifier)
					TempModifier = MaxModifier + Min(1,(Modifier - MaxModifier)/2);
			
				Damage = Max(1, Damage * (1.0 + TempDamageBonus * TempModifier));
				Momentum *= 1.0 + TempDamageBonus * Modifier;
		
				//If we hit a Fire Monster and we have double damage or triple damage going, reduce the total damage. We do this here because we want to reduce the total modified damage, not just the base damage.
				if (bSkaarjHit && Pawn(Owner).HasUDamage())
					Damage /= 2;
			}
			else
			{
				Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
				Momentum *= 1.0 + DamageBonus * Modifier;
			}
		}
		if (P != None && P.Health > 0)
			Freeze(P);
	}
	//Super(RPGWeapon).AdjustTargetDamage(Damage, Victim, HitLocation, Momentum, DamageType);	
}

function Freeze(Pawn P)
{
	local FreezeInv Inv;
	local Actor A;
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
	
	if (P != None && P.Health > 0 && canTriggerPhysics(P) && (!P.Controller.SameTeamAs(Instigator.Controller) || P == Instigator))
	{
		if (ClassIsChildOf(P.Class, class'IceBrute') || ClassIsChildOf(P.Class,class'IceGasbag') || ClassIsChildOf(P.Class,class'IceGiantGasbag') || ClassIsChildOf(P.Class,class'IceKrall') || ClassIsChildOf(P.Class,class'IceMercenary') || ClassIsChildOf(P.Class,Class'IceQueen') || ClassIsChildOf(P.Class,Class'IceSkaarjFreezing') || ClassIsChildOf(P.Class,Class'IceSkaarjTrooper') || ClassIsChildOf(P.Class,Class'LavaBioSkaarj') || ClassIsChildOf(P.Class,Class'IceSkaarjSniper') || ClassIsChildOf(P.Class,Class'IceSlith') || ClassIsChildOf(P.Class,Class'IceTitan') || ClassIsChildOf(P.Class,Class'IceSlug') || ClassIsChildOf(P.Class,Class'IceManta') || ClassIsChildOf(P.Class,Class'IceRazorFly') || ClassIsChildOf(P.Class,Class'IceSkaarjPupae') || ClassIsChildOf(P.Class,Class'IceNali') || ClassIsChildOf(P.Class,Class'IceNaliFighter') || ClassIsChildOf(P.Class,Class'IceWarlord') || P.IsA('IceBrute') || P.IsA('IceGasbag') || P.IsA('IceGiantGasbag') || P.IsA('IceKrall') || P.IsA('IceMercenary') || P.IsA('IceQueen') || P.IsA('IceSkaarjFreezing') || P.IsA('IceSkaarjSniper') || P.IsA('IceSlith') || P.IsA('IceTitan') || P.IsA('IceWarlord') || P.IsA('IceGiantRazorfly') || P.IsA('IceTentacle'))
			return;
		if (MInv != None)
			return;
		else
		{		
			Inv = FreezeInv(P.FindInventoryType(class'FreezeInv'));
			//dont add to the time a pawn is already frozen. It just wouldn't be fair.
			if (Inv == None)
			{
				Inv = spawn(class'FreezeInv', P,,, rot(0,0,0));
				Inv.Modifier = Modifier;
				Inv.LifeSpan = Modifier;
				Inv.GiveTo(P);
				if (Instigator != None && Instigator != P && MiInv != None && !MiInv.FrostmancerComplete)
				{
					if (M1Inv != None && !M1Inv.Stopped && M1Inv.FrostmancerActive)
					{
						if (Modifier <= 3)
						{
							M1Inv.MissionCount++;
						}
						else
						{
							M1Inv.MissionCount++;
							M1Inv.MissionCount++;
						}
					}
					if (M2Inv != None && !M2Inv.Stopped && M2Inv.FrostmancerActive)
					{
						if (Modifier <= 3)
						{
							M2Inv.MissionCount++;
						}
						else
						{
							M2Inv.MissionCount++;
							M2Inv.MissionCount++;
						}
					}
					if (M3Inv != None && !M3Inv.Stopped && M3Inv.FrostmancerActive)
					{
						if (Modifier <= 3)
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
				A = P.spawn(class'DEKEffectArctic', P,, P.Location, P.Rotation); 
				if (A != None)
				{
					A.RemoteRole = ROLE_SimulatedProxy;
						A.PlaySound(FreezeSound,,2.5*P.TransientSoundVolume,,P.TransientSoundRadius);
				}	
			}
		}
		if (!bIdentified)
			Identify();
	}
}

static function bool canTriggerPhysics(Pawn victim)
{
	local DruidGhostInv dgInv;
	local GhostInv gInv;

	if(victim == None)
		return true;
	
	//cant heal the dead...
	dgInv = DruidGhostInv(Victim.FindInventoryType(class'DruidGhostInv'));
	if(dgInv != None && !dgInv.bDisabled)
		return false;

	//cant heal the dead...
	gInv = GhostInv(Victim.FindInventoryType(class'GhostInv'));
	if(gInv != None && !gInv.bDisabled)
		return false;

	if(Victim.PlayerReplicationInfo != None && Victim.PlayerReplicationInfo.HasFlag != None)
		return false;
	
	return true;
}

defaultproperties
{
     FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
     DamageBonus=0.030000
     ModifierOverlay=TexPanner'DEKWeaponsMaster206.fX.GreyPanner'
     MinModifier=3
     MaxModifier=6
     AIRatingBonus=0.025000
     PrefixPos="Freezing "
}
