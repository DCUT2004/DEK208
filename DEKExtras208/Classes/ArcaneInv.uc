class ArcaneInv extends Inventory;

var Pawn PawnOwner;
var bool bPoison, bKnockback, bLoot, bNull, bRage, bVampire, bVorpal, bFreeze, bHeat, bEnergy;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		bPoison, bKnockback, bLoot, bNull, bRage, bVampire, bVorpal, bFreeze, bHeat, bEnergy;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if(Other == None)
	{
		destroy();
		return;
	}
	if (Other != None)
		PawnOwner = Other;
		
	SetTimer(15, True);
	Super.GiveTo(Other);
}

simulated function Timer()
{
	local int Chance;
	
	local RW_Arcane W;
	if (PawnOwner != None && PawnOwner.Health > 0 && PawnOwner.Controller != None)
	{
		if (PawnOwner.Weapon != None)
			W = RW_Arcane(PawnOwner.Weapon);
		if (W != None)
		{
			Chance = Rand(10);
			switch (Chance)
			{
				case 0:
					bPoison = True;
					bKnockback = False;
					bLoot = False;
					bNull = False;
					bRage = False;
					bVampire = False;
					bVorpal = False;
					bFreeze = False;
					bHeat = False;
					bEnergy = False;
					PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'ArcanePoisonMessage');
					break;
				case 1:
					bPoison = False;
					bKnockback = True;
					bLoot = False;
					bNull = False;
					bRage = False;
					bVampire = False;
					bVorpal = False;
					bFreeze = False;
					bHeat = False;
					bEnergy = False;
					PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'ArcaneKnockbackMessage');
					break;
				case 2:
					bPoison = False;
					bKnockback = False;
					bLoot = True;
					bNull = False;
					bRage = False;
					bVampire = False;
					bVorpal = False;
					bFreeze = False;
					bHeat = False;
					bEnergy = False;
					PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'ArcaneLootMessage');
					break;
				case 3:
					bPoison = False;
					bKnockback = False;
					bLoot = False;
					bNull = True;
					bRage = False;
					bVampire = False;
					bVorpal = False;
					bFreeze = False;
					bHeat = False;
					bEnergy = False;
					PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'ArcaneNullMessage');
					break;
				case 4:
					bPoison = False;
					bKnockback = False;
					bLoot = False;
					bNull = False;
					bRage = True;
					bVampire = False;
					bVorpal = False;
					bFreeze = False;
					bHeat = False;
					bEnergy = False;
					PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'ArcaneRageMessage');
					break;
				case 5:
					bPoison = False;
					bKnockback = False;
					bLoot = False;
					bNull = False;
					bRage = False;
					bVampire = True;
					bVorpal = False;
					bFreeze = False;
					bHeat = False;
					bEnergy = False;
					PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'ArcaneVampireMessage');
					break;
				case 6:
					bPoison = False;
					bKnockback = False;
					bLoot = False;
					bNull = False;
					bRage = False;
					bVampire = False;
					bVorpal = True;
					bFreeze = False;
					bHeat = False;
					bEnergy = False;
					PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'ArcaneVorpalMessage');
					break;
				case 7:
					bPoison = False;
					bKnockback = False;
					bLoot = False;
					bNull = False;
					bRage = False;
					bVampire = False;
					bVorpal = False;
					bFreeze = True;
					bHeat = False;
					bEnergy = False;
					PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'ArcaneFreezeMessage');
					break;
				case 8:
					bPoison = False;
					bKnockback = False;
					bLoot = False;
					bNull = False;
					bRage = False;
					bVampire = False;
					bVorpal = False;
					bFreeze = False;
					bHeat = True;
					bEnergy = False;
					PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'ArcaneHeatMessage');
					break;
				case 9:
					bPoison = False;
					bKnockback = False;
					bLoot = False;
					bNull = False;
					bRage = False;
					bVampire = False;
					bVorpal = False;
					bFreeze = False;
					bHeat = False;
					bEnergy = True;
					PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'ArcaneEnergyMessage');
					break;
					
			}	
		}
	}
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
