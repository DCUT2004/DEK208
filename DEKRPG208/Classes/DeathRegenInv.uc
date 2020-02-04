class DeathRegenInv extends Inventory;

var int RegenAmount;
var int RegenPerLevel;
var config int MaxRegenAmount;

function PostBeginPlay()
{
	SetTimer(1.0, true);

	Super.PostBeginPlay();
}

function Timer()
{
	local ShroudInv Inv;
	
	if (Instigator == None || Instigator.Health <= 0)
	{
		Destroy();
		return;
	}
	
	Inv = ShroudInv(Instigator.FindInventoryType(class'ShroudInv'));
	
	if (Inv != None)
	{
		if (Inv.NumPlayers > 0)
		{
			RegenAmount = RegenPerLevel*Inv.NumPlayers;
			if (RegenAmount > MaxRegenAmount)
				RegenAmount = MaxRegenAmount;
			Instigator.GiveHealth(RegenAmount, Instigator.HealthMax);
		}
	}
}

defaultproperties
{
	 MaxRegenAmount=20
	 RegenPerLevel=1
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
