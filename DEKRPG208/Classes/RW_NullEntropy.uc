class RW_NullEntropy extends OneDropRPGWeapon
	HideDropDown
	CacheExempt
	config(UT2004RPG);

var config float DamageBonus;

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

	//super.NewAdjustTargetDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);
	if (!bIdentified)
		Identify();
		
	P = Pawn(Victim);

	if (P != None && P.Health > 0)
	{
		MInv = MagicShieldInv(Pawn(Victim).FindInventoryType(class'MagicShieldInv'));
		MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
	}
	
	if (Instigator != None && Instigator.Health > 0)
	{
		MiInv = MissionInv(Instigator.FindInventoryType(class'MissionInv'));
		M1Inv = Mission1Inv(Instigator.FindInventoryType(class'Mission1Inv'));
		M2Inv = Mission2Inv(Instigator.FindInventoryType(class'Mission2Inv'));
		M3Inv = Mission3Inv(Instigator.FindInventoryType(class'Mission3Inv'));
	}
		
	if (MInv == None && P != None && P.Health > 0)
	{
		if(damage > 0)
		{
			if (Damage < (OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent))
				Damage = OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent;

			Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
			if(Instigator == None)
				return;

			//if(Victim != None && Victim.isA('Vehicle'))
			//	return;
		
			if (P.IsA('Vehicle'))
				return;

			//P = Pawn(Victim);
			//if(P == None || !class'RW_Freeze'.static.canTriggerPhysics(P))
			//	return;
			
			if (!class'RW_Freeze'.static.canTriggerPhysics(P))
				return;

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
						if (Modifier <= 2)
							M1Inv.MissionCount++;
						else if (Modifier <= 4)
						{
							M1Inv.MissionCount++;
							M1Inv.MissionCount++;
						}
						else
						{
							M1Inv.MissionCount++;
							M1Inv.MissionCount++;
							M1Inv.MissionCount++;
						}
					}
					if (M2Inv != None && !M2Inv.Stopped && M2Inv.NullmancerActive)
					{
						if (Modifier <= 2)
							M2Inv.MissionCount++;
						else if (Modifier <= 4)
						{
							M2Inv.MissionCount++;
							M2Inv.MissionCount++;
						}
						else
						{
							M2Inv.MissionCount++;
							M2Inv.MissionCount++;
							M2Inv.MissionCount++;
						}
					}
					if (M3Inv != None && !M3Inv.Stopped && M3Inv.NullmancerActive)
					{
						if (Modifier <= 2)
							M3Inv.MissionCount++;
						else if (Modifier <= 4)
						{
							M3Inv.MissionCount++;
							M3Inv.MissionCount++;
						}
						else
						{
							M3Inv.MissionCount++;
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
	}
	else
		return;
}

defaultproperties
{
     DamageBonus=0.050000
     ModifierOverlay=Shader'MutantSkins.Shaders.MutantGlowShader'
     MinModifier=1
     MaxModifier=6
     PrefixPos="Null Entropy "
}
