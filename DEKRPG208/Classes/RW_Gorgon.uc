//Gorgon is the combination of Null Entropy and Penetrating.

class RW_Gorgon extends OneDropRPGWeapon
	HideDropDown
	CacheExempt
	config(UT2004RPG);

var config float DamageBonus;

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	local int x;
	local RPGStatsInv StatsInv;

	if ( Weapon.default.FireModeClass[0] != None && Weapon.default.FireModeClass[0].default.AmmoClass != None
	          && class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[0].default.AmmoClass) )
		return false;
	
	if ( ClassIsChildOf(Weapon, class'MercuryLauncher') || ClassIsChildOf(Weapon, class'INAVRiL') || ClassIsChildOf(Weapon, class'ONSAVRiL') || ClassIsChildOf(Weapon, class'FlakCannon') || ClassIsChildOf(Weapon, class'LinkGun') || ClassIsChildOf(Weapon, class'RocketLauncher') || ClassIsChildOf(Weapon, class'ONSMineLayer') || ClassIsChildOf(Weapon, class'PlasmaGrenadeLauncher') || ClassIsChildOf(Weapon, class'ONSGrenadeLauncher') || ClassIsChildOf(Weapon, class'BioRifle'))
		return false;
		
	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		if (StatsInv.Data.Abilities[x] == class'AbilityMagicVault' && StatsInv.Data.AbilityLevels[x] >= 1)
		return true;

	return false;


}

function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	Local NullEntropyInv Inv;
	local MagicShieldInv MInv;
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	super.NewAdjustTargetDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);
	if (!bIdentified)
		Identify();

	if(damage > 0)
	{
		if (Damage < (OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent))
			Damage = OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent;

		Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
		if(Instigator == None)
			return;

		if(Victim != None && Victim.isA('Vehicle'))
			return;

		P = Pawn(Victim);
		if(P == None || !class'RW_Freeze'.static.canTriggerPhysics(P))
			return;

		MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
		MiInv = MissionInv(Instigator.FindInventoryType(class'MissionInv'));
		M1Inv = Mission1Inv(Instigator.FindInventoryType(class'Mission1Inv'));
		M2Inv = Mission2Inv(Instigator.FindInventoryType(class'Mission2Inv'));
		M3Inv = Mission3Inv(Instigator.FindInventoryType(class'Mission3Inv'));
		
		if (MInv == None)
		{
			if(P.FindInventoryType(class'NullEntropyInv') != None)
				return ;

			Inv = spawn(class'NullEntropyInv', P,,, rot(0,0,0));
			if(Inv == None)
				return; //wow

			if (Inv != None)
			{
				Inv.LifeSpan = (0.1 * Modifier) + Modifier;
				Inv.Modifier = Modifier;
				Inv.GiveTo(P);
				if (Instigator != None && MiInv != None && !MiInv.NullmancerComplete)
				{
					if (M1Inv != None && !M1Inv.Stopped && M1Inv.NullmancerActive)
					{
						if (Modifier <= 4)
							M1Inv.MissionCount++;
						else
						{
							M1Inv.MissionCount++;
							M1Inv.MissionCount++;
						}
					}
					if (M2Inv != None && !M2Inv.Stopped && M2Inv.NullmancerActive)
					{
						if (Modifier <= 4)
							M2Inv.MissionCount++;
						else
						{
							M2Inv.MissionCount++;
							M2Inv.MissionCount++;
						}
					}
					if (M3Inv != None && !M3Inv.Stopped && M3Inv.NullmancerActive)
					{
						if (Modifier <= 4)
							M3Inv.MissionCount++;
						else
						{
							M3Inv.MissionCount++;
							M3Inv.MissionCount++;
						}
					}
				}				
			}

			Momentum.X = 0;
			Momentum.Y = 0;
			Momentum.Z = 0;
		}
		else
			return;
	}
}

function AdjustTargetDamage(out int Damage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	local int i;
	local vector X, Y, Z, StartTrace;

	if (HitLocation == vect(0,0,0))
		return;

	for (i = 0; i < NUM_FIRE_MODES; i++)
		if (InstantFire(FireMode[i]) != None && InstantFire(FireMode[i]).DamageType == DamageType)
		{
			if (!bIdentified)
				Identify();
			//HACK - compensate for shock rifle not firing on crosshair
			if (ShockBeamFire(FireMode[i]) != None && PlayerController(Instigator.Controller) != None)
			{
				StartTrace = Instigator.Location + Instigator.EyePosition();
				GetViewAxes(X,Y,Z);
				StartTrace = StartTrace + X*class'ShockProjFire'.Default.ProjSpawnOffset.X;
				if (!WeaponCentered())
					StartTrace = StartTrace + Hand * Y*class'ShockProjFire'.Default.ProjSpawnOffset.Y + Z*class'ShockProjFire'.Default.ProjSpawnOffset.Z;
				InstantFire(FireMode[i]).DoTrace(HitLocation + Normal(HitLocation - StartTrace) * Victim.CollisionRadius * 2, rotator(HitLocation - StartTrace));
			}
			else
				InstantFire(FireMode[i]).DoTrace(HitLocation + Normal(HitLocation - (Instigator.Location + Instigator.EyePosition())) * Victim.CollisionRadius * 2, rotator(HitLocation - (Instigator.Location + Instigator.EyePosition())));
			return;
		}
}

defaultproperties
{
     DamageBonus=0.050000
     ModifierOverlay=TexRotator'DEKWeaponsMaster206.fX.GorgonRotator'
     MinModifier=3
     MaxModifier=6
     PrefixPos="Gorgon "
}
