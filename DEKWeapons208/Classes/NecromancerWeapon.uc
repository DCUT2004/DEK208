//dummy weapon to force switch
class NecromancerWeapon extends Weapon
	CacheExempt;
	
	
simulated function bool PutDown()
{
	if ( Instigator.PendingWeapon == self )
		Instigator.PendingWeapon = None;
    return( false ); // Never let them put the weapon away.
}

simulated function float ChargeBar()
{
	return (AmmoAmount(0)/MaxAmmo(0));
}

defaultproperties
{
     ItemName="Phantom"
     FireModeClass(0)=Class'DEKWeapons208.NecromancerWeaponFire'
     FireModeClass(1)=Class'DEKWeapons208.NecromancerWeaponFire'
     bCanThrow=False
     bForceSwitch=True
     bNoVoluntarySwitch=True
     bShowChargingBar=True
     InventoryGroup=15
     DrawScale=0.050000
	 HudColor=(R=255,B=255,G=255)
}
