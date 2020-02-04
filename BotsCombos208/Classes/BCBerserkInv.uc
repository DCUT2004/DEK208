/* This object is an inventory object that is given to the player who is
 * Berserking.  Inventory objects have a function called "OwnerEvent" that is
 * called when certain things (like, say, weapon switches) happen.
 */
class BCBerserkInv extends Inventory;

var float Modifier;
var BotComboBerserk BCD;
var bool bBerserk;

replication
{
	reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
		bBerserk, Modifier;
	reliable if (Role == ROLE_Authority)
		ClientAdjustFireRate, ClientEndBerserk;
}

function DropFrom(vector StartLocation)
{
	if (Instigator != None && Instigator.Controller != None)
		SetOwner(Instigator.Controller);
}

function OwnerDied()
{
// This call will not only stop the Effect but should also trigger this object
// to EndBerserk (which should destroy this object).  Destroyed() calls
// StopEffect.
	BCD.Destroy();
}

// StartBerserk, basically.
function GiveTo(pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other, Pickup);
	OwnerEvent('ChangedWeapon'); //Set initial weapon's FireRate
}

function StopBerserk(xPawn P)
{
	if (P != Owner)
	{
		Warn("StopBerserk called but P is not owner!");
	}
	ClientEndBerserk(P);
	EndBerserk(P);
}

simulated function EndBerserk(xPawn P)
{
	bBerserk = false;
	if (P != Owner)
	{
		Warn("but P is not owner!");
		Warn(P@" "@Owner);
	}
// Set the FireRate back to normal.
	Modifier = 0;
// This calls the event for all objects in inventory - just in case there's
// something that does something like what we do - like UT2004RPG.RPGStatsInv.
	P.Inventory.OwnerEvent('ChangedWeapon');
	Destroy();
}

simulated function ClientEndBerserk(xPawn P)
{
	if (P != Owner)
		Warn("ClientEndBerserk called, P not owner!");
	EndBerserk(P);
}

/* Next three functions copied from UT2004RPG.RPGStatsInv and modified to
 * varying degrees. */

// This first one is called when "things" happen.  We're hoping that this one
// gets called *after* any others that might AdjustFireRate.
function OwnerEvent(name EventName)
{
	if (EventName == 'ChangedWeapon' && Instigator != None && Instigator.Weapon != None)
	{
		AdjustFireRate(Instigator.Weapon);
		ClientAdjustFireRate(); //OwnerEvent() is serverside-only, so need to call a client version
	}
	Super.OwnerEvent(EventName);
}

// Unlike UT2004RPG.RPGStatsInv, we operate on current FireRate, not
// default.FireRate.
simulated function AdjustFireRate(Weapon W)
{
	local float FRMod;
	local WeaponFire FireMode[2];

// In EndBerserk we change this to false, as AFR will be called again, and we
// don't want it to run.  However, we also (just in case) set Modifier to 0.
	if(!bBerserk)
		return;

	FireMode[0] = W.GetFireMode(0);
	FireMode[1] = W.GetFireMode(1);
	if (MinigunFire(FireMode[0]) != None) //minigun needs a hack because it fires differently than normal weapons
	{
		FRMod = 1.f + Modifier;
		MinigunFire(FireMode[0]).BarrelRotationsPerSec = MinigunFire(FireMode[0]).BarrelRotationsPerSec * FRMod;
		MinigunFire(FireMode[0]).FireRate = 1.f / (MinigunFire(FireMode[0]).RoundsPerRotation * MinigunFire(FireMode[0]).BarrelRotationsPerSec);
		MinigunFire(FireMode[0]).MaxRollSpeed = 65536.f*MinigunFire(FireMode[0]).BarrelRotationsPerSec;
		MinigunFire(FireMode[1]).BarrelRotationsPerSec = MinigunFire(FireMode[1]).BarrelRotationsPerSec * FRMod;
		MinigunFire(FireMode[1]).FireRate = 1.f / (MinigunFire(FireMode[1]).RoundsPerRotation * MinigunFire(FireMode[1]).BarrelRotationsPerSec);
		MinigunFire(FireMode[1]).MaxRollSpeed = 65536.f*MinigunFire(FireMode[1]).BarrelRotationsPerSec;
	}
	else if (!FireMode[0].IsA('TransFire') && !FireMode[0].IsA('BallShoot') && !FireMode[0].IsA('MeleeSwordFire'))
	{
		FRMod = 1.f + Modifier;
		if (FireMode[0] != None)
		{
			if (ShieldFire(FireMode[0]) != None) //shieldgun primary needs a hack to do charging speedup
				ShieldFire(FireMode[0]).FullyChargedTime = ShieldFire(FireMode[0]).FullyChargedTime / FRMod;
			FireMode[0].FireRate = FireMode[0].FireRate / FRMod;
			FireMode[0].FireAnimRate = FireMode[0].FireAnimRate * FRMod;
			FireMode[0].MaxHoldTime = FireMode[0].MaxHoldTime / FRMod;
		}
		if (FireMode[1] != None)
		{
			FireMode[1].FireRate = FireMode[1].FireRate / FRMod;
			FireMode[1].FireAnimRate = FireMode[1].FireAnimRate * FRMod;
			FireMode[1].MaxHoldTime = FireMode[1].MaxHoldTime / FRMod;
		}
	}
}

//Call AdjustFireRate() clientside
simulated function ClientAdjustFireRate()
{
	if (Instigator != None && Instigator.Weapon != None)
	{
		AdjustFireRate(Instigator.Weapon);
	}
}

/* End thievery from Mysterial. */

defaultproperties
{
     bReplicateInstigator=True
}
