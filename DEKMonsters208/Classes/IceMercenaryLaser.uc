class IceMercenaryLaser extends ONSAttackCraftPlasmaProjectileBlue;

var float FreezeLifespan;
var config float BaseChance;
var sound FreezeSound;

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local Vector X, RefNormal, RefDir;
	local FreezeInv Inv;
	local Pawn P;
	Local Actor A;
	local MagicShieldInv MInv;

	if (Other == Instigator)
		return;
    if (Other == Owner)
		return;
	
    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
    {
        if (Role == ROLE_Authority)
        {
            X = Normal(Velocity);
            RefDir = X - 2.0*RefNormal*(X dot RefNormal);
            Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
        }
        Destroy();
    }
	if ( Role == ROLE_Authority )
	{
		Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
		// now see if we can freeze em
		P = Pawn(Other);
		if (P != None && P.Controller != None && P.Health > 0 && !P.Controller.SameTeamAs(InstigatorController) && class'RW_Freeze'.static.canTriggerPhysics(P))
		{
			MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
			if (MInv == None)
			{
				Inv = FreezeInv(P.FindInventoryType(class'FreezeInv'));
				//dont add to the time a pawn is already frozen. It just wouldn't be fair.
				if (Inv == None)
				{
					Inv = spawn(class'FreezeInv', P,,, rot(0,0,0));
					Inv.Modifier = 2;
					Inv.LifeSpan = 3.0;
					Inv.GiveTo(P);
					A = P.spawn(class'IceKrallSmoke', P,, P.Location, P.Rotation);  // cant use IceSmoke as it assumes a PlayerController exists
					if (A != None)
					{
						A.RemoteRole = ROLE_SimulatedProxy;
						A.PlaySound(FreezeSound,,2.5*Other.TransientSoundVolume,,Other.TransientSoundRadius);
					}
				}
				Explode(HitLocation,Normal(HitLocation-Other.Location));
			}
			else
				Explode(HitLocation,Normal(HitLocation-Other.Location));
		}
	}
}

defaultproperties
{
     FreezeLifespan=4.000000
     BaseChance=25.000000
     FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
     HitEffectClass=Class'DEKMonsters208.IceMercenaryPlasmaHitEffect'
     PlasmaEffectClass=Class'DEKMonsters208.IceMercenaryPlasmaEffect'
     Speed=2500.000000
     MaxSpeed=2500.000000
     DamageRadius=100.000000
     MyDamageType=Class'DEKMonsters208.DamTypeIceMercenary'
     ExplosionDecal=None
}
