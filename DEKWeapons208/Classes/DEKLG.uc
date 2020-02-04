//=============================================================================
// DEK Sniper "Zap" Rifle - Increases fire rate, lowers damage.
//=============================================================================
class DEKLG extends XWeapons.SniperRifle
    config(user);

defaultproperties
{
     FireModeClass(0)=Class'DEKWeapons208.DEKLGFire'
     BringUpTime=0.280000
     AIRating=0.630000
     CurrentRating=0.630000
     Description="DEKWeapons1.1 Version.  ZAP.  The Lightning Gun was a high-power energy rifle capable of ablating even the heaviest carapace armor.  But it was slow.  Jefe made it faster.  ZAP."
     Priority=134
     HudColor=(G=180,R=135)
     CustomCrosshair=7
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross1"
     PickupClass=Class'DEKWeapons208.DEKLGPickup'
     ItemName="D-E-K ZAP Gun"
}
