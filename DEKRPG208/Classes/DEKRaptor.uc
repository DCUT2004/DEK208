class DEKRaptor extends ONSAttackCraft;

var bool IsLockedForSelf;
var Controller PlayerSpawner;
var Material LockOverlay;
var Color lockOnCrossHairColor;

function SetPlayerSpawner(Controller PlayerC)
{
	PlayerSpawner = PlayerC;
}

function bool TryToDrive(Pawn P)
{
	if ( (P.Controller == None) || !P.Controller.bIsPlayer || Health <= 0 )
		return false;

	// Check for Locking by engineer....
	if ( IsEngineerLocked() && P.Controller != PlayerSpawner )
	{
		if (PlayerController(P.Controller) != None)
		{
		    if (PlayerSpawner != None)
				PlayerController(P.Controller).ReceiveLocalizedMessage(class'VehicleEngLockedMessage', 0, PlayerSpawner.PlayerReplicationInfo);
			else
				PlayerController(P.Controller).ReceiveLocalizedMessage(class'VehicleEngLockedMessage', 0);
		}
		return false;
	}
	else
	{
		return super.TryToDrive(P);
	}
}

function EngineerLock()
{
    IsLockedForSelf = True;
	SetOverlayMaterial(LockOverlay, 50000.0, false);
}

function EngineerUnlock()
{
    IsLockedForSelf = False;
	SetOverlayMaterial(LockOverlay, 0.0, false);
}

function bool IsEngineerLocked()
{
    return IsLockedForSelf;
}

simulated function DrawHUD(Canvas Canvas)
{
	super.DrawHUD(Canvas);

    if (IsLocallyControlled() && ActiveWeapon < Weapons.length && Weapons[ActiveWeapon] != None && Weapons[ActiveWeapon].bShowAimCrosshair && Weapons[ActiveWeapon].bCorrectAim)
	{
		if (INAttackCraftGunA(Weapons[ActiveWeapon]).bLockedOn)
			Canvas.DrawColor = lockOnCrossHairColor;
		else
			Canvas.DrawColor = CrosshairColor;

		Canvas.DrawColor.A = 255;
		Canvas.Style = ERenderStyle.STY_Alpha;
		Canvas.SetPos(Canvas.SizeX*0.5-CrosshairX, Canvas.SizeY*0.5-CrosshairY);
		Canvas.DrawTile(CrosshairTexture, CrosshairX*2.0+1, CrosshairY*2.0+1, 0.0, 0.0, CrosshairTexture.USize, CrosshairTexture.VSize);
	}

}

defaultproperties
{
     LockOverlay=FinalBlend'D-E-K-HoloGramFX.FullFB.HoloMaterial_2'
     DriverWeapons(0)=(WeaponClass=Class'DEKRPG208.INAttackCraftGunA')
}
