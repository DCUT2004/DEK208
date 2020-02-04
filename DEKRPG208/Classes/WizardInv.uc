class WizardInv extends Inventory
	config(UT2004RPG);

var RPGWeapon Weapon;
var bool oldCanThrow;
var Pawn PawnOwner;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{	
	if(Other == None)
	{
		destroy();
		return;
	}
	PawnOwner = Other;
	
	setTimer(0.1, true);
	beginWeapon();

	Super.GiveTo(Other);
}

simulated function BeginWeapon()
{
	local Vehicle V;
	local Pawn RealInstigator;

	if(Weapon != None)
		return; // something is already running.

	V = Vehicle(PawnOwner);
	if (V != None && V.Driver != None)
		RealInstigator = V.Driver;
	else
		RealInstigator = PawnOwner;

	Weapon = RPGWeapon(RealInstigator.Weapon);
	if (Weapon != None)
	{
		if(Weapon.isA('RW_Speedy'))
			(RW_Speedy(Weapon)).deactivate();
		Weapon.Modifier = Weapon.Modifier / 2;
		oldCanThrow = Weapon.bCanThrow;
		Weapon.bCanThrow = false;
		if(Weapon.isA('RW_Speedy'))
			(RW_Speedy(Weapon)).activate();
		IdentifyWeapon(Weapon);
	}
}

simulated function Timer()
{
	if (PawnOwner == None || PawnOwner.Health <= 0)
		Destroy();
	if(PawnOwner != None && PawnOwner.Weapon != None && PawnOwner.Weapon != Weapon)
	{
		EndWeapon();
		BeginWeapon();
	}
}

simulated function EndWeapon()
{
	if(Weapon != None)
	{
		if(Weapon.isA('RW_Speedy'))
			(RW_Speedy(Weapon)).deactivate();
		Weapon.Modifier = Weapon.Modifier*2;
		Weapon.bCanThrow = oldCanThrow;

		if(Weapon.isA('RW_Speedy'))
			(RW_Speedy(Weapon)).activate();
		IdentifyWeapon(Weapon);
	}
	Weapon = None;
}

function IdentifyWeapon(RPGWeapon weapon)
{
	local WeaponIdentifierInv inv;
	
	inv = PawnOwner.spawn(class'WeaponIdentifierInv');
	inv.Weapon = Weapon;
	inv.giveTo(PawnOwner);
}

simulated function Destroyed()
{
	EndWeapon();
	Super.Destroyed();
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
