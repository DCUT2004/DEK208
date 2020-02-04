class ProAssAmmo extends Ammunition;
/*var() float fRechargeInterval;
var() int	iRechargeAmount;
var() bool	bRecharge;


simulated function PostBeginPlay()
{
	if (Role == ROLE_Authority && bRecharge )
	{
		SetTimer(fRechargeInterval, True);
	}

	Super.PostBeginPlay();
}
simulated function UpdateRechargeRate(float fNewInterval )
{
	if (Role == ROLE_Authority && bRecharge )
	{
		SetTimer(fNewInterval, True);
	}
}

function Timer()
{
	local Weapon W;
	log("timer is running");
	if ( Instigator != None )
	{
		log("instigator is not none");
                W = Weapon(Instigator.FindInventoryType(class'ProAssault'));
		if ( W != None && !W.IsFiring() )
		{
			log("shouldaddammo");
                        AddAmmo(3);
			if ( AmmoAmount <= 0 )
				AmmoAmount = 2;
		}
	}		
}
  */

defaultproperties
{
     MaxAmmo=100
     InitialAmount=25
     PickupClass=Class'DEKWeapons208.ProAssAmmoPickup'
     IconMaterial=Texture'HUDContent.Generic.HUD'
     IconCoords=(X1=336,Y1=82,X2=382,Y2=125)
     ItemName="Bullets"
}
