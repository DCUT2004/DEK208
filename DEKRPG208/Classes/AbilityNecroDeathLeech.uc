class AbilityNecroDeathLeech extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float LevMultiplier;
var config float MaxDBMultiplier;
var config float MaxDRMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ShroudInv Inv;
	
	if (Other.IsA('Monster'))
		return;
	
	Inv = ShroudInv(Other.FindInventoryType(class'ShroudInv'));
	if (Inv == None)
	{
		Inv = Other.spawn(class'ShroudInv', Other,,, rot(0,0,0));
		Inv.GiveTo(Other);
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local ShroudInv InvDB, InvDR;
	local float DamageMultiplier;
	local float ReductionMultiplier;
	
	if(bOwnedByInstigator && Damage > 0)
	{
		if (Instigator != None)
		{
			InvDB = ShroudInv(Instigator.FindInventoryType(class'ShroudInv'));
			if (InvDB != None && InvDB.NumPlayers > 0)
			{
				DamageMultiplier = (1 + (AbilityLevel * default.LevMultiplier & InvDB.NumPlayers));
				if (DamageMultiplier > default.MaxDBMultiplier)
					DamageMultiplier = default.MaxDBMultiplier;
				Damage *= DamageMultiplier;
			}
		}
	}

	if(!bOwnedByInstigator && Damage > 0 )
	{
		if (Injured != None)
		{
			InvDR = ShroudInv(Injured.FindInventoryType(class'ShroudInv'));
			if (InvDR != None && InvDR.NumPlayers > 0)
			{
				ReductionMultiplier = (AbilityLevel * default.LevMultiplier * InvDR.NumPlayers);
				if (ReductionMultiplier > default.MaxDRMultiplier)
					ReductionMultiplier = default.MaxDRMultiplier;
				Damage -= (Damage * ReductionMultiplier);
			}
		}
	}
}

defaultproperties
{
	 MaxDBMultiplier=1.8000
	 MaxDRMultiplier=0.50000	//The lower the number, the higher the damage reduction
     LevMultiplier=0.030000
	 MinDB=25
	 MinDR=25
     AbilityName="Death Leech"
     Description="Increases your cumulative damage bonus and damage reduction by 3% per level for each ally that is either dead or resurrected, up to a maximum.||You must have a Damage Bonus and Damage Reduction of at least 25 to purchase this ability.||Cost (per level): 3,5,7,9..."
     StartingCost=3
	 CostAddPerLevel=2
     MaxLevel=20
}
